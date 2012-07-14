#!/tmp/busybox sh
## Flashes the modem on the galaxys4gmtd
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
