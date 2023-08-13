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
"

# Applying custom kernel defconfig 
SRC_URI += "file://kernel.extra"

do_patch_append() {
    cat ${WORKDIR}/kernel.extra >> ${S}/arch/arm64/configs/defconfig
}

COMPATIBLE_MACHINE_rzg2lc-hummingboard = "(rzg2lc-hummingboard)"
