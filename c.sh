#!/bin/bash

repo init --depth=1 -u https://github.com/Lunaris-AOSP/android -b 16.2 --git-lfs
/opt/crave/resync.sh # sync source

rm -rf device/xiaomi/earth
git clone https://github.com/Kitauji-High-School/android_device_xiaomi_earth.git -b Lunaris-16.2 device/xiaomi/earth

export BUILD_USERNAME=kumiko
export BUILD_HOSTNAME=kitauji_quartet

. build/envsetup.sh
lunch lineage_earth-bp4a-userdebug
make installclean
mka bacon
