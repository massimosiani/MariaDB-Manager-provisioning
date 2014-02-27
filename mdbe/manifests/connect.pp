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
# == Class: mdbe::connect
#
# Handles the connect step of the MariaDB Enterprise provisioning
#
# === Parameters
#
# [*useragent*]
#   The Agent user. It will be created on the node and given sudo privileges.
# [*agent_password_hash*]
#   The password hash for the user agent. You can use the shadow_pwd function
#   in this module to obtain the hash.
# [*api_host*]
#   Where the API is hosted.
# [*node_id*]
#   The ID of the node.
# [*system_id*]
#   The ID of the system.
# [*node_state*]
#   Whether the MariaDB-Manager-API will be called at the end of the connect
#   process to update the node state metadata. Defaults to false.
#
# === Variables
#
#
# === Examples
#
#  class { mdbe::connect:
#  }
#
# === Authors
#
# Massimo Siani <massimo.siani@skysql.com>
#
# === Copyright
#
# Copyright 2014 SkySQL Corporation Ab


class mdbe::connect (
  $useragent  = 'skysqlagent',
  $agent_password_hash,
  $api_host   = undef,
  $node_id    = undef,
  $system_id  = undef,
  $node_state = false) {
  class { mdbe::connect::agent:
    useragent           => $useragent,
    agent_password_hash => $agent_password_hash,
  }

  class { mdbe::connect::install_scripts:
    require => Class['mdbe::connect::agent'],
  }

  if $node_state {
    mdbe::helper::set_node_state { 'connected':
      api_host   => "$api_host",
      node_state => 'connected',
      node_id    => "$node_id",
      system_id  => "$system_id",
      require    => Class['mdbe::connect::install_packages'],
    }
  }
}
