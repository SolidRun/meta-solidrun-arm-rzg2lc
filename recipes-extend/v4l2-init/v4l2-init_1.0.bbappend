FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://v4l2-init-imx219.sh"

do_install_append () {
	install -d ${D}/home/root
	install -m 0744 ${WORKDIR}/v4l2-init-imx219.sh ${D}/home/root/v4l2-init-imx219.sh
}

FILES_${PN} += " /home/root/v4l2-init-imx219.sh "
