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

class {	'mdbe':
password_hash => '$6$HPv.9rS4i2ErSVj2$4.gpqE7CIbk9Inw5TFLrEP9ZsGM52D6P6NZpV6.6pJI7/Rn3ui33IlWwO1r2D8VuTKVIxRLcCYX97J2hJT.af1',
modules_local_install => false,
update_users =>	false,
}
