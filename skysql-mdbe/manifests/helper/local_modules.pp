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
# Copyright 2014 SkySQL Ab
#
# Author: Massimo Siani
# Date: February 2014
#
# == Define: local_modules
#
# Installs a Puppet module from a local directory.
#
# === Parameters
#
# [*puppet_modulepath*]
#   The puppet modulepath. Usually this is /etc/puppet/modules.
#
# [*source_dir*]
#   The source directory of the local module to install.
#
# === Examples
#
#   mdbe::helper::local_modules { 'module_name':
#     puppet_modulepath => '/etc/puppet/modules',
#     source_dir        => '/root',
#   }
#
# === Authors
#
# Massimo Siani <massimo.siani@skysql.com>
#
# === Copyright
#
# Copyright 2014 SkySQL Corporation Ab
#


define mdbe::helper::local_modules (
  $puppet_modulepath,
  $source_dir
) {

  file { "puppet-${title}":
    ensure  => directory,
    force   => true,
    path    => "${puppet_modulepath}/${title}",
    purge   => true,
    recurse => true,
    replace => true,
    source  => "${source_dir}/puppet-${title}-master",
  }

}
