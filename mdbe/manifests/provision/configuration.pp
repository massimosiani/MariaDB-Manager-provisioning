# This file is distributed as part of the MariaDB Enterprise. It is free
# software: you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation,
# version 2.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Copyright 2014 SkySQL Ab
#
# Author: Massimo Siani
# Date: February 2014
#
# == Class: mdbe::provision::configuration
#
# Full description of class example_class here.
#
# === Parameters
#
# Document parameters here.
#
# [*db_user*]
#   This user will replace the root user in the database, for security reasons.
# [*db_passwd*]
#   The password of the database user.
# [*rep_user*]
#   This user is used by Galera for replication purposes.
# [*rep_passwd*]
#   The password of the replication user.
# [*update_users*]
#   Whether the root-replacing user and the replication user should be
#   updated in the database. Updating the users will restart the database server.
#   Default is false.
# [*template_file*]
#   The location of the template file that contains the Galera configuration.
#   It must be a valid Puppet template file, and placed in the template folder
#   of a Puppet module.
#
# === Variables
#
#
# === Examples
#
#  class { 'mdbe::provision::configuration':
#    $db_user      => 'dbuser',
#    $db_passwd    => 'yourpwd',
#    $rep_user     => 'rep_user',
#    $rep_passwd   => 'yourreppwd',
#    $update_users => true,
#  }
#
# === Authors
#
# Massimo Siani <massimo.siani@skysql.com>
#
# === Copyright
#
# Copyright 2014 SkySQL Corporation Ab
#

class mdbe::provision::configuration (
  $db_user        = undef,
  $db_passwd      = undef,
  $rep_user       = undef,
  $rep_passwd     = undef,
  $update_users   = false,
  $template_file  = 'skysql-galera.erb',
  $wsrep_provider = '/usr/lib64/galera/libgalera_smm.so') {
  # Variable validation
  validate_bool($update_users)

  $manage_rep_user = $rep_user
  $manage_rep_password = $rep_passwd
  $manage_db_user = $db_user
  $manage_db_password = $db_passwd

  $_template_file = $template_file ? {
    /w+/    => $template_file,
    default => 'skysql-galera.erb'
  }

  $manage_mysql_conf_dir = $::osfamily ? {
    /(?i)(redhat)/ => "/etc/my.cnf.d",
    /(?i)(debian)/ => "/etc/mysql/conf.d",
    default        => "/etc/my.cnf.d",
  }

  define removeMysqlUser ($user = $title) {
    Service['start_mysql'] -> RemoveMysqlUser["$title"]

    mysql_user { "$title":
      name   => "$user",
      ensure => absent,
    }
  }

  define addMysqlUser ($user = $title, $password = "") {
    Service['start_mysql'] -> AddMysqlUser["$title"]

    mysql_user { "$title":
      name          => "$user",
      ensure        => "present",
      password_hash => mysql_password("$password"),
    }
  }

  define grantAll ($user = $title) {
    Mysql_user["$user"] -> GrantAll["$title"]

    mysql_grant { "$title":
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => ['ALL'],
      table      => '*.*',
      user       => "$user",
    }
  }

  file { 'mariadb conf.dir':
    ensure => directory,
    path   => "$manage_mysql_conf_dir",
    before => File['skysql-galera'],
  }

  file { 'skysql-galera':
    ensure  => present,
    path    => "${manage_mysql_conf_dir}/skysql-galera.cnf",
    content => template("mdbe/$_template_file"),
  }

  if $update_users {
    service { 'start_mysql':
      binary  => '/etc/init.d/mysql',
      ensure  => running,
      start   => '/etc/init.d/mysql start',
      require => File['skysql-galera'],
    }

    addMysqlUser { "${rep_user}@%": password => "$manage_rep_password", }
    addMysqlUser { "${rep_user}@localhost": password => "$manage_rep_password", }

    addMysqlUser { "${db_user}@%": password => "$manage_db_password", }

    grantAll { ["${rep_user}@%", "${rep_user}@localhost", "${db_user}@%"]: }

    anchor { 'mysql::server::end': }

    class { '::mysql::server::account_security': require => Service['start_mysql'], }

    mdbe::helper::mysql_stop { 'after_users_setup':
      require => [
        Mysql_grant["${db_user}@%"],
        Mysql_grant["${rep_user}@%"],
        Mysql_grant["${rep_user}@localhost"],
        Class['::mysql::server::account_security']],
    }
  }
}
