DESCRIPTION = "SD/eMMC overlays packing"
LICENSE = "MIT"
DEPENDS = "u-boot-tools-native dtc-native virtual/kernel"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://overlays-fit.its"

do_configure[depends] += "virtual/kernel:do_deploy"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit deploy

do_configure() {
    cp ${DEPLOY_DIR_IMAGE}/${SR_SD_OVERLAY} ${WORKDIR}/sd-overlay.dtbo
    cp ${DEPLOY_DIR_IMAGE}/${SR_MMC_OVERLAY} ${WORKDIR}/mmc-overlay.dtbo
}

do_compile(){
    mkimage -f ${WORKDIR}/overlays-fit.its ${WORKDIR}/overlays.itb
}

do_deploy() {
    cp ${WORKDIR}/overlays.itb ${DEPLOYDIR}/overlays-${MACHINE}.itb
}


addtask deploy after do_compile
