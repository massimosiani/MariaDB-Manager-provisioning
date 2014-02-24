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
# Full description of class mdbe here.
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
  $_puppet_modules_path = $puppet_modules_path ? {
    /w+/    => $puppet_modules_path,
    default => "/etc/puppet/modules",
  }
  $_modules_local_source = $::modules_local_source ? {
    /.+/    => $::module_local_source,
    default => "/root",
  }
  $_package_name = "MariaDB-Manager-provisioning"


  if $modules_local_install {
    class { mdbe::local_install:
      puppet_modulepath => $_puppet_modules_path,
      source_dir        => $_modules_local_source,
    }
    puppetLocalModule { ["mariadb", "mysql", "stdlib", "stdmod", "apt"]: }
  }

  class { mdbe::install_packages:
  }

  if $wsrep_provider {
    class { mdbe::set_users:
    }
  }

}
