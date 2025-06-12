FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://LICENSE \
    file://brcm-firmware.tar.gz \
    file://brcmfmac43455-sdio.renesas,rzg2l-sr-som.txt \
	file://hci_531.bin \
	file://LICENSE.da14531 \
	file://lmacfw_spi.bin \
	file://LICENSE.da16200 \
"

LIC_FILES_CHKSUM_append = " \
	file://${WORKDIR}/LICENSE.da14531;md5=60f62cce4d4d6b90ab2c11a48be821eb \
	file://${WORKDIR}/LICENSE.da16200;md5=59fc8504af5dd513a2addda68571f157 \
"
LICENSE_append = " & Firmware-da14531 & Firmware-da16200"
NO_GENERIC_LICENSE[Firmware-da14531] = "${WORKDIR}/LICENSE.da14531"
NO_GENERIC_LICENSE[Firmware-da16200] = "${WORKDIR}/LICENSE.da16200"

do_install_append() {
	install -d ${D}${nonarch_base_libdir}/firmware
    cp -r ${WORKDIR}/firmware/* ${D}${nonarch_base_libdir}/firmware
    cp -r ${WORKDIR}/LICENSE ${D}${nonarch_base_libdir}/firmware/brcm
	install -v -m644 -D ${WORKDIR}/brcmfmac43455-sdio.renesas,rzg2l-sr-som.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.renesas,rzg2l-sr-som.txt
    install -v -m644 -D ${WORKDIR}/brcmfmac43455-sdio.renesas,rzg2l-sr-som.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.renesas,rzv2l-sr-som.txt

	install -v -m 644 -D ${WORKDIR}/hci_531.bin ${D}${nonarch_base_libdir}/firmware/renesas/hci_531.bin
	install -v -m 644 -D ${WORKDIR}/LICENSE.da14531 ${D}${nonarch_base_libdir}/firmware/renesas/LICENSE.da14531

    install -v -m 644 -D ${WORKDIR}/lmacfw_spi.bin ${D}${nonarch_base_libdir}/firmware/renesas/lmacfw_spi.bin
    ln -sv renesas/lmacfw_spi.bin ${D}${nonarch_base_libdir}/firmware/lmacfw_spi.bin
	install -v -m 644 -D ${WORKDIR}/LICENSE.da16200 ${D}${nonarch_base_libdir}/firmware/renesas/LICENSE.da16200
}



PACKAGES =+ "${PN}-bcm43439"
LICENSE_${PN}-bcm43439 = "Firmware-broadcom_bcm43xx"
RDEPENDS_${PN}-bcm43439 += "${PN}-broadcom-license"

FILES_${PN}-bcm43455 += "${nonarch_base_libdir}/firmware/brcm/*43455*"
FILES_${PN}-bcm43439 += "${nonarch_base_libdir}/firmware/brcm/*43439* \
                        ${nonarch_base_libdir}/firmware/cypress/*43439* \
"

PACKAGES =+ " ${PN}-da14531 ${PN}-da14531-license"
RDEPENDS_${PN}-da14531 += "${PN}-da14531-license"

FILES_${PN}-da14531 = "${nonarch_base_libdir}/firmware/renesas/hci_531.bin"
FILES_${PN}-da14531-license = "${nonarch_base_libdir}/firmware/renesas/LICENSE.da14531"

PACKAGES =+ " ${PN}-da16200 ${PN}-da16200-license"
RDEPENDS_${PN}-da16200 += "${PN}-da16200-license"

FILES_${PN}-da16200 = " \
	${nonarch_base_libdir}/firmware/renesas/lmacfw_spi.bin \
	${nonarch_base_libdir}/firmware/lmacfw_spi.bin \
"
FILES_${PN}-da16200-license = "${nonarch_base_libdir}/firmware/renesas/LICENSE.da16200"
