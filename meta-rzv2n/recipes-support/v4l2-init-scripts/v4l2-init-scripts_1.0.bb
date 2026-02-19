SUMMARY = "V4L2 camera initialization scripts for RZ/V2N"
DESCRIPTION = "Helper scripts to configure the media pipeline for MIPI CSI-2 cameras on the RZ/V2N HummingBoard IIoT."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "rzv2n-sr-som"

SRC_URI = "file://v4l2n-init-imx678-dev.sh"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/home/root
    install -m 0755 v4l2n-init-imx678-dev.sh ${D}/home/root/v4l2n-init-imx678-dev.sh
}

FILES:${PN} = "/home/root/v4l2n-init-imx678-dev.sh"

RDEPENDS:${PN} = "media-ctl v4l-utils"
