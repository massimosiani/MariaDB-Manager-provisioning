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
# Date: January 2014


$manage_modulepath = $::modulepath ? {
  /w+/ => $::modulepath,
  default => "/etc/puppet/modules",
}
$manage_home = $::home ? {
  /.+/ => $::home,
  default => "/root",
}

define puppetLocalModule {
    file { "puppet-${title}":
        ensure => directory,
        force => true,
        path => "${manage_modulepath}/${title}",
        purge => true,
        recurse => true,
        replace => true,
        source => "${manage_home}/puppet-${title}-master",
    }
}

puppetLocalModule { ["mariadb", "mysql", "stdlib", "stdmod", "apt"]: }
