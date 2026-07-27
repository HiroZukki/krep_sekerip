#!/bin/bash

repo init --depth=1 -u https://github.com/SilverEuphonium/android_manifest.git -b 16.0 --git-lfs --no-clone-bundle
/opt/crave/resync.sh # sync source

git clone https://github.com/Kitauji-High-School/android_device_xiaomi_earth.git -b crDroid-16.2 device/xiaomi/earth

export BUILD_USERNAME=kumiko
export BUILD_HOSTNAME=kitauji_quartet

. build/envsetup.sh
brunch earth userdebug

# Upload to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202607*.zip ]; then
  wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
  chmod +x upload.sh ; ./upload.sh out/target/product/earth/boot.img ; ./upload.sh out/target/product/earth/*202607*.zip 
fi
echo "hame"
