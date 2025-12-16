require recipes-graphics/images/core-image-weston.bb
require include/rz-distro-common.inc
require include/rz-modules-common.inc

SUMMARY = "SolidRun RZ/G2LC Demo Image"

IMAGE_INSTALL:append = " \
	packagegroup-core-buildessential \
	${@bb.utils.contains('BBFILE_COLLECTIONS', 'qt6-layer', 'packagegroup-qt6-modules', '', d)} \
	${@bb.utils.contains('BBFILE_COLLECTIONS', 'qt6-layer', 'packagegroup-qt6-examples', '', d)} \
	ca-certificates \
	cmake \
	curl \
	git \
	${@bb.utils.contains_any('MACHINE_FEATURES', 'hwh264dec hwh264enc', 'gstreamer1.0-plugins-good', '', d)} \
	htop \
	kernel-modules \
	modemmanager \
	nano \
	tzdata \
	wget \
"

inherit ${@bb.utils.contains('BBFILE_COLLECTIONS', 'qt6-layer', 'populate_sdk_qt6', '', d)}

IMAGE_FEATURES += "dev-pkgs"

# install extra application launchers
ROOTFS_POSTPROCESS_COMMAND:append = "install_sr_launchers; "
DEPENDS:append = " librsvg-native"

install_sr_launchers() {
	# Terminal Emulator
	icon=${datadir}/weston/terminal.png
	app="/usr/bin/weston-terminal"
	printf "\n[launcher]\nicon=${icon}\npath=${app}\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini

	# TODO: QT Demo Launchers
}
