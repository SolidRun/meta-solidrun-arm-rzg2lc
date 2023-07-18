DESCRIPTION = "CWY43439 firmware"
SECTION = "firmware"
LICENSE = "CYPRESS"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0aa08412be2ea3e0306a142531cd8f95"

SRC_URI = " \
    file://LICENSE \
    file://brcm-firmware.tar.gz \
"

S = "${WORKDIR}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
	install -d ${D}${nonarch_base_libdir}/firmware
    cp -r ${WORKDIR}/firmware/* ${D}${nonarch_base_libdir}/firmware
    cp -r ${WORKDIR}/LICENSE ${D}${nonarch_base_libdir}/firmware/brcm
}

FILES_${PN} += "${nonarch_base_libdir}/firmware"