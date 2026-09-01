#!/bin/bash

rm -rf device/xiaomi/earth
rm -rf hardware/xiaomi hardware/mediatek device/mediatek/sepolicy_vndr

# repo init
repo init -u https://github.com/aobuta-prjkt/pixelos_manifest -b seventeen --git-lfs --depth=1
/opt/crave/resync.sh # sync source

# device source
git clone https://github.com/dreamsolister26/android_device_xiaomi_earth.git -b PixelOS-17 device/xiaomi/earth

# build start
. build/envsetup.sh

export BUILD_USERNAME=zukki
export BUILD_HOSTNAME=sweet_bullet
export SOONG_NINJA=ninja

# start build
breakfast earth userdebug
m pixelos

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202609*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/PixelOS_*.zip
    echo "Upload Done!"
else
    echo "No zip found!" 
fi
