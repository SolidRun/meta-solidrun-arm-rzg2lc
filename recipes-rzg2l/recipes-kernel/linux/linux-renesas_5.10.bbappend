FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# avoid applying patches from meta-rz-graphics twice
SRC_URI_remove_rzg2l = "file://0002-Workaround-GPU-driver-remove-power-domains-of-GPU-no.patch"
SRC_URI_remove_rzv2l = "file://0002-Workaround-GPU-driver-remove-power-domains-v2l.patch"

SRC_URI_append = " \
file://0001-add-rzg2lc-hummingbaord-DTS-support.patch \
file://0002-add-rzg2lc-hummingbaord.dtb-to-renesas-DTBs-list.patch \
file://0003-modify-RZ-G2LC-HummingBoard-dts.patch \
file://0004-add-linux-kernel-support-for-WiFi-CYW43439-SDIO-BROA.patch \
file://0005-edit-rzg2lc-hummingboard.dts-add-wifi-support.patch \
file://0006-add-rzg2lc-compact-dts-support.patch \
file://0007-add-rzg2lc-compact.dtb-to-the-renesas-DTBs-list.patch \
file://0008-add-eeprom-and-sensors-support-to-rzg2lc-compact-dts.patch \
file://0009-enable-usb-HUB-and-add-Quectel-lte-support.patch \
file://0010-add-RTC-Eeprom-UART2-support-to-rzg2lc-hummingboard-.patch \
file://0011-enable-UART2-cts-rtc-for-rzg2lc-sr-som.patch \
file://0012-Workaround-GPU-driver-remove-power-domains-of-GPU-no.patch \
file://0013-Workaround-GPU-driver-remove-power-domains-v2l.patch \
file://0014-enable-SD-and-fix-scif1-pin-settings-for-rzg2lc-sr-s.patch \
file://0015-add-carrier-eeprom-support-for-rzg2lc-Hummingboard.patch \
file://0016-enable-micro-hdmi-support-for-rz-g2lc-hummingboard.patch \
file://0017-arm64-dts-rz-g2lc-hummingboard-fix-hdmi-if-connected.patch \
"

COMPATIBLE_MACHINE_rzg2lc-hummingboard = "(rzg2lc-hummingboard)"
