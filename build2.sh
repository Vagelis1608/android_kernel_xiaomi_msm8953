#!/bin/bash
echo "Welcome to Soviet Kernel Builder!"
LC_ALL=C date +%Y-%m-%d
kernel_dir=$PWD
build=$kernel_dir/out
export CROSS_COMPILE=~/Android/Kernel/toolchains/aarch64-linaro-7.x/bin/aarch64-linaro-linux-
kernel="soviet"
version="r5.1"
vendor="xiaomi"
device="mido-los"
zip=zip
date=`date +"%Y%m%d-%H%M"`
config=mido_defconfig
kerneltype="Image.gz-dtb"
jobcount="-j$(grep -c ^processor /proc/cpuinfo)"
#modules_dir=$kernel_dir/"$zip"/system/lib/modules
modules_dir=$kernel_dir/"$zip"/modules
zip_name="$kernel"-"$version"-"$device".zip
export KBUILD_BUILD_USER=arnavgosain
export KBUILD_BUILD_HOST=soviet

function clean() {
rm -rf out; mkdir out; export ARCH=arm64; make clean && make mrproper
}

function build() {
make "$config"; make "$jobcount"; cp arch/arm64/boot/"$kerneltype" "$zip"/"$kerneltype"
}

function cleanbuild() {
clean; build; kzip
}

function kzip() {
rm ${HOME}/soviet/builderbot/soviet.txt
cd $kernel_dir/$zip
zip -r $build/$zip_name .
rm "$kerneltype"
cd ..
echo "Generating changelog..."
git --no-pager log --pretty=oneline --abbrev-commit 299f8a88d11ab7dc5c5d11a3f2ac7c1f65687868..HEAD > zip/changelog.txt
paste $kernel_dir/$zip/changelog.txt
rm $kernel_dir/$zip/changelog.txt
export outdir=""$build""
export out=""$build""
export OUT=""$build""
echo "Package complete: "$build"/"$zip_name""
echo "$build/$zip_name" >> ${HOME}/soviet/builderbot/soviet.txt
exit 0;
}

echo $zip_name
echo $kernel_dir

if [[ "$1" =~ "cleanbuild" ]];
then
    cleanbuild
else
    if [[ "$1" =~ "reset" ]];
    then
        git add -A
        git commit -am "lol"
        git fetch origin
        git checkout origin/cm-14.1
        git reset --hard
        clean
        build
        zip
    fi
fi

if [[ "$1" =~ "reset" ]];
then
    git add -A
    git commit -am "lol"
    git fetch origin
    git checkout origin/cm-14.1
    git reset --hard
fi

if [ -z $1]; then
cleanbuild
fi
