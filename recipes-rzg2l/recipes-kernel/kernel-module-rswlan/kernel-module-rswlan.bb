SUMMARY = "Renesas DA16i WiFi Driver"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit module

SRC_URI = "git://github.com/SolidRun/rswlan.git;branch=develop"
SRCREV="c3e175908c9cac4e7685f6851649e192b7e5c5a1"

S = "${WORKDIR}/git"

RSWLAN_MODULE_TYPE ?= "sdio"

export KDIR="${KERNEL_SRC}"
export CONFIG_MODULE_TYPE="${RSWLAN_MODULE_TYPE}"

do_install () {
	# Install kernel module
	install -v -m644 -D rswlan.ko "${D}/lib/modules/${KERNEL_VERSION}/extra/rswlan.ko"
}

RDEPENDS_${PN}:append = "kernel-module-mac80211"
