#!/tmp/busybox sh
#
# Performs backup of the efs partition
# This script assumes that you already mounted all the necessary partitions
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

PATH=/tmp:/sbin:$PATH
BB=/tmp/busybox
backup_dir=/sdcard/aroma-backup
efs_mountpoint=/efs
efs_backfile=$backup_dir/efs-`$BB date +"%m-%d-%y_%H-%M"`.tar

# Make sure that the aroma backup directory exists
$BB test ! -d $backup_dir && $BB mkdir $backup_dir

echo 'Backing up efs'
cd $efs_mountpoint

# We'll store the results of ls, if there are no files it will be blank
is_empty=`ls $efs_mountpoint`

if [ efs == efs"$is_empty" ]; then
    # The /efs partition was empty, we're not attempting a backup
    echo "ERROR: nv_data.bin file not found, backup CANNOT be created."
    echo "exiting."
    exit 1
fi

# We're going to create a tarball of efs, then create an md5sum for it
$BB tar cf $efs_backfile * && \
$BB md5sum $efs_backfile > $efs_backfile.md5

# Test to see if the backup succeeded
if $BB test $? -ne 0; then
    echo "efs backup failed"
    exit 1
else
    echo "efs backup completed"
fi
exit 0