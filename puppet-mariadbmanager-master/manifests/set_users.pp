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
# Manage mysql users


class mariadbmanager::setUsers (

  $update_users = false,
  $db_user,
  $db_passwd,
  $rep_user,
  $rep_passwd

) {

  # Variable validation
  validate_bool($update_users)

  $manage_rep_user     = $rep_user
  $manage_rep_password = $rep_passwd
  $manage_db_user      = $db_user
  $manage_db_password  = $db_passwd

  $manage_mysql_conf_dir = $::osfamily ? {
    /(?i)(redhat)/ => "/etc/my.cnf.d",
    /(?i)(debian)/ => "/etc/mysql/conf.d",
  }

  define removeMysqlUser (
    $user = $title
  ) {
    Service["mysql"] -> RemoveMysqlUser["$title"]

    mysql_user { "$title":
      name   => "$user",
      ensure => absent,
    }
  }

  define addMysqlUser (
    $user     = $title,
    $password = ""
  ) {
    Service["mysql"] -> AddMysqlUser["$title"]

    mysql_user { "$title":
      name          => "$user",
      ensure        => "present",
      password_hash => mysql_password("$password"),
    }
  }

  define grantAll (
    $user = $title
  ) {
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
    content => template('mariadbmanager/skysql-galera.erb'),
    before  => Service['mysql'],
  }

  if $update_users {
    service { 'mysql':
      ensure => running,
    }
    addMysqlUser { "${rep_user}@%": password => "$manage_rep_password",}
    addMysqlUser { "${db_user}@%": password  => "$manage_db_password",}
    grantAll { [ "${rep_user}@%", "${db_user}@%" ]: }

    anchor { 'mysql::server::end': }
    class { '::mysql::server::account_security':
      require => Service["mysql"],
    }

    exec { "/etc/init.d/mysql stop":
      require => [ Mysql_grant["$db_user@%"], Mysql_grant["$rep_user@%"], Class['::mysql::server::account_security'] ],
    }
  }

}
