#!/sbin/sh
################################################################################
#
# Copyright (C) 2011 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public License as published
# by the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
# USA.
#
# License GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl.html>
#
################################################################################
# Created by Fernando Barillas, Team Acid
################################################################################

# Check for kernel version to see if we're using Froyo or GB
uname -r | grep '2.6.35'

# Since we're checking for GB, success will return 0, otherwise 1 (Froyo)
exit $?