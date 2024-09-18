FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://LICENSE \
    file://brcm-firmware.tar.gz \
    file://brcmfmac43455-sdio.renesas,rzg2l-sr-som.txt \
    file://lmacfw_LICENSE \
    file://lmacfw_sdio.bin \
    file://lmacfw_spi.bin \
"


do_install_append() {
	install -d ${D}${nonarch_base_libdir}/firmware

        cp -r ${WORKDIR}/firmware/* ${D}${nonarch_base_libdir}/firmware
        cp -r ${WORKDIR}/LICENSE ${D}${nonarch_base_libdir}/firmware/brcm
	install -v -m644 -D ${WORKDIR}/brcmfmac43455-sdio.renesas,rzg2l-sr-som.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.renesas,rzg2l-sr-som.txt

	install -v -m644 ${WORKDIR}/lmacfw_LICENSE ${D}${nonarch_base_libdir}/firmware/
	install -v -m644 ${WORKDIR}/lmacfw_sdio.bin ${D}${nonarch_base_libdir}/firmware/
	install -v -m644 ${WORKDIR}/lmacfw_spi.bin ${D}${nonarch_base_libdir}/firmware/
}



PACKAGES =+ "${PN}-bcm43439 ${PN}-rswlan"
LICENSE_${PN}-bcm43439 = "Firmware-broadcom_bcm43xx"
RDEPENDS_${PN}-bcm43439 += "${PN}-broadcom-license"

FILES_${PN}-bcm43455 += "${nonarch_base_libdir}/firmware/brcm/*43455*"
FILES_${PN}-bcm43439 += "${nonarch_base_libdir}/firmware/brcm/*43439* \
                        ${nonarch_base_libdir}/firmware/cypress/*43439* \
"

FILES_${PN}-rswlan = "${nonarch_base_libdir}/firmware/lmacfw_*"
