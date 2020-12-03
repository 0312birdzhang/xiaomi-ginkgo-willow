#!/bin/bash
set -ex

TMPDOWN=$1
INSTALL_MOD_PATH=$2
HERE=$(pwd)
source "${HERE}/deviceinfo"
basename "${deviceinfo_kernel_source}"
KERNEL_DIR="${TMPDOWN}/$(basename "${deviceinfo_kernel_source}")"
OUT="${TMPDOWN}/KERNEL_OBJ"

mkdir -p "$OUT"

case "$deviceinfo_arch" in
    aarch64*) ARCH="arm64" ;;
    arm*) ARCH="arm" ;;
    x86_64) ARCH="x86_64" ;;
    x86) ARCH="x86" ;;
esac

export ARCH
export CROSS_COMPILE=$TMPDOWN/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=$TMPDOWN/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
PATH=$$TMPDOWN/linux-x86/clang-r365631c/bin/:$TMPDOWN/aarch64-linux-android-4.9/bin/:$PATH
export PATH

cd "$KERNEL_DIR"
make O="$OUT" $deviceinfo_kernel_defconfig
make O="$OUT" CC=$CC -j$(nproc --all)
make O="$OUT" CC=$CC INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH="$INSTALL_MOD_PATH" modules_install
