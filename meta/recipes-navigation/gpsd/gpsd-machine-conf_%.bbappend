# add this repo to search path
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://70-ssaiot-sc-gnss.rules \
	file://10-follow-gpsd.conf \
"

S = "${WORKDIR}"

do_install() {
	install -Dm0644 ${WORKDIR}/70-ssaiot-sc-gnss.rules ${D}${nonarch_base_libdir}/udev/rules.d/70-ssaiot-sc-gnss.rules
	install -Dm0644 ${WORKDIR}/10-follow-gpsd.conf ${D}${systemd_system_unitdir}/gpsdctl@.service.d/10-follow-gpsd.conf
}

FILES:${PN} += "${nonarch_base_libdir}/udev ${systemd_system_unitdir}"
