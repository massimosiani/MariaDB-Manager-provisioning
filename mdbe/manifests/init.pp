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
# == Class: mdbe
#
# The main of the MariaDB Enterprise provisioning.
#
# === Parameters
#
# Document parameters here.
#
#
# === Variables
#
#
# === Examples
#
#  class { mdbe:
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


class mdbe (
  $useragent             = 'skysqlagent',
  $password_hash,
  $api_host              = hiera('mdbe_api_host'),
  $node_id               = hiera('mdbe_node_id'),
  $system_id             = hiera('mdbe_system_id'),
  $set_node_state        = hiera('mdbe_set_node_state'),
  $modules_local_install = false,
  $modules_local_source  = undef,
  $puppet_modules_path   = undef,
  $db_user               = undef,
  $db_passwd             = undef,
  $rep_user              = undef,
  $rep_passwd            = undef,
  $wsrep_provider        = hiera('mdbe_wsrep_provider'),
  $packages              = undef,
  $extra_packages        = undef,
  $update_users          = hiera('mdbe_update_users'),
  $template_file         = hiera('mdbe_template_file')
) {
  # Variables validation
  $_puppet_modules_path = $puppet_modules_path ? {
    /.+/    => $puppet_modules_path,
    default => "/etc/puppet/modules",
  }
  $_modules_local_source = $modules_local_source ? {
    /.+/    => $modules_local_source,
    default => "/root/MariaDB-Manager-provisioning",
  }
  $_package_name = "MariaDB-Manager-provisioning"

  if $modules_local_install {
    mdbe::helper::local_modules { ["mariadb", "mysql", "stdlib", "stdmod", "apt"]:
      puppet_modulepath => $_puppet_modules_path,
      source_dir        => $_modules_local_source,
    }
  }

  class { mdbe::connect:
    useragent           => $useragent,
    agent_password_hash => $password_hash,
    api_host            => $api_host,
    node_id             => $node_id,
    system_id           => $system_id,
    set_node_state      => $set_node_state,
  }

  class { mdbe::provision:
    db_user      => $db_user,
    db_passwd    => $db_passwd,
    rep_user     => $rep_user,
    rep_passwd   => $rep_passwd,
    update_users => $update_users,
    api_host     => $api_host,
    node_id      => $node_id,
    system_id    => $system_id,
  }

}
