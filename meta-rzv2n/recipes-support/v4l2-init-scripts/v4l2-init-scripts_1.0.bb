SUMMARY = "V4L2 camera initialization scripts for RZ/V2N"
DESCRIPTION = "Helper scripts to configure the media pipeline for MIPI CSI-2 cameras on the RZ/V2N HummingBoard IIoT."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "rzv2n-sr-som"

SRC_URI = "file://v4l2n-init-imx678-dev.sh \
           file://v4l2-init-imx678-raw.sh \
           file://imx678-raw12-diag.sh \
           file://imx678-raw12-analyze.py \
           file://debayer_raw12_to_bmp.py \
           "

S = "${WORKDIR}"

do_install() {
    install -d ${D}/root
    install -m 0755 v4l2n-init-imx678-dev.sh ${D}/root/v4l2n-init-imx678-dev.sh
    install -m 0755 v4l2-init-imx678-raw.sh  ${D}/root/v4l2-init-imx678-raw.sh
    install -m 0755 imx678-raw12-diag.sh     ${D}/root/imx678-raw12-diag.sh
    install -m 0755 imx678-raw12-analyze.py  ${D}/root/imx678-raw12-analyze.py
    install -m 0755 debayer_raw12_to_bmp.py  ${D}/root/debayer_raw12_to_bmp.py
}

FILES:${PN} = "/root/v4l2n-init-imx678-dev.sh \
               /root/v4l2-init-imx678-raw.sh \
               /root/imx678-raw12-diag.sh \
               /root/imx678-raw12-analyze.py \
               /root/debayer_raw12_to_bmp.py \
               "

RDEPENDS:${PN} = "media-ctl v4l-utils python3-core python3-numpy python3-pillow"
