#!/tmp/busybox sh
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
#################################
# BonsaiROM
# Edited by Fernando Barillas, Team Acid
#################################

PATH=/tmp:/sbin:$PATH
BB=/tmp/busybox
backup_dir=/sdcard/aroma-backup
backfile=$backup_dir/backup-data.cpio

if $BB test -f $backfile; then
    echo "Bonsai Install: restoring apps"
    cd / && $BB cat $backfile | $BB cpio -imu

    if $BB test $? -ne 0; then
        echo "Bonsai Install: restore failed"
        exit 1
    else
        $BB test -d /data && $BB chmod 755 /data/app
        echo "Bonsai Install: restore completed"
    fi
    exit 0
else
    echo "Bonsai Install: nothing to restore - run data-backup first!"
    exit 1
fi