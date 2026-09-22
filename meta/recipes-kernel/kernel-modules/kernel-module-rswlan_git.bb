# Copyright Josua Mayer <josua@solid-run.com>
DESCRIPTION = "Driver for Renesas DA16200 WiFi Module"
LICENSE = "GPL-2.0-only"

SRC_URI = "git://github.com/SolidRun/rswlan.git;protocol=https;branch=develop"
SRCREV = "da495193c45ce6602d4befb886378bb082d342c3"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

S = "${WORKDIR}/git"

inherit module

# for gcc 12 and earlier
DEBUG_PREFIX_MAP:remove = "-fcanon-prefix-map"

EXTRA_OEMAKE:append = " KDIR=${STAGING_KERNEL_DIR} CONFIG_MODULE_TYPE=spi"

do_install() {
	install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra
	install -m 644 ${B}/rswlan.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/
}
