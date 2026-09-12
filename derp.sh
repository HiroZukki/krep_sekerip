#!/bin/bash

# repo init
# repo init -u https://github.com/DerpFest-AOSP/android_manifest.git -b 17 --git-lfs --depth=1

# Sync
# /opt/crave/resync.sh # sync source
# repo sync -c --force-sync --force-remove-dirty --no-tags --no-clone-bundle # For fixing sync error

# device source
rm -rf device/xiaomi/earth
git clone https://github.com/HiroZukki/device_xiaomi_earth.git -b DerpFest-17 device/xiaomi/earth

# Patch build soong for finishing soong ninja
# cd build/soong
# wget https://raw.githubusercontent.com/HiroZukki/krep_sekerip/refs/heads/main/soong.patch
# patch -p1 < soong.patch ; rm -rf soong.patch
# cd ../..

# build start
. build/envsetup.sh

export BUILD_USERNAME=zukki
export BUILD_HOSTNAME=sweet_bullet
export SOONG_NINJA=ninja

# start build
lunch lineage_earth-cp2a-userdebug
make installclean
mka derp

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202609*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/*202609*.zip
    cd build/soong
    git restore .
    cd ../..
    echo "Upload & cleaning done!"
else
    echo "No zip found!"
    exit 1
fi
