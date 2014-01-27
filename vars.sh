#!/bin/bash
#
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


tmp=$(puppet config print modulepath)
tmp1=${tmp##*:}
mkdir -p $tmp1

export FACTER_MODULEPATH=${tmp1}

export FACTER_HOME=$(cd; pwd)

export rep_username=repuser
export rep_password=repuser1
export db_username=dbuser
export db_password=dbuser1

if [ -f /usr/lib64/galera/libgalera_smm.so ] ; then
    FACTER_WSREP_PROVIDER=/usr/lib64/galera/libgalera_smm.so
elif [ -f /usr/lib/galera/libgalera_smm.so ] ; then
    FACTER_WSREP_PROVIDER=/usr/lib/galera/libgalera_smm.so
else
    FACTER_WSREP_PROVIDER="N/A"
fi
export FACTER_WSREP_PROVIDER
