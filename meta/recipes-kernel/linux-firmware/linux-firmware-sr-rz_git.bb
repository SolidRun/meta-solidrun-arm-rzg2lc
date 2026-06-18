SUMMARY = "SolidRun RZ Firmware"
DESCRIPTION = "Firmware for SolidRun RZ Family Products"
SECTION = "kernel"
LICENSE = "\
           Firmware-cypress-murata \
           & Firmware-da14531 \
           & Firmware-da16200 \
"

BT_1MW_FWVER="003.001.025.0187.0366.1MW"
BT_1YN_FWVER="001.003.016.0071.0017.1YN"

SRC_URI = "git://github.com/SolidRun/build_rzg2lc.git;protocol=https;branch=develop-vlp4"
SRCREV = "b4187144d89017d7e77d4dbaa6f5d3a474edc0c0"

LIC_FILES_CHKSUM = " \
	file://overlay/common/lib/firmware/cypress/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7 \
	file://overlay/common/lib/firmware/renesas/LICENSE.da14531;md5=60f62cce4d4d6b90ab2c11a48be821eb \
	file://overlay/common/lib/firmware/renesas/LICENSE.da16200;md5=59fc8504af5dd513a2addda68571f157 \
"

S = "${WORKDIR}/git"

do_install:append() {
	# create destination directories
	install -v -m755 -d ${D}${nonarch_base_libdir}/firmware/brcm
	install -v -m755 -d ${D}${nonarch_base_libdir}/firmware/cypress
	install -v -m755 -d ${D}${nonarch_base_libdir}/firmware/renesas

	# install cypress copyright notice
	install -m 0644 overlay/common/lib/firmware/cypress/LICENCE.cypress ${D}${nonarch_base_libdir}/firmware/LICENCE.cypress_murata

	# install cypress wifi firmware to /lib/firmware/cypress
	install -m 0644 overlay/common/lib/firmware/cypress/cyfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzg2l-sr-som.bin
	install -m 0644 overlay/common/lib/firmware/cypress/cyfmac43455-sdio.1MW.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzg2l-sr-som.clm_blob
	install -m 0644 overlay/common/lib/firmware/cypress/cyfmac43455-sdio.solidrun,rzg2l-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 overlay/common/lib/firmware/cypress/cyfmac43439-sdio.bin ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.bin
	install -m 0644 overlay/common/lib/firmware/cypress/cyfmac43439-sdio.1YN.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.clm_blob
	install -m 0644 overlay/common/lib/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress

	# install cypress bluetooth firmware to /lib/firmware/brcm
	install -m 0644 overlay/common/lib/firmware/brcm/BCM4345C0_${BT_1MW_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm
	install -m 0644 overlay/common/lib/firmware/brcm/CYW4343A2_${BT_1YN_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm

	# link 1MW firmware and configs for boards with 1MW and common WiFi module design:
	# - RZ/G2L SoM
	# - RZ/V2L SoM
	# - RZ/V2N SoM
	for board in solidrun,rzg2l-hummingboard-iiot solidrun,rzg2l-hummingboard-pro solidrun,rzg2l-hummingboard-ripple solidrun,rzv2l-hummingboard-iiot solidrun,rzv2l-hummingboard-pro solidrun,rzv2l-hummingboard-ripple solidrun,rzv2n-hummingboard-iiot solidrun,rzv2n-hummingboard-pro solidrun,rzv2n-hummingboard-pulse solidrun,rzv2n-solidsense-aiot; do
		# Murata 1MW WiFi/BT
		ln -sv cyfmac43455-sdio.solidrun,rzg2l-sr-som.bin ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.$board.bin
		ln -sv cyfmac43455-sdio.solidrun,rzg2l-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.$board.clm_blob
		ln -sv cyfmac43455-sdio.solidrun,rzg2l-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.$board.txt
		ln -sv BCM4345C0_${BT_1MW_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.$board.hcd
	done

	# link brcmfmac firmware for RZ/V2N boards (brcmfmac driver looks in brcm/ directory)
	for board in solidrun,rzv2n-sr-som solidrun,rzv2n-hummingboard-iiot solidrun,rzv2n-hummingboard-pro solidrun,rzv2n-hummingboard-pulse solidrun,rzv2n-solidsense-aiot; do
		ln -sv ../cypress/cyfmac43455-sdio.solidrun,rzg2l-sr-som.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.$board.bin
		ln -sv ../cypress/cyfmac43455-sdio.solidrun,rzg2l-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.$board.clm_blob
		ln -sv ../cypress/cyfmac43455-sdio.solidrun,rzg2l-sr-som.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.$board.txt
	done

	# link 1YN firmware and configs for boards with 1YN and common WiFi module design:
	# - RZ/G2UL SoM
	# - RZ/G2LC SoM
	for board in solidrun,rzg2ul-hummingboard-ripple solidrun,rzg2lc-hummingboard-iiot solidrun,rzg2lc-hummingboard-ripple; do
		# Murata 1YN WiFi/BT
		ln -sv cyfmac43439-sdio.solidrun,rzg2lc-sr-som.bin ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.$board.bin
		ln -sv cyfmac43439-sdio.solidrun,rzg2lc-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.$board.clm_blob
		ln -sv cyfmac43439-sdio.solidrun,rzg2lc-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.$board.txt
		ln -sv CYW4343A2_${BT_1YN_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4343A2.$board.hcd
	done

	# DA14531 Bluetooth
	install -v -m 644 overlay/common/lib/firmware/renesas/hci_531.bin ${D}${nonarch_base_libdir}/firmware/renesas
	install -v -m 644 overlay/common/lib/firmware/renesas/LICENSE.da14531 ${D}${nonarch_base_libdir}/firmware/renesas

	# DA16200 WiFi
	install -v -m 644 overlay/common/lib/firmware/lmacfw_spi.bin ${D}${nonarch_base_libdir}/firmware/renesas
	ln -sv renesas/lmacfw_spi.bin ${D}${nonarch_base_libdir}/firmware/lmacfw_spi.bin
	install -v -m 644 overlay/common/lib/firmware/renesas/LICENSE.da16200 ${D}${nonarch_base_libdir}/firmware/renesas
}

PACKAGES += " ${PN}-cypress-murata-license "
LICENSE:${PN}-cypress-murata-license = "Firmware-cypress-murata"
NO_GENERIC_LICENSE[Firmware-cypress-murata] = "overlay/common/lib/firmware/cypress/LICENCE.cypress"
FILES:${PN}-cypress-murata-license = "${nonarch_base_libdir}/firmware/LICENCE.cypress_murata"

PACKAGES += " ${PN}-cyw43439 "
LICENSE:${PN}-cyw43439 = "Firmware-cypress-murata"
FILES:${PN}-cyw43439 = " \
	${nonarch_base_libdir}/firmware/brcm/CYW4343A2_${BT_1YN_FWVER}.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4343A2.solidrun,rzg2ul-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4343A2.solidrun,rzg2lc-hummingboard-iiot.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4343A2.solidrun,rzg2lc-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2ul-hummingboard-ripple.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-hummingboard-iiot.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-hummingboard-ripple.* \
"

PACKAGES += " ${PN}-cyw43455 "
LICENSE:${PN}-cyw43455 = "Firmware-cypress-murata"
FILES:${PN}-cyw43455 = " \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0_${BT_1MW_FWVER}.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzg2l-hummingboard-iiot.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzg2l-hummingboard-pro.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzg2l-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzv2l-hummingboard-iiot.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzv2l-hummingboard-pro.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzv2l-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzv2n-hummingboard-iiot.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzv2n-hummingboard-pro.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzv2n-hummingboard-pulse.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,rzv2n-solidsense-aiot.hcd \
	${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,rzv2n-sr-som.* \
	${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,rzv2n-hummingboard-iiot.* \
	${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,rzv2n-hummingboard-pro.* \
	${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,rzv2n-hummingboard-pulse.* \
	${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,rzv2n-solidsense-aiot.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzg2l-sr-som.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzg2l-hummingboard-iiot.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzg2l-hummingboard-pro.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzg2l-hummingboard-ripple.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzv2l-hummingboard-iiot.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzv2l-hummingboard-pro.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzv2l-hummingboard-ripple.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzv2n-hummingboard-iiot.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzv2n-hummingboard-pro.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzv2n-hummingboard-pulse.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,rzv2n-solidsense-aiot.* \
"

PACKAGES += " ${PN}-da14531-license"
LICENSE:${PN}-da14531-license = "Firmware-da14531"
NO_GENERIC_LICENSE[Firmware-da14531] = "overlay/common/lib/firmware/renesas/LICENSE.da14531"
FILES:${PN}-da14531-license = " \
	${nonarch_base_libdir}/firmware/renesas/LICENSE.da14531 \
"

PACKAGES += " ${PN}-da14531 "
LICENSE:${PN}-da14531 = "Firmware-da14531"
FILES:${PN}-da14531 = " \
	${nonarch_base_libdir}/firmware/renesas/hci_531.bin \
"

PACKAGES += " ${PN}-da16200-license"
LICENSE:${PN}-da16200-license = "Firmware-da16200"
NO_GENERIC_LICENSE[Firmware-da16200] = "overlay/common/lib/firmware/renesas/LICENSE.da16200"
FILES:${PN}-da16200-license = " \
	${nonarch_base_libdir}/firmware/renesas/LICENSE.da16200 \
"

PACKAGES += " ${PN}-da16200 "
LICENSE:${PN}-da16200 = "Firmware-da16200"
FILES:${PN}-da16200 = " \
	${nonarch_base_libdir}/firmware/renesas/lmacfw_spi.bin \
	${nonarch_base_libdir}/firmware/lmacfw_spi.bin \
"
