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
# Copyright 2014 SkySQL Corporation Ab
#
# Author: Massimo Siani
# Date: February 2014
#
#
# == Class: mdbe::connect::install_scripts
#
# Install the Galera Remote Execution package of the MariaDB Enterprise package.
#
# === Parameters
#
# [*remote_repo*]
#   The MariaDB-Manager repository, leave blank for the default.
#
# === Variables
#
#
# === Examples
#
#  class { mdbe::connect::install_scripts:
#  }
#
# === Authors
#
# Massimo Siani <massimo.siani@skysql.com>
#
# === Copyright
#
# Copyright 2014 SkySQL Corporation Ab


class mdbe::connect::install_scripts (
  $remote_repo = '',
) {

  $_remote_repo = $remote_repo ? {
    ''         => $::osfamily ? {
      'RedHat' => 'http://eng01.skysql.com/pre-repo/STABLE/centos6.5_x86_64/MariaDB-Manager.repo',
      'Debian' => '',
      default  => '',
    },
    default    => '',
  }

  $_repo_file = '/etc/yum.repos.d/MariaDB-Manager.repo'

  package { 'wget':
    ensure => present,
  }

  exec { "retrieve_repo":
    command => "wget -q $_remote_repo -O $_repo_file ; sed -i 's/centos6.5_x86_64/centos6.5_x86_64-DataNode/' $_repo_file",
    path    => $::path,
    require => Package['wget'],
  }

  package { 'MariaDB-Manager-GREX':
    ensure => installed,
    require => Exec['retrieve_repo'],
  }
}
