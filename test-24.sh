#!/bin/bash

# repo init
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs --depth=1

# Crave Sync + remove dirty
/opt/crave/resync.sh
repo sync -c --force-sync --force-remove-dirty --no-tags --no-clone-bundle # For fixing sync error

# device source
git clone https://github.com/MinamiQuartet/android_device_xiaomi_earth.git -b lineage-24.0 device/xiaomi/earth
git clone https://github.com/MinamiQuartet/vendor_xiaomi_earth.git -b lineage-24.0-ims vendor/xiaomi/earth --depth=1
git clone https://github.com/MinamiQuartet/android_kernel_xiaomi_earth.git -b lineage-24.0 kernel/xiaomi/earth --depth=1
git clone https://github.com/MinamiQuartet/minami-sign.git -b keys vendor/lineage-priv/keys

# Hardware Repos
git clone https://github.com/LineageOS/android_hardware_xiaomi.git -b lineage-23.2 hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_mediatek.git -b lineage-24.0 hardware/mediatek
git clone https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git -b lineage-24.0 device/mediatek/sepolicy_vndr

# build start
. build/envsetup.sh

export BUILD_USERNAME=yuuko
export BUILD_HOSTNAME=minami_quartet
export SOONG_NINJA=ninja

# start build
lunch lineage_earth-cp2a-userdebug
mka bacon

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/earth/*202609*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/*202609*.zip
    echo "Upload Done!"
else
    echo "No zip found!"
    exit 1
fi
