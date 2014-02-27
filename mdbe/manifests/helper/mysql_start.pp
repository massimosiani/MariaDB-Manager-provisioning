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
# == Define: mysql_start
#
# Starts the MySQL server, without declaring the service.
# Uses the init script.
#
# === Parameters
#
# [*extra_parameters*]
#   additional parameters to be passed to the init script.
#
# === Examples
#
#   mdbe::helper::mysql_start { 'before_users_setup':
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
define mdbe::helper::mysql_start (
  $extra_parameters = ''
) {
  exec { "$title":
    command => "/etc/init.d/mysql start $extra_parameters",
  }
}
