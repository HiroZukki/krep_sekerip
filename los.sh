#!/bin/bash
rm -rf .repo/local_manifests

# init rom source 
repo init -u https://github.com/AbuRider/evolusix_manifest.git -b cnb --git-lfs --depth=1

# Device source
git clone https://github.com/SilverEuphonium/gatau-ap.git -b evok .repo/local_manifests

# Sync source
/opt/crave/resync.sh

export BUILD_USERNAME=kumiko
export BUILD_HOSTNAME=kitauji_quartet

# build start
. build/envsetup.sh
lunch lineage_earth-cp2a-userdebug
m evolution

# Upload files to gofile
if [ -f out/target/product/earth/*202607*.zip ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/boot.img ; ./upload.sh out/target/product/earth/*202607*.zip
fi
