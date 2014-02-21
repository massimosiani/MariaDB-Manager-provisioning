#!/bin/bash
# This file is distributed as part of the MariaDB Enterprise.  It is free
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
# Copyright 2012-2014 SkySQL Ab
#
# Author: Massimo Siani
# Date: February 2014
#
# Parameters:


cd $(dirname $0)
if [[ $# -lt 1 ]] ; then
	exit 1
fi

password=$1
salt=$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c8)
echo $salt
password_hash=$(ruby shadow_pwd.rb $password '$6$'${salt})

log_info Connecting node...
cat > pp/connect.pp << End-of-connect
package { 'sudo':
ensure => installed,
}

package { 'augeas':
ensure => installed,
}

user { 'skysqlagent':
ensure     => present,
#expiry => absent,
comment => 'The SkySQL agent',
managehome => false,
password => '$password_hash',
shell => '/bin/bash',
}

file { "/etc/sudoers":
owner   => "root",
group   => "root",
mode    => "440",
}

augeas { "addtosudoers":
context => "/files/etc/sudoers",
changes => [
"set spec[user = 'skysqlagent']/user skysqlagent",
"set spec[user = 'skysqlagent']/host_group/host ALL",
"set spec[user = 'skysqlagent']/host_group/command ALL",
"set spec[user = 'skysqlagent']/host_group/command/runas_user ALL",
],
}    
End-of-connect

puppet apply pp/connect.pp
