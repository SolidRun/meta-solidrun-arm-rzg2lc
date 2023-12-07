FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://vin-init.sh \
"

do_install_append () {
	install -d ${D}/home/root
	install -m 0744 ${WORKDIR}/vin-init.sh ${D}/home/root/vin-init.sh
}

FILES_${PN} += " /home/root/vin-init.sh "
