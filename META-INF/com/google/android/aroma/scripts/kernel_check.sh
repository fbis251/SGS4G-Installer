#!/sbin/sh

# Check for kernel version to see if we're using Froyo or GB
uname -r | grep '2.6.35'

# Since we're checking for GB, success will return 0, otherwise 1 (froyo)
exit $?

