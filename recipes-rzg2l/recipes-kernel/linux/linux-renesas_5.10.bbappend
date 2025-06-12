FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# avoid applying patches from meta-rz-graphics twice
SRC_URI_remove_rzg2l = "file://0002-Workaround-GPU-driver-remove-power-domains-of-GPU-no.patch"
SRC_URI_remove_rzv2l = "file://0002-Workaround-GPU-driver-remove-power-domains-v2l.patch"

KERNEL_URL = " \
    git://github.com/SolidRun/linux-stable.git"
BRANCH = "rz-5.10-cip41-sr"
SRCREV = "64a51c961145e8c02eaecf8ad6287b7b061afb2c"

KCONFIG_MODE = "alldefconfig"

# Applying custom kernel defconfig 
SRC_URI:append = " \
    file://kernel_extra.cfg \
    file://modules_compress.cfg \
    file://zram.cfg \
"

SRC_URI:append = " ${@bb.utils.contains("DISTRO_FEATURES", "apparmor", " file://apparmor.cfg", "" ,d)}"

COMPATIBLE_MACHINE:solidrun-rz = "(solidrun-rz)"
