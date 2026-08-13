#!/bin/bash

repo init -u https://github.com/Lunaris-AOSP/android -b 16.2 --git-lfs --depth=1

git clone https://github.com/HiroZukki/gatau-ap.git -b personal .repo/local_manifests

/opt/crave/resync.sh # sync source

# Custom Source 
rm -rf vendor/lineage
git clone https://github.com/HiroZukki/vendor_lineage.git -b 16.2 vendor/lineage

export BUILD_USERNAME=zukki
export BUILD_HOSTNAME=sweet_bullet

# build start
. build/envsetup.sh
lunch lineage_earth-bp4a-userdebug
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
