#!/tmp/busybox sh
#
# Flashes the modem on the galaxys4gmtd
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

set -x
PATH=/tmp:/sbin:$PATH
# Programs
BB=/tmp/busybox
MOUNT=/sbin/mount
UMOUNT=/sbin/umount

# We're passing on the partition as arg 1
MODEM_PARTITON=$1
MODEM_MOUNTPOINT=/modem
MODEM_FILE_UPDATE=/tmp/modem.bin
MODEM_FILE_FILENAME=modem.bin
MODEM_FILE_LOCATION=$MODEM_MOUNTPOINT/$MODEM_FILE_FILENAME

# Check to see if the block device exists
if [ ! -f "$MODEM_PARTITON" ]; then
    echo "Could not find block device $MODEM_PARTITON"
    echo "Not flashing the new modem file"
    exit 1
fi

# Check to see if the new modem file exists
if [ ! -f "$MODEM_FILE_UPDATE" ]; then
    echo "Could not find: $MODEM_FILE_UPDATE"
    echo "Not flashing the new modem file"
    exit 2
fi

# Make the mountpoint directory
$BB mkdir -p $MODEM_MOUNTPOINT

# Mount the partiton
$MOUNT $MODEM_PARTITON $MODEM_MOUNTPOINT
cd $MODEM_MOUNTPOINT

# Delete old modem file
$BB rm -f modem.bin

# Copy the new file
$BB cp $MODEM_FILE_UPDATE $MODEM_FILE_LOCATION

# Set the new permissions
$BB chmod 775 $MODEM_FILE_LOCATION

# Unmount the partition and delete the mountpoint
$UMOUNT -l $MODEM_MOUNTPOINT
$BB rm -rf $MODEM_MOUNTPOINT

echo "Successfully flashed new modem file"