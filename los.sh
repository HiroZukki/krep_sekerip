#!/bin/bash

# repo init
repo init -u https://github.com/Lunaris-AOSP/android.git -b 16.2 --git-lfs --depth=1
/opt/crave/resync.sh # sync source

# device source
rm -rf device/xiaomi/earth kernel/xiaomi/earth vendor/xiaomi/earth
rm -rf hardware/mediatek hardware/xiaomi device/mediatek/sepolicy_vndr vendor/lineage-priv/keys
git clone https://github.com/HiroZukki/device_xiaomi_earth.git -b Lunaris-16.2 device/xiaomi/earth --depth=1

export BUILD_USERNAME=zukki
export BUILD_HOSTNAME=sweet_bullet

# build start
. build/envsetup.sh
lunch lineage_earth-bp4a-userdebug
make installclean
mka bacon

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
