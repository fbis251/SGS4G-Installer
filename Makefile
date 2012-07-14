# Easily update your aroma zip
# Directories
REMOTE_DIR = /sdcard/AMods/aroma
AROMA_DIR = META-INF/com/google/android
# Files
LOCAL_ZIP = installer.zip
LOCAL_ROM_ZIP = installer.rom.zip
REMOTE_ZIP = $(REMOTE_DIR)/update.zip
AROMA_BINARY = $(AROMA_DIR)/update-binary
REMOTE_AROMA_BINARY = /tmp/update-binary
# dependencies
ZIP_DEPENDENCIES = META-INF tools

default: push-rom-zip

aroma: push-zip $(AROMA_BINARY)
	adb push $(AROMA_BINARY) $(REMOTE_AROMA_BINARY)
	adb shell "chmod a+x /tmp/*"

clean:
	echo "Deleting all vim backup files"
	find . \( -name "*~" -o -name "*.swp" \) -delete
	rm -f $(LOCAL_ZIP)

make-zip: clean $(ZIP_DEPENDENCIES)
	zip --quiet -r -9 $(LOCAL_ZIP) $(ZIP_DEPENDENCIES) busybox

push-rom-zip: update-rom-zip
	adb push $(LOCAL_ROM_ZIP) $(REMOTE_ZIP)

push-zip: make-zip $(LOCAL_FILE)
	adb push $(LOCAL_ZIP) $(REMOTE_ZIP)
	echo "Installer transferred successfully!"

reboot:
	adb wait-for-device
	adb shell reboot recovery

run: aroma
	adb shell "$(REMOTE_AROMA_BINARY) 1 0 $(REMOTE_ZIP)"

update-rom-zip: $(LOCAL_ROM_ZIP) $(ZIP_DEPENDENCIES)
	zip --quiet -r -9 $(LOCAL_ROM_ZIP) $(ZIP_DEPENDENCIES)
