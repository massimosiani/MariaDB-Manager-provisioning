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
  $node_state = false
) {

  # Variable validation
  validate_bool($node_state)


  class { 'mdbe::provision::install_packages':
  }

  class { 'mdbe::provision::configuration':
    require => Class['mdbe::provision::install_packages'],
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
