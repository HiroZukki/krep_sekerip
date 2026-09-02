#!/bin/bash

# Remove GCC since it's not needed in A17 and causing sync error
rm -rf prebuilts/gcc/linux-x86/x86 prebuilts/gcc/linux-x86/arm prebuilts/gcc/linux-x86/aarch64 # https://github.com/LineageOS/android/commit/de40b9789872d37f5bfd3ad703f801701c0e9ca6

# repo init
repo init -u https://github.com/Evolution-X/manifest -b cnb --git-lfs --depth=1
/opt/crave/resync.sh # sync source

# device source
git clone https://github.com/dreamsolister26/android_device_xiaomi_earth.git -b EvolutionX-17 device/xiaomi/earth

# Patching build soong
cd build/soong
curl -LSs "https://github.com/sweet-bullet/build_soong_evo/commit/1785dc569e3a95ac11ebe8658424123abffd4a98.patch" -o soong.patch
git am soong.patch ; rm -rf soong.patch
cd ../..

# build start
. build/envsetup.sh

export BUILD_USERNAME=zukki
export BUILD_HOSTNAME=sweet_bullet
export SOONG_NINJA=ninja

# start build
lunch lineage_earth-cp2a-userdebug
m evolution

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202609*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/*202609*.zip
    echo "Upload Done!"
else
    echo "No zip found!" 
fi
