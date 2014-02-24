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
# [*node_state*]
#   The node state name the node should be at the end of execution.
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
  $api_host,
  $node_id,
  $system_id,
  $node_state = false
) {

  class { mdbe::connect::agent:
    useragent           => 'skysqlagent',
    agent_password_hash => shadow_pwd('skysql', '$6$TC6y8xnU$'),
  }

  class { mdbe::connect::install_packages:
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
