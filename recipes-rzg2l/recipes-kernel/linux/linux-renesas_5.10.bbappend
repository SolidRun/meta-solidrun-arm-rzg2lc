FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# avoid applying patches from meta-rz-graphics twice
SRC_URI_remove_rzg2l = "file://0002-Workaround-GPU-driver-remove-power-domains-of-GPU-no.patch"
SRC_URI_remove_rzv2l = "file://0002-Workaround-GPU-driver-remove-power-domains-v2l.patch"

KERNEL_URL = " \
    git://github.com/SolidRun/linux-stable.git"
BRANCH = "rz-5.10-cip36-sr"
SRCREV = "e9f31bb50889f93cdf8f2e1706a74913e867e074"

# Applying custom kernel defconfig 
SRC_URI += "file://kernel.extra"

do_patch_append() {
    cat ${WORKDIR}/kernel.extra >> ${S}/arch/arm64/configs/defconfig
}

COMPATIBLE_MACHINE_rzg2lc-hummingboard = "(rzg2lc-hummingboard)"
COMPATIBLE_MACHINE_rzg2l-hummingboard = "(rzg2l-hummingboard)"
COMPATIBLE_MACHINE_rzv2l-hummingboard = "(rzv2l-hummingboard)"


