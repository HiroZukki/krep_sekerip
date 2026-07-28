#!/bin/bash
rm -rf .repo/local_manifests

# Init source
repo init --depth=1 -u https://github.com/SilverEuphonium/android_manifest.git -b 16.0 --git-lfs --no-clone-bundle

# Clone local manifests
git clone https://github.com/SilverEuphonium/gatau-ap.git -b ascp .repo/local_manifests

# sync source 
if [ -f /opt/crave/resync.sh ]; then
    /opt/crave/resync.sh
else
    repo sync -c --force-sync --no-tags --no-clone-bundle
fi

export BUILD_USERNAME=kumiko
export BUILD_HOSTNAME=kitauji_quartet

. build/envsetup.sh
lunch earth-cp2a-userdebug
mka bacon

# Upload to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202607*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/boot.img ; ./upload.sh out/target/product/earth/*202607*.zip 
fi
echo "hame"
