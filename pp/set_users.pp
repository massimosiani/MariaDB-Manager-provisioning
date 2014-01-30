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
# Date: January 2014
#
# Manage mysql users


$rep_user = $::rep_username
$manage_rep_password = $::rep_password
$db_user = $::db_username
$manage_db_password = $::db_password

$manage_mysql_conf_dir = $::osfamily ? {
  /(?i)(redhat)/ => "/etc/my.cnf.d",
  /(?i)(debian)/ => "/etc/mysql/conf.d",
}

file { 'conf.dir':
    ensure => directory,
    path => "$manage_mysql_conf_dir",
    before => File['skysql-galera'],
}

file { 'skysql-galera':
    ensure => present,
    path => "${manage_mysql_conf_dir}/skysql-galera-puppet.cnf",
    content => template('mariadb/skysql-galera.erb'),
    before => Service['mysql'],
}

service { 'mysql':
  ensure => 'running',
  start => ' su mysql /etc/init.d/mysql start',
}


define removeMysqlUser (
  $user = $title
) {
  Service["mysql"] -> RemoveMysqlUser["$title"]
  
  mysql_user { "$title":
    name => "$user",
    ensure => absent,
  }
}

define addMysqlUser (
  $user = $title,
  $password = ""
) {
  Service["mysql"] -> AddMysqlUser["$title"]
  
  mysql_user { "$title":
    name => "$user",
    ensure => "present",
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


removeMysqlUser { ["@localhost", "@$::hostname"]: }
addMysqlUser { "${rep_user}@%": password => "$manage_rep_password",}
addMysqlUser { "${db_user}@%": password => "$manage_db_password",}
grantAll { [ "${rep_user}@%", "${db_user}@%" ]: }


exec { "/etc/init.d/mysql stop":
  require => [ Mysql_grant["$db_user@%"], Mysql_grant["$rep_user@%"], RemoveMysqlUser["@localhost"], RemoveMysqlUser["@$::hostname"] ],
}
