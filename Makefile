# Easily update your aroma zip
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
# Usage:
# make <argument>
#
# The following arguments are supported:
# default
#	(Will run whatever is under "default" below)
# aroma
#	Creates the zip and pushes the zip and the update-binary to the device
# clean
#	Cleans the temporary files
# push-rom-zip
#	Updates and pushes installer.rom.zip with the latest AROMA files
# push-zip
#	Updates the standard testing zip and pushes it to the device
# reboot
#	Reboots the device to recovery using adb
# rom-zip
#	Updates installer.rom.zip with the latest AROMA files
# run
#	Pushes update-binary to the device and starts the zip install
# zip
#	Creates the standard testing zip

################################################################################
# Only edit the lines below if you know what you're doing
################################################################################
# Directories
REMOTE_DIR = /sdcard/AMods/aroma
AROMA_DIR = META-INF/com/google/android

# Files
LOCAL_ZIP = installer.zip
LOCAL_ROM_ZIP = installer.rom.zip
REMOTE_ZIP = $(REMOTE_DIR)/update.zip
AROMA_BINARY = $(AROMA_DIR)/update-binary
REMOTE_AROMA_BINARY = /tmp/update-binary

# Dependencies
ZIP_DEPENDENCIES = META-INF tools

# Flags
ZIP_COMPRESSION = 9

# Shortcuts
ZIP_COMMAND = zip --quiet -r -$(ZIP_COMPRESSION)

default: push-rom-zip

aroma: $(AROMA_BINARY)
	adb push $(AROMA_BINARY) $(REMOTE_AROMA_BINARY)
	adb shell "chmod a+x /tmp/*"

clean:
	find . \( -name "*~" -o -name "*.swp" \) -delete
	rm -f $(LOCAL_ZIP)

push-rom-zip: rom-zip
	adb push $(LOCAL_ROM_ZIP) $(REMOTE_ZIP)

push-zip: zip $(LOCAL_ZIP)
	adb push $(LOCAL_ZIP) $(REMOTE_ZIP)

reboot:
	adb wait-for-device
	adb shell reboot recovery

rom-zip: clean $(LOCAL_ROM_ZIP) $(ZIP_DEPENDENCIES)
	$(ZIP_COMMAND) $(LOCAL_ROM_ZIP) $(ZIP_DEPENDENCIES)

run: aroma
	adb shell "$(REMOTE_AROMA_BINARY) 1 0 $(REMOTE_ZIP)"

zip: clean $(ZIP_DEPENDENCIES)
	$(ZIP_COMMAND) $(LOCAL_ZIP) $(ZIP_DEPENDENCIES)