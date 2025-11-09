# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

BT_1YN_FWVER="001.003.016.0071.0017.1YN"

SRC_URI:append = " \
		  https://raw.githubusercontent.com/SolidRun/build_rzg2lc/refs/heads/develop-vlp4/overlay/common/lib/firmware/cypress/LICENCE.cypress;downloadfilename=LICENCE.cypress_murata;name=cylic \
		  https://raw.githubusercontent.com/SolidRun/build_rzg2lc/refs/heads/develop-vlp4/overlay/common/lib/firmware/cypress/cyfmac43439-sdio.bin;downloadfilename=cyfmac43439-sdio.solidrun,rzg2lc-sr-som.bin;name=1ynbin \
		  https://raw.githubusercontent.com/SolidRun/build_rzg2lc/refs/heads/develop-vlp4/overlay/common/lib/firmware/cypress/cyfmac43439-sdio.1YN.clm_blob;downloadfilename=cyfmac43439-sdio.solidrun,rzg2lc-sr-som.clm_blob;name=1ynblob \
		  https://raw.githubusercontent.com/SolidRun/build_rzg2lc/refs/heads/develop-vlp4/overlay/common/lib/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.txt;name=1yntxt \
		  https://raw.githubusercontent.com/SolidRun/build_rzg2lc/refs/heads/develop-vlp4/overlay/common/lib/firmware/brcm/CYW4343A2_${BT_1YN_FWVER}.hcd;name=1ynhcd \
		  file://LICENSE.da14531;name=da14531lic \
		  file://hci_531.bin;name=da14531hci \
		  file://LICENSE.da16200;name=da16200lmaclic \
		  file://lmacfw_spi.bin;name=da16200lmacspi \
"

SRC_URI[cylic.sha256sum] = "3a892759b73e8b459f1a750954b316118b0061fd9d1868d11fa258c104ee7e0c"
SRC_URI[1ynbin.sha256sum] = "75f2df72050f3f3c8b54702c4a0239ff5b9c302ea0f47ea8444bf3c8c69bfd92"
SRC_URI[1ynblob.sha256sum] = "4f8441948b47d62eb7b5df952615651c7834fce2fb2257b917bc117f0ceed9ac"
SRC_URI[1yntxt.sha256sum] = "79bfa14e6992a9c7f0e310f852ed0970cb1b8ad2e1297db079718cc036a8b704"
SRC_URI[1ynhcd.sha256sum] = "429fb4766443c96e1ab96ac7eb65c2566349a3ee28d3af118645ed935e0b61c3"
SRC_URI[da14531lic.sha256sum] = "4a03da2e0cb749f3a7dc34c3b5fe056a3bb86f1bd5a46879341c6c92d166c005"
SRC_URI[da14531hci.sha256sum] = "6e8662d1a7a24a23d251e3aef81b82644dd96a939ddfb10d392e923c9217f1f7"
SRC_URI[da16200lmaclic.sha256sum] = "4a03da2e0cb749f3a7dc34c3b5fe056a3bb86f1bd5a46879341c6c92d166c005"
SRC_URI[da16200lmacspi.sha256sum] = "6e8662d1a7a24a23d251e3aef81b82644dd96a939ddfb10d392e923c9217f1f7"

do_install:append() {
	# install cypress copyright notice
	install -m 0644 ${WORKDIR}/LICENCE.cypress_murata ${D}${nonarch_base_libdir}/firmware

	# install cypress wifi firmware to /lib/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.bin ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress

	# install cypress bluetooth firmware to /lib/firmware/brcm
	install -m 0644 ${WORKDIR}/CYW4343A2_${BT_1YN_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm

	# link 1YN firmware and configs for boards with 1YN and common WiFi module design:
	# - RZ/G2LC SoM
	for board in solidrun,rzg2lc-hummingboard-ripple; do
		# Murata 1YN WiFi/BT
		ln -sv cyfmac43439-sdio.solidrun,rzg2lc-sr-som.bin ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.$board.bin
		ln -sv cyfmac43439-sdio.solidrun,rzg2lc-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.$board.clm_blob
		ln -sv cyfmac43439-sdio.solidrun,rzg2lc-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.$board.txt
		ln -sv CYW4343A2_${BT_1YN_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4343A2.$board.hcd
	done

	# DA14531 Bluetooth
	install -v -m 644 -D ${WORKDIR}/hci_531.bin ${D}${nonarch_base_libdir}/firmware/renesas/hci_531.bin
	install -v -m 644 -D ${WORKDIR}/LICENSE.da14531 ${D}${nonarch_base_libdir}/firmware/renesas/LICENSE.da14531

	# DA16200 WiFi
	install -v -m 644 -D ${WORKDIR}/lmacfw_spi.bin ${D}${nonarch_base_libdir}/firmware/renesas/lmacfw_spi.bin
	ln -sv renesas/lmacfw_spi.bin ${D}${nonarch_base_libdir}/firmware/lmacfw_spi.bin
	install -v -m 644 -D ${WORKDIR}/LICENSE.da16200 ${D}${nonarch_base_libdir}/firmware/renesas/LICENSE.da16200
}

LICENSE:append = "    & Firmware-cypress-murata "
PACKAGES =+ " ${PN}-cypress-murata-license "
LICENSE:${PN}-cypress-murata-license = "Firmware-cypress-murata"
NO_GENERIC_LICENSE[Firmware-cypress-murata] = "../LICENCE.cypress_murata"
LIC_FILES_CHKSUM:append = " file://../LICENCE.cypress_murata;md5=cbc5f665d04f741f1e006d2096236ba7 "
FILES:${PN}-cypress-murata-license = "${nonarch_base_libdir}/firmware/LICENCE.cypress_murata"

PACKAGES =+ " ${PN}-cyw43439-sr "
LICENSE:${PN}-cyw43439-sr = "Firmware-cypress-murata"
RDEPENDS:${PN}-cyw43439-sr += "${PN}-cypress-murata-license"
FILES:${PN}-cyw43439-sr = " \
	${nonarch_base_libdir}/firmware/brcm \
	${nonarch_base_libdir}/firmware/brcm/BCM4343A2_${BT_1YN_FWVER}.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4343A2.solidrun,rzg2lc-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/cypress \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-sr-som.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43439-sdio.solidrun,rzg2lc-hummingboard-ripple.* \
"

LICENSE:append = "    & Firmware-da14531 "
PACKAGES =+ " ${PN}-da14531-license"
LICENSE:${PN}-da14531-license = "Firmware-da14531"
NO_GENERIC_LICENSE[Firmware-da14531] = "../LICENSE.da14531"
LIC_FILES_CHKSUM:append = " file://../LICENSE.da14531;md5=60f62cce4d4d6b90ab2c11a48be821eb "
FILES:${PN}-da14531-license = " \
	${nonarch_base_libdir}/firmware/renesas \
	${nonarch_base_libdir}/firmware/renesas/LICENSE.da14531 \
"

PACKAGES =+ " ${PN}-da14531 "
LICENSE:${PN}-da14531 = "Firmware-da14531"
RDEPENDS:${PN}-da14531 += "${PN}-da14531-license"
FILES:${PN}-da14531 = " \
	${nonarch_base_libdir}/firmware/renesas \
	${nonarch_base_libdir}/firmware/renesas/hci_531.bin \
"

LICENSE:append = "    & Firmware-da16200 "
PACKAGES =+ " ${PN}-da16200-license"
LICENSE:${PN}-da16200-license = "Firmware-da16200"
NO_GENERIC_LICENSE[Firmware-da16200] = "../LICENSE.da16200"
LIC_FILES_CHKSUM:append = " file://../LICENSE.da16200;md5=59fc8504af5dd513a2addda68571f157 "
FILES:${PN}-da16200-license = " \
	${nonarch_base_libdir}/firmware/renesas \
	${nonarch_base_libdir}/firmware/renesas/LICENSE.da16200 \
"

PACKAGES =+ " ${PN}-da16200 "
LICENSE:${PN}-da16200 = "Firmware-da16200"
RDEPENDS:${PN}-da16200 += "${PN}-da16200-license"
FILES:${PN}-da16200 = " \
	${nonarch_base_libdir}/firmware/renesas \
	${nonarch_base_libdir}/firmware/renesas/lmacfw_spi.bin \
	${nonarch_base_libdir}/firmware/lmacfw_spi.bin \
"
