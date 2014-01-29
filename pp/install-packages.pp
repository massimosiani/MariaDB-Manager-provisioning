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


$mariadb_client = $::operatingsystem ? {
  /(?i)(centos|redhat)/ => "MariaDB-client",
  /(?i)(ubuntu|debian)/ => "mariadb-client",
  default => "MariaDB-client",
}

$manage_netcat = $::osfamily ? {
  /(?i)(redhat)/ => "nc",
  /(?i)(debian)/ => "netcat",
}

$packages_needed = [ "curl", "percona-xtrabackup", "$manage_netcat", "$mariadb_client" ]

$manage_mysql_conf_dir = $::osfamily ? {
  /(?i)(redhat)/ => "/etc/my.cnf.d",
  /(?i)(debian)/ => "/etc/mysql/conf.d",
}

class { 'mariadb':
    version => '5.5',
    galera_install => true,
    service_enable => false,
    service_ensure => 'stopped',
}

package { $packages_needed:
    ensure => "present",
    require => Class['mariadb'],
}

file { 'conf.dir':
    ensure => directory,
    path => "$manage_mysql_conf_dir",
    before => File['skysql-galera'],
}

# Debian does seem to explicitly include the datadir option by default
if $::osfamily =~ /(?i)(redhat)/ {
  exec { 'datadir':
      command => "/bin/echo [mysqld] >> /etc/my.cnf ; /bin/echo datadir=/var/lib/mysql >> /etc/my.cnf",
      require => Class['mariadb'],
  }
}
