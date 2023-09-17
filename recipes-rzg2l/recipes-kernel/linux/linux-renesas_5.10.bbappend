FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# avoid applying patches from meta-rz-graphics twice
SRC_URI_remove_rzg2l = "file://0002-Workaround-GPU-driver-remove-power-domains-of-GPU-no.patch"
SRC_URI_remove_rzv2l = "file://0002-Workaround-GPU-driver-remove-power-domains-v2l.patch"

SRC_URI += "\
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
    file://0018-edit-rzg2lc-hummingboard-dts-remove-unused-dts-nodes.patch \
    file://0019-edit-rz-g2lc-dts-set-scif2-pins-and-fix-sd0_vdd.patch \
    file://0020-edit-rz-g2lc-dts-fix-sd-emmc-vdd-select.patch \
    file://0021-Add-bluetooth-support-for-rzg2lc-som.patch \
    file://0022-Fix-ethernet-reconnect-isuue-on-rzg2lc-hummingboard.patch \
    file://0023-RZ-G2LC-som-sd-card-is-non-removable.patch \
    file://0024-rz-g2lc-fix-pmic-setup-increase-wifi-bluetooth-stabi.patch \
    file://0025-rz-g2lc-fix-vbus-signal-types.patch \
    file://0026-rzg2lc-edit-emmc-sd-settings.patch \
    file://0027-add-mxl8611x-phy-driver-support.patch \
    file://0028-eidt-mxl-8611x-net-phy-modify-rx-tx-default-delays.patch \
    file://0029-add-rzg2l-hummingboard-ripple-dtb-board-support.patch \
    file://0030-add-rzg2l-hummingboard-ripple.dtb-to-renesas-dtb-list.patch \
    file://0031-rzg2l-humminboard-ripple-update-dts.patch \
    file://0032-add-rzg2l-hummingbaord-tutus-dts-support.patch \
    file://0033-add-rzg2l-hummingbaord-tutus.dtb-to-renesas-dtbs-lis.patch \
    file://0034-fix-rzg2l-eeprom-settings.patch \
    file://0035-rzg2l-HB-Tutus-fix-LEDs-settings-and-enable-eMMC.patch \
    file://0036-rzg2l-HB_ripple-enable-eMMC-by-default.patch \
    file://0037-Fix-usb-regulators-for-RZG2L-SOM.patch \
    file://0038-rzg2l-hummingboard-ripple-disable-eth1.patch \
    file://0039-add-rzg2l-hummingboard-extended-dts-support.patch \
    file://0040-add-rzg2l-hummingboard-extended-dts-support.patch \
    file://0041-Unifying-RZG2L-RZG2LC-device-trees.patch \
    file://0042-rzg2l-add-SW1-Button-support-to-rzg2l-hummingboard-t.patch \
    file://0043-rzv2l-add-HB-extended-and-HB-ripple-dts-support.patch \
    file://0044-rzv2l-add-HB-extended-and-HB-ripple-to-renesas-dtbs.patch \
    file://0045-sr-som-Fix-mipi-hdmi-bridge.patch \
    file://0046-Fix-model-naming-typo-in-the-dts.patch \
    file://1001-HB_EXT-add-imx219-camera.patch \
    file://imx219.c \
"

# Applying custom kernel defconfig 
SRC_URI += "file://kernel_extra.cfg"

COMPATIBLE_MACHINE_rzg2lc-hummingboard = "(rzg2lc-hummingboard)"
COMPATIBLE_MACHINE_rzg2l-hummingboard = "(rzg2l-hummingboard)"
COMPATIBLE_MACHINE_rzv2l-hummingboard = "(rzv2l-hummingboard)"


