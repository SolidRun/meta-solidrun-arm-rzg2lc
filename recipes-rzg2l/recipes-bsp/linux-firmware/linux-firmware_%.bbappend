FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://LICENSE \
    file://brcm-firmware.tar.gz \
"


do_install_append() {
	install -d ${D}${nonarch_base_libdir}/firmware
    cp -r ${WORKDIR}/firmware/* ${D}${nonarch_base_libdir}/firmware
    cp -r ${WORKDIR}/LICENSE ${D}${nonarch_base_libdir}/firmware/brcm
}

# FILES_${PN} += "${nonarch_base_libdir}/firmware"