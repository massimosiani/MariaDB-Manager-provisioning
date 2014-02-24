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
# [*useragent*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
# [*agent_password_hash*]
#   The hash of the password for the user defined in the useragent, as
#   will be written in the /etc/shadow file. Include the salt. You may
#   use the shadow_pwd.rb script included in this module.
# [*node_state*]
#   The node state name the node should be at the end of execution.
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
    }
  }

  $_repo_file = '/etc/yum.repos.d/MariaDB-Manager.repo'

  exec { "retrieve_repo":
    command => "wget -q ${_remote_repo} -O ${_repo_file}",
    path    => $::path,
  }

  package { 'MariaDB-Manager-GREX':
    ensure => installed,
  }
}
