# Copyright Josua Mayer <josua@solid-run.com>
DESCRIPTION = "Driver for Murata WiFi Modules"
LICENSE = "GPL-2.0-only"

SRC_URI = "git://github.com/SolidRun/cyw-fmac.git;protocol=https;branch=imx-kirkstone-jaculus"
SRCREV = "4939b3eb11d3b9b13c62589ee732f59b1f55bf83"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

S = "${WORKDIR}/git"

inherit module

KERNEL_SPLIT_MODULES = "0"

# for gcc 12 and earlier
DEBUG_PREFIX_MAP:remove = "-fcanon-prefix-map"

EXTRA_OEMAKE:append = " KLIB_BUILD=${STAGING_KERNEL_BUILDDIR}"

do_configure() {
	oe_runmake CC="${BUILD_CC}" LEX=flex defconfig-brcmfmac
}

do_compile() {
	oe_runmake modules
}

do_install() {
	find * -type f -name "*.ko" -exec install -v -m644 -D {} "${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/updates/{}" \;
	install -Dm0644 Module.symvers ${D}${includedir}/${BPN}/Module.symvers
	sed -e 's:${B}/::g' -i ${D}${includedir}/${BPN}/Module.symvers
}
