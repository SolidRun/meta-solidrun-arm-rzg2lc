# Copyright Josua Mayer <josua@solid-run.com>
DESCRIPTION = "Driver for SolidRun Hummingboard AIOT System Controller"
LICENSE = "GPL-2.0-only"

SRC_URI = "git://github.com/SolidRun/ss-aiot-mcu.git;protocol=https;branch=linux"
SRCREV = "8c32655f171720b1ea4afbe80369db2f674cb248"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

S = "${WORKDIR}/git"

inherit module
