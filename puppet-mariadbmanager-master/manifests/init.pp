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
# == Class: mariadb
#
# Full description of class mariadb here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { mariadbmanager:
#    db_user        => 'myuser',
#    db_passwd      => 'mypassword',
#    rep_user       => 'repluser',
#    rep_passwd     => 'replpassword',
#    wsrep_provider => '/usr/lib64/galera/libgalera_smm.so',
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
class mariadbmanager (

  $modules_local_install = true,
  $modules_local_source  = undef,
  $puppet_modules_path   = undef,
  $db_user               = undef,
  $db_passwd             = undef,
  $rep_user              = undef,
  $rep_passwd            = undef,
  $wsrep_provider        = undef,

) {

  # Variables validation
  $manage_puppet_modules_path = $puppet_modules_path ? {
    /w+/    => $puppet_modules_path,
    default => "/etc/puppet/modules",
  }
  $manage_modules_local_source = $::modules_local_source ? {
    /.+/    => $::module_local_source,
    default => "/root",
  }
  $manage_package_name = "MariaDB-Manager-provisioning"


  if $modules_local_install {
    class { mariadbmanager::localInstall:
      puppet_modulepath => $manage_puppet_modules_path,
      source_dir        => $manage_modules_local_source,
    }
    puppetLocalModule { ["mariadb", "mysql", "stdlib", "stdmod", "apt"]: }
  }

  class { mariadbmanager::installPackages:
  }

  if $wsrep_provider {
    class { mariadbmanager::setUsers:
    }
  }


}
