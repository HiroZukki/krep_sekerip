#!/bin/bash

# repo init --depth=1 -u https://github.com/Lunaris-AOSP/android -b test --git-lfs
# /opt/crave/resync.sh # sync source

rm -rf device/xiaomi/earth vendor/lineage-priv/keys
git clone https://github.com/Kitauji-High-School/android_device_xiaomi_earth.git -b Lunaris-16.2 device/xiaomi/earth

# Edit Source 
rm -rf vendor/prebuilts vendor/lineage
git clone https://github.com/SilverEuphonium/vendor_lineage.git -b 16.2 vendor/lineage

export BUILD_USERNAME=kumiko
export BUILD_HOSTNAME=kitauji_quartet

. build/envsetup.sh
lunch lineage_earth-bp4a-userdebug
make installclean
mka bacon

# Upload to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202607*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/boot.img ; ./upload.sh out/target/product/earth/*202607*.zip 
fi
echo "hame"
