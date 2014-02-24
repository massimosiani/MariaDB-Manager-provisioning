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
# == Define: set_node_state
#
# Exploits the MariaDB-Manager-API to write the node state metadata.
#
# === Parameters
#
# [*node_state*]
#   The node state to be set.
#
# [*source_dir*]
#   The source directory of the local module to install.
#
# === Examples
#
#   mdbe::helper::set_node_state { 'connected':
#     node_state => 'connected',
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


define mdbe::helper::set_node_state (
  $api_host,
  $node_state,
  $node_id,
  $system_id
) {

  $_method = "PUT"
  $_request_uri = "system/${system_id}/node/${node_id}"
  $full_url = "http://${api_host}/restfulapi/${_request_uri}"
  $api_auth_date = generate('/bin/date', '--rfc-2822')
  $md5_chksum = generate("echo -n $request_uri$auth_key$api_auth_date | md5sum | awk '{print $1}'")
  $api_auth_header = "api-auth-${auth_key_number}-${md5_chksum}"

  exec{ "$title":
    command => "curl -s -S -X $_method -H \"Date:$api_auth_date\" -H \"Authorization:$api_auth_header\" \
        \"$full_url\" -H \"Accept:application/json\" \"state=${node_state}\"",
  }

}
