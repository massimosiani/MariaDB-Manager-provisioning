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


if [ $# -lt 1 ] ; then
    echo "Agent node fqdn necessary"
fi

cd $(dirname $0)
agentNode=$1
sitepp=/etc/puppet/manifests/site.pp

echo >> $sitepp
echo >> $sitepp
echo "node '$agentNode' {" >> $sitepp
echo "$(sed '/#/d' start_first_node.pp)" >> $sitepp
echo "}" >> $sitepp
