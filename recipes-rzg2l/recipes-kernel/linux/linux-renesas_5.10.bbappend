FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# avoid applying patches from meta-rz-graphics twice
SRC_URI_remove_rzg2l = "file://0002-Workaround-GPU-driver-remove-power-domains-of-GPU-no.patch"
SRC_URI_remove_rzv2l = "file://0002-Workaround-GPU-driver-remove-power-domains-v2l.patch"

KERNEL_URL = " \
    git://github.com/SolidRun/linux-stable.git"
BRANCH = "rz-5.10-cip36-sr"
SRCREV = "e9f31bb50889f93cdf8f2e1706a74913e867e074"

# Applying custom kernel defconfig 
SRC_URI:append = " file://kernel_extra.cfg"

SRC_URI:append = " ${@bb.utils.contains("DISTRO_FEATURES", "apparmor", " file://apparmor.cfg", "" ,d)}"

COMPATIBLE_MACHINE:solidrun-rz = "(solidrun-rz)"
