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
# Date: January 2014
#
# Parameters:
# $1:		Replication username
# $2:		Replication password
# $3:		Database username (root is removed)
# $4:		Database password


cd $(dirname $0)
. ./vars.sh
refresh_variables

echo Installing Puppet modules...
puppet apply pp/install-modules.pp
echo Installing packages...
puppet apply pp/install-packages.pp
refresh_variables $1 $2 $3 $4
echo Setting up MariaDB users...
puppet apply pp/set_users.pp
