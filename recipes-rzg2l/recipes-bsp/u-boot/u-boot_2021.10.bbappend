FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0001-add-rzg2lc-solidrun-board-support.patch \
    file://0002-add-rzg2lc-solidrun-dts-support.patch \
    file://0003-Use-SD-card-for-u-boot-environment-variables.patch \
    file://0004-update-bootcmd-default-value.patch \
    file://0005-change-board-name-to-rzg2lc-solidrun.patch \
    file://0006-update-rzg2lc-solidrun-defconfig.patch \
    file://0007-add-solidrun-rzg2lc-Kconfig-to-.-arch-arm-mach-rmobi.patch \
    file://0008-update-solidrun-rzg2lc-Kconfig-fix-the-sys_board-nam.patch \
    file://0009-change-the-bootcmd-env.patch \
    file://0010-edit-rzg2lc-solidrun-configuration.patch \
    file://0011-remove-DISTROBOOT-flag-from-rzg2lc-solidrun_defconfi.patch \
    file://0012-Allow-usage-of-random-MAC-addresses.patch \
    file://0013-Add-support-for-the-tlv_eeprom-command.patch \
    file://0014-Support-reading-MAC-address-for-ravb-driver.patch \
    file://0015-add-carrier-eeprom-support-for-rzg2lc-solidrun.patch \
    file://0016-add-ditroboot-support-for-rzg2lc-solidrun.patch \
    file://0017-Fixed-reset-for-rzg2lc-solidrun-using-wdt.patch \
    file://0018-Fixed-usb-for-rzg2lc-solidrun.patch \
    file://0019-Set-SD0_DEV_SEL_SW-signal-in-rzg2lc-solidrun-dts.patch \
    file://0020-Fix-USB-VBUS-signal-types.patch \
    file://0021-add-support-to-select-eMMC-SD-during-boot-rzg2lc.patch \
"
