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
#
# == Class: mdbe::provision::install_packages
#
# Manages the package installation for MariaDB Enterprise
#
# === Parameters
#
# Document parameters here.
#
# [*ntp_servers*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
#
# === Examples
#
#  class { 'mdbe::provision::install_packages':
#  }
#
# === Authors
#
# Author Name <author@example.com>
#
# === Copyright
#
# Copyright 2014 SkySQL Corporation Ab


class mdbe::provision::install_packages (

  $packages       = undef,
  $extra_packages = undef

) {

  $mariadb_client = $::operatingsystem ? {
    /(?i)(centos|redhat)/ => "MariaDB-client",
    /(?i)(ubuntu|debian)/ => "mariadb-client",
    default               => "MariaDB-client",
  }

  $manage_netcat = $::osfamily ? {
    /(?i)(redhat)/ => "nc",
    /(?i)(debian)/ => "netcat",
  }

  $packages_needed = [ "curl", "percona-xtrabackup", "$manage_netcat", "$mariadb_client" ]


  class { 'mariadb':
    version        => '5.5',
    galera_install => true,
    service_enable => false,
    service_ensure => 'stopped',
  }

  package { $packages_needed:
    ensure  => "present",
    require => Class['mariadb'],
  }

  # Debian does seem to explicitly include the datadir option by default
  if $::osfamily =~ /(?i)(redhat)/ {
    exec { 'datadir':
      command => "/bin/echo [mysqld] >> /etc/my.cnf ; /bin/echo datadir=/var/lib/mysql >> /etc/my.cnf",
      require => Class['mariadb'],
    }
  }

}
