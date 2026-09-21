#!/bin/bash

# remove old device source
rm -rf device/xiaomi/earth vendor/xiaomi/earth kernel/xiaomi/earth
rm -rf hardware/xiaomi hardware/mediatek device/mediatek/sepolicy_vndr

# repo init
repo init -u https://github.com/aobuta-prjkt/pixelos_manifest.git -b seventeen --git-lfs --depth=1

# Crave Sync + remove dirty
/opt/crave/resync.sh
repo sync -c --force-sync --force-remove-dirty --no-tags --no-clone-bundle # For fixing sync error

# device source
git clone https://github.com/MinamiQuartet/android_device_xiaomi_earth.git -b PixelOS-17 device/xiaomi/earth

# build start
. build/envsetup.sh

export BUILD_USERNAME=yuuko
export BUILD_HOSTNAME=minami_quartet
export SOONG_NINJA=ninja

# start build
breakfast earth userdebug
make installclean
m pixelos

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202609*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/PixelOS_*.zip
    echo "Upload Done!"
else
    echo "No zip found!"
    exit 1
fi
