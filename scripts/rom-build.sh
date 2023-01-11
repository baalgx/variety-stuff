#! /bin/sh
#
# balgxmr's build script
# 
# rem: Current path is ~/Documents/SW

cd ../.. || exit 1 ## This is only due to current path
mkdir pixelos ## This is only due to current path
cd pixelos/ || exit 1 ## This is only due to current path

echo "===================== Build setup ====================="
echo "1) Build ROM"
echo "2) Build kernel"
echo "3) Sync ROM"
echo "======================================================="
echo ""
echo "Selección: " 
read seleccion
echo ""

android_version='thirteen'
device_codename='cepheus'

case $seleccion in 
    1|2|3) 
esac

if [ $seleccion = '1' ];
then
    echo "Building rom..."
    source build/envsetup.sh
    export CCACHE_DIR=~/ccache
    mkdir -p ~/ccache 
    lunch aosp_${device_codename}-user
    make installclean
    mka bacon

elif [ $seleccion = '2' ]
then
    echo "Building kernel..."
    cd kernel/xiaomi/${device_codename}
    source build.sh

elif [ $seleccion = '3' ]
then
    echo "Are you sure you wanna sync the rom...? "
    echo "(y/n):"
    read seguridad
    if [ $seguridad = 'y' ]
    then
        echo "Cleaning some repos first... "
        echo
        rm -rf hardware/qcom-caf/sm8150
        rm -rf packages/resources/devicesettings
        rm -rf hardware/xiaomi

        echo "Force sync only or clean?"
        echo "'f' for force sync, 'c' for clean: "
        read selection2
        if [ $selection2 = 'f' ]
        then
            echo "Force syncing ROM..."
            repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

        elif [ $selection2 = 'c' ]
        then
            echo "Syncing clean"
            rm -rf .repo
            repo init -u https://github.com/PixelOS-AOSP/manifest.git -b $android_version
            repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

        else 
            echo "ah? Invalid input, aborting!"
        fi

    elif [ $seguridad = 'n' ]
    then
        echo "Más te vale seleccionar bien el número, bal!"

    else 
        echo "Invalid input, abort abort!!!"
    fi
else 
    echo "Invalid input"
fi