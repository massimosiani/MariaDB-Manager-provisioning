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


cd $(dirname $0)
. ./vars.sh

echo Installing Puppet modules...
puppet apply pp/install-modules.pp
echo Installing packages...
export FACTER_REP_USERNAME=$rep_username
export FACTER_REP_PASSWORD=$rep_password
export FACTER_DB_USERNAME=$db_username
export FACTER_DB_PASSWORD=$db_password
puppet apply pp/install-packages.pp
. ./vars_wsrep.sh
echo Setting up MariaDB users...
puppet apply pp/set_users.pp
