SUMMARY = "Quick Draw AI demo application"
DESCRIPTION = "Pre-built Quick Draw AI demo with systemd service to auto-start after Weston"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "rzv2n-sr-som"

inherit systemd

SRC_URI = " \
    file://deploy_quick_draw_v1.2.tar.gz \
    file://quickdraw.service \
"

S = "${WORKDIR}/deploy_quick_draw_v1.2"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "quickdraw.service"

INSANE_SKIP:${PN} = "already-stripped ldflags file-rdeps"

do_install() {
    # Install the application to /opt to avoid conflict with weston-init over /home/weston
    install -d ${D}/opt/deploy_quick_draw_v1.2
    cp -r ${S}/* ${D}/opt/deploy_quick_draw_v1.2/

    # Ensure executables have correct permissions
    chmod 0755 ${D}/opt/deploy_quick_draw_v1.2/run.sh
    chmod 0755 ${D}/opt/deploy_quick_draw_v1.2/app_quickdraw
    chmod 0755 ${D}/opt/deploy_quick_draw_v1.2/quickdraw_gui.py

    # Install systemd service
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/quickdraw.service ${D}${systemd_unitdir}/system/quickdraw.service
}

FILES:${PN} = " \
    /opt/deploy_quick_draw_v1.2 \
    ${systemd_unitdir}/system/quickdraw.service \
"
