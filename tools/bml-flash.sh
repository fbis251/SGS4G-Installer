#!/tmp/aroma/busybox sh
#
# Universal Updater Script for Samsung Galaxy S Phones
# (c) 2011 by Teamhacksung
# Edited by Fernando Barillas
# Team Acid
# GSM version
#

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:/tmp/aroma:$PATH

TMP_PATH=/tmp/aroma

check_mount() {
    if ! $TMP_PATH/busybox grep -q $1 /proc/mounts ; then
        $TMP_PATH/busybox mkdir -p $1
        $TMP_PATH/busybox umount -l $2
        if ! $TMP_PATH/busybox mount -t $3 $2 $1 ; then
            $TMP_PATH/busybox echo "Cannot mount $1."
            exit 1
        fi
    fi
}

set_log() {
    rm -rf $1
    exec >> $1 2>&1
}

# check if we're running on a bml or mtd device
if $TMP_PATH/busybox test -e /dev/block/bml7 ; then
    # we're running on a bml device

    # make sure sdcard is mounted
    check_mount /sdcard /dev/block/mmcblk0p1 vfat

    # everything is logged into /mnt/sdcard/cyanogenmod_bml.log
    set_log /sdcard/cyanogenmod_bml.log

    # make sure efs is mounted
    check_mount /efs /dev/block/stl3 rfs

    # create a backup of efs
    if $TMP_PATH/busybox test -e /sdcard/backup/efs.tar ; then
        $TMP_PATH/busybox mv /sdcard/backup/efs.tar /sdcard/backup/efs-$$.tar
        $TMP_PATH/busybox mv /sdcard/backup/efs.tar.md5 /sdcard/backup/efs-$$.tar.md5
    fi
    $TMP_PATH/busybox rm -f /sdcard/backup/efs.tar
    $TMP_PATH/busybox rm -f /sdcard/backup/efs.tar.md5

    $TMP_PATH/busybox mkdir -p /sdcard/backup

    cd /efs
    $TMP_PATH/busybox tar cf /sdcard/backup/efs.tar *

    # Now we checksum the file. We'll verify later when we do a restore
    cd /sdcard/backup/
    $TMP_PATH/busybox md5sum -t efs.tar > efs.tar.md5

    # write the package path to sdcard cyanogenmod.cfg
    if $TMP_PATH/busybox test -n "$UPDATE_PACKAGE" ; then
        PACKAGE_LOCATION=${UPDATE_PACKAGE#/mnt}
        $TMP_PATH/busybox echo "$PACKAGE_LOCATION" > /sdcard/cyanogenmod.cfg

        # Make sure that the zip file gets flashed upon reboot
        $TMP_PATH/busybox echo "install_zip(\"$PACKAGE_LOCATION\");" > /sdcard/extendedcommand
        $TMP_PATH/busybox echo "install $PACKAGE_LOCATION" > /sdcard/openrecoveryscript
    fi

    # Scorch any ROM Manager settings to require the user to reflash recovery
    $TMP_PATH/busybox rm -f /sdcard/clockworkmod/.settings

    # write new kernel to boot partition
    $TMP_PATH/flash_image boot $TMP_PATH/boot.img
    if [ "$?" != "0" ] ; then
        $TMP_PATH/busybox echo "Failed to write kernel to boot partition"
        exit 3
    fi
    $TMP_PATH/busybox echo "Successfully wrote kernel to boot partition"
    $TMP_PATH/busybox sync

    /sbin/reboot
    exit 0
fi
