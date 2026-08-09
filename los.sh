#!/bin/bash

# init rom source 
repo init -u https://github.com/Lunaris-AOSP/android -b 16.2 --git-lfs --depth=1
/opt/crave/resync.sh # sync source

# Device sources
rm -rf device/xiaomi/earth vendor/xiaomi/earth kernel/xiaomi/earth
git clone https://github.com/Kitauji-High-School/android_device_xiaomi_earth.git -b Lunaris-16.2 device/xiaomi/earth

# Patching FWB
cd frameworks/base
wget https://raw.githubusercontent.com/AbuRider/scripts/refs/heads/main/fwb.patch
git am fwb.patch ; rm -rf fwb.patch
cd ../..

# Custom sources
rm -rf vendor/lineage
git clone https://github.com/Kitauji-High-School/vendor_lineage.git -b 16.2 vendor/lineage --depth=1

export BUILD_USERNAME=kumiko
export BUILD_HOSTNAME=kitauji_quartet

# build start
. build/envsetup.sh
lunch lineage_earth-bp4a-userdebug
make installclean
m bacon

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202608*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/boot.img ; ./upload.sh out/target/product/earth/*202608*.zip
    echo "Upload Done!"
else
    echo "No zip found!" 
fi
