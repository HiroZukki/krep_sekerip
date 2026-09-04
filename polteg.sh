#!/bin/bash

# repo init
repo init -u https://github.com/VoltageOS/manifest.git -b 17 --git-lfs --depth=1
/opt/crave/resync.sh # sync source

# device source
git clone https://github.com/HiroZukki/device_xiaomi_earth.git -b Voltage-17 device/xiaomi/earth --depth=1

# Patching build soong
cd build/soong
wget https://raw.githubusercontent.com/HiroZukki/krep_sekerip/refs/heads/main/patch_soong.patch
git am patch_soong.patch ; rm -rf patch_soong.patch
cd ../..

# setup build enviroment
. build/envsetup.sh

export BUILD_USERNAME=zukki
export BUILD_HOSTNAME=sweet_bullet
export SOONG_NINJA=ninja

# start build
brunch earth userdebug

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202609*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/*202609*.zip
    echo "Upload Done!"
else
    echo "No zip found in out/ dir!" 
    exit 1
fi
