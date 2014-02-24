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
# == Class: mdbe::provision
#
# Full description of class example_class here.
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
#  class { 'mdbe::provision':
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


class mdbe::provision (
  $packages       = undef,
  $extra_packages = undef,
  $db_user        = undef,
  $db_passwd      = undef,
  $rep_user       = undef,
  $rep_passwd     = undef,
  $update_users   = false,
  $template_file  = undef,
  $api_host       = undef,
  $node_id        = undef,
  $system_id      = undef,
  $node_state     = false
) {

  # Variable validation
  validate_bool($update_users)
  validate_bool($node_state)


  class { 'mdbe::provision::install_packages':
    packages       => $packages,
    extra_packages => $extra_packages,
  }

  class { 'mdbe::provision::configuration':
    db_user       => $db_user,
    db_passwd     => $db_passwd,
    rep_user      => $rep_user,
    rep_passwd    => $rep_passwd,
    template_file => $template_file,
    require       => Class['mdbe::provision::install_packages'],
  }

  # Set the node state
  if $node_state {
    mdbe::helper::set_node_state { 'provisioned':
      api_host   => "$api_host",
      node_state => 'provisioned',
      node_id    => "$node_id",
      system_id  => "$system_id",
      require    => Class['mdbe::provision::configuration'],
    }
  }

}
