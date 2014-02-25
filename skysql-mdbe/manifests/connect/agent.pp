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
# == Class: mdbe::connect::agent
#
# Creates the SkySQL agent to manage the MariaDB Enterprise provisioning.
#
# === Parameters
#
# [*useragent*]
#   The username of the SkySQL agent. Defaults to 'skysqlagent'.
# [*agent_password_hash*]
#   The hash of the password for the user defined in the useragent, as
#   will be written in the /etc/shadow file. Include the salt. You may
#   use the shadow_pwd.rb script included in this module.
#
# === Variables
#
#
# === Examples
#
#  class { mdbe::connect::agent:
#    useragent           => 'skysqlagent',
#    agent_password_hash => '$6$TC6y8xnU$khyU9QadbVRsdKxe.hKTW4dFnEfez4DtfmBnzHLlrC2/Ico2aUXSDWL7xSQLUKUso71oyiCTgokfGsdXcH3.h0',
#  }
#
# === Authors
#
# Massimo Siani <massimo.siani@skysql.com>
#
# === Copyright
#
# Copyright 2014 SkySQL Corporation Ab


class mdbe::connect::agent (
  $useragent           = 'skysqlagent',
  $agent_password_hash = undef,
) {

  # Variable validation
  if ! $agent_password_hash {
    fail('Agent password not set')
  }

  package { 'sudo':
    ensure => installed,
  }

  package { 'augeas':
    ensure => installed,
  }

  user { "${useragent}":
    ensure     => present,
    #expiry    => absent,
    comment    => 'The SkySQL agent',
    managehome => false,
    password   => "${password_hash}",
    shell      => '/bin/bash',
  }

  file { '/etc/sudoers':
    owner => 'root',
    group => 'root',
    mode  => '0440',
  }

  augeas { 'addtosudoers':
    context => '/files/etc/sudoers',
    changes => [
      "set spec[user = 'skysqlagent']/user skysqlagent",
      "set spec[user = 'skysqlagent']/host_group/host ALL",
      "set spec[user = 'skysqlagent']/host_group/command ALL",
      "set spec[user = 'skysqlagent']/host_group/command/runas_user ALL",
    ],
  }

}
