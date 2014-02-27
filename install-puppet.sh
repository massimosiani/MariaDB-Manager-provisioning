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


cd $(dirname $0)
. ./vars.sh

# TODO: find some better mechanism to upload the modules
mkdir -p /etc/puppet/modules/{mdbe,stdlib,mariadb,stdmod,mysql}
rsync --delete -r mdbe/ /etc/puppet/modules/mdbe/
rsync --delete -r puppet-stdlib-master/ /etc/puppet/modules/stdlib/
rsync --delete -r puppet-stdmod-master/ /etc/puppet/modules/stdmod/
rsync --delete -r puppet-mysql-master/ /etc/puppet/modules/mysql/
rsync --delete -r puppet-mariadb-master/ /etc/puppet/modules/mariadb/

# skip if puppet is already installed
which puppet &>/dev/null
if [ $? -eq 0 ] ; then
    exit 0
fi

osfamily=$(getOsFamily)
if [ "x$osfamily" == "xunsupported" ]; then
    log_error Unsupported distribution
    exit 1
fi


if [[ "$osfamily" == "debian" ]] ; then
    VERSION=$(lsb_release -c | cut -f2)
#    puppetPackage="puppetlabs-release-${VERSION}.deb"
#    wget https://apt.puppetlabs.com/$puppetPackage
#    sudo dpkg -i $puppetPackage
#    rm -f $puppetPackage
#    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
    sudo aptitude update
    sudo aptitude -y install puppet
    if ! grep -q repo.percona.com/apt /etc/apt/sources.list ; then
        if [[ ! -z $VERSION ]] ; then
            echo "deb http://repo.percona.com/apt $VERSION main" >> /etc/apt/sources.list
            echo "deb-src http://repo.percona.com/apt $VERSION main" >> /etc/apt/sources.list
        fi
    fi
elif [[ "$osfamily" == "redhat" ]] ; then
#    sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
    [[ -f /etc/yum.repos.d/epel.repo ]] || sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    [[ -f /etc/yum.repos.d/Percona.repo ]] || sudo rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
    sudo yum clean all
    sudo yum -y install puppet
fi
