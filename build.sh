#!/bin/sh

echo " KILLA™-mido kernel by Rahif "

export CROSS_COMPILE="/home/rahif/android/kernels/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-"

export ARCH=arm64

make clean O=out/
make mrproper O=out/

make mido_defconfig O=out/

make -j4 O=out/
