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
# Copyright 2014 SkySQL Ab
#
# Author: Massimo Siani
# Date: January 2014


# Logs an info
log_info() {
    echo "$@"
#    logger -p user.info -t Provisioning "$@"
}

# Logs an error
log_error() {
    echo "$@"
#    logger -p user.error -t Provisioning "$@"
}

# Returns the local OS family
getOsFamily() {
    if [ -f /etc/debian_version ]; then
        echo debian
    elif [ -f /etc/redhat-release ]; then
        echo redhat
    else
        echo unsupported
    fi
}

# Sets some useful variables
refresh_variables() {
    tmp=$(puppet config print modulepath 2>/dev/null)
    if [ -z "$tmp" ] ; then
        tmp="/etc/puppet/modules:/etc/puppet/modules"
    fi
    tmp1=${tmp##*:}
    mkdir -p $tmp1

    export FACTER_MODULEPATH=${tmp1}

    export FACTER_HOME=$(cd .. ; pwd)

    export FACTER_REP_USERNAME=$1
    export FACTER_REP_PASSWORD=$2
    export FACTER_DB_USERNAME=$3
    export FACTER_DB_PASSWORD=$4

    if [ -f /usr/lib64/galera/libgalera_smm.so ] ; then
        FACTER_WSREP_PROVIDER=/usr/lib64/galera/libgalera_smm.so
    elif [ -f /usr/lib/galera/libgalera_smm.so ] ; then
        FACTER_WSREP_PROVIDER=/usr/lib/galera/libgalera_smm.so
    else
        FACTER_WSREP_PROVIDER="N/A"
    fi
    export FACTER_WSREP_PROVIDER
}
