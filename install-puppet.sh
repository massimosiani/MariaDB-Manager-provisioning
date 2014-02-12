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


if [ -f /etc/debian_version ]; then
    osfamily=debian
elif [ -f /etc/redhat-release ]; then
    osfamily=redhat
else
    echo Unsupported distribution
    exit 1
fi


if [[ "$osfamily" == "debian" ]] ; then
    VERSION=$(lsb_release -c | cut -f2)
    puppetPackage="puppetlabs-release-${VERSION}.deb"
    wget https://apt.puppetlabs.com/$puppetPackage
    sudo dpkg -i $puppetPackage
    rm -f $puppetPackage
    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
    sudo aptitude update
    sudo aptitude -y install puppet
    VERSION=$(lsb_release -c | cut -f2)
    if ! grep -q repo.percona.com/apt /etc/apt/sources.list ; then
    if [[ ! -z $VERSION ]] ; then
        echo "deb http://repo.percona.com/apt $VERSION main" >> /etc/apt/sources.list
        echo "deb-src http://repo.percona.com/apt $VERSION main" >> /etc/apt/sources.list
    fi
    fi
    elif [[ "$osfamily" == "redhat" ]] ; then
    sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
    sudo rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
    sudo yum -y install puppet
fi
