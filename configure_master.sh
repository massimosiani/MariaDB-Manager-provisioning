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
# Copyright 2014 SkySQL Ab
#
# Author: Massimo Siani
# Date: March 2014


rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
yum -y install puppet puppet-server
cp MariaDB-Manager-provisioning/hiera.yaml /etc/puppet/
mkdir /etc/puppet/hieradata
cp MariaDB-Manager-provisioning/mdbe_common.yaml /etc/puppet/hieradata/

touch /etc/puppet/manifests/site.pp
puppet resource service iptables ensure=stopped
puppet resource service puppetmaster ensure=running
