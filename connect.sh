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
# $1: the password for the skysqlagent user
#
# Description:
# 


if [[ $# -lt 4 ]] ; then
    log_info "Usage: $(basename $0) <rep_user> <rep_pwd> <db_user> <db_pwd>"
    exit 1
fi

cd $(dirname $0)
if [[ $# -lt 1 ]] ; then
	exit 1
fi

password=$1
salt=$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c8)
echo $salt
password_hash=$(ruby shadow_pwd.rb $password '$6$'${salt})

log_info Connecting node...
puppet apply pp/connect.pp
