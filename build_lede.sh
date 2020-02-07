#!/bin/bash
SCRIPT_ABS_PATH="$(cd $(dirname "$0"); pwd)"

cd $SCRIPT_ABS_PATH/lede

cat>feeds.conf<<EOF
src-link packages ${SCRIPT_ABS_PATH}/feeds/lede/packages
src-link luci ${SCRIPT_ABS_PATH}/feeds/lede/luci
src-link routing ${SCRIPT_ABS_PATH}/feeds/openwrt/routing
# src-link telephony ${SCRIPT_ABS_PATH}/feeds/openwrt/telephony
EOF

QUICK_DEFAULT="y"
read -e -p "quick config: [Y/n]" QUICK
QUICK="${QUICK:-$QUICK_DEFAULT}"
case $QUICK in
	"y")
		;;
	"n")
		./scripts/feeds update -a && ./scripts/feeds install -a
		;;
	*)
		echo -e "unknow"
		exit 1
		;;
esac

cat>.config<<'EOF'
CONFIG_TARGET_ROOTFS_EXT4FS=y
CONFIG_TARGET_ROOTFS_SQUASHFS=n
CONFIG_VMDK_IMAGES=n
CONFIG_TARGET_IMAGES_GZIP=y
CONFIG_TARGET_IMAGES_PAD=n
CONFIG_TARGET_KERNEL_PARTSIZE=32
CONFIG_TARGET_ROOTFS_PARTSIZE=1024

CONFIG_DEVEL=y
# CONFIG_CCACHE=y
CONFIG_BUILD_LOG=y

# LUCI
# theme
CONFIG_PACKAGE_luci-theme-material=y

CONFIG_PACKAGE_luci-app-aria2=y
CONFIG_PACKAGE_luci-app-clash=y

CONFIG_PACKAGE_luci-app-transmission=y

CONFIG_PACKAGE_luci-app-advanced-reboot=y

# mutil-wan
CONFIG_PACKAGE_luci-app-mwan3=y
CONFIG_PACKAGE_luci-app-minidlna=y

# addon
CONFIG_PACKAGE_luci-app-simple-adblock=y

CONFIG_PACKAGE_luci-app-travelmate=y


CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun=y

CONFIG_PACKAGE_luci-app-vpnbypass=y
EOF

make defconfig
