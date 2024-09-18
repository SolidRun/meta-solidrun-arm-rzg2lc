FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# avoid applying patches from meta-rz-graphics twice
SRC_URI_remove_rzg2l = "file://0002-Workaround-GPU-driver-remove-power-domains-of-GPU-no.patch"
SRC_URI_remove_rzv2l = "file://0002-Workaround-GPU-driver-remove-power-domains-v2l.patch"

KERNEL_URL = " \
    git://github.com/SolidRun/linux-stable.git"
BRANCH = "rz-5.10-cip36-sr"
SRCREV = "8772d496cb1c6cc15d762fb942fc510dbc4db3d4"

# Applying custom kernel defconfig 
SRC_URI:append = " file://kernel_extra.cfg"

SRC_URI:append = " ${@bb.utils.contains("DISTRO_FEATURES", "apparmor", " file://apparmor.cfg", "" ,d)}"

COMPATIBLE_MACHINE:solidrun-rz = "(solidrun-rz)"

# add EU205 patches
SRC_URI:append = " \
	file://0001-arm64-renesas-solidrun-put-dts-v1-at-start-of-dts-on.patch \
	file://0002-arm64-renesas-solidrun-move-scif2-pinmux-to-som-spec.patch \
	file://0003-arm64-renesas-solidrun-move-i2c3-to-som-specific-dts.patch \
	file://0004-arm64-renesas-solidrun-remove-can-pinmux-from-common.patch \
	file://0005-arm64-renesas-solidrun-g2l-add-description-for-pmic-.patch \
	file://0006-gnss-ubx-add-support-for-the-reset-gpio.patch \
	file://0007-pps-clients-gpio-Propagate-return-value-from-pps_gpi.patch \
	file://0008-Support-for-Renesas-Bluetooth-Low-Energy-HCI-over-UA.patch \
	file://0009-Adding-DA16600-reset-by-GPIO.patch \
	file://0010-Bluetooth-hci_renesas-Fix-compiler-warning.patch \
	file://0011-Bluetooth-hci_renesas-Fix-issue-with-reset-pin-direc.patch \
	file://0012-Bluetooth-hci_renesas-Complete-the-setup-regardless-.patch \
	file://0013-backlight-gpio_backlight-add-support-for-power-suppl.patch \
	file://0014-drm-panel-ronbo-rb070d30-support-software-reset-and-.patch \
	file://0016-gpio-add-gpio-driver-for-slg46826-mult-function-prog.patch \
	file://0017-panel-driver.patch \
	file://0018-arm64-dts-add-description-for-renesas-eu205-eval-boa.patch \
"
# file://0015-drm-panel-ronbo-rb070d30-support-device-tree-orienta.patch
