DESCRIPTION = "OP-TEE OS"

LICENSE = "BSD-2-Clause & BSD-3-Clause"
LIC_FILES_CHKSUM = " \
	file://LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173 \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"

require include/rzg2l-security-config.inc
inherit deploy python3native

PV = "3.14.0+git${SRCPV}"
BRANCH = "3.14.0/rzg2l"
#TAG: 3.14.0
SRCREV = "800c771a1c9e4de38d48ab5a3e854ad1aaff6433"

SRC_URI = " \
	git://github.com/renesas-rz/rzg_optee-os.git;branch=${BRANCH} \
"

COMPATIBLE_MACHINE = "(smarc-rzg2l|smarc-rzg2lc)"

PLATFORM = "rz"
PLATFORM_FLAVOR_smarc-rzg2l = "g2l_smarc_2"
PLATFORM_FLAVOR_smarc-rzg2lc = "g2l_smarc_1"

DEPENDS = " \
	python3-pyelftools-native python3-pycryptodome-native python3-pycryptodomex-native secprv-native \
"

# Let the Makefile handle setting up the flags as it is a standalone application
LD[unexport] = "1"
LDFLAGS[unexport] = "1"
export CCcore="${CC}"
export LDcore="${LD}"
libdir[unexport] = "1"

S = "${WORKDIR}/git"

CFLAGS_prepend = "--sysroot=${STAGING_DIR_HOST}"

EXTRA_OEMAKE = " \
	PLATFORM=${PLATFORM} PLATFORM_FLAVOR=${PLATFORM_FLAVOR} \
	CFG_ARM64_core=y CFG_REE_FS=y CFG_RPMB_FS=n CFG_CRYPTO_WITH_CE=n \
	CFG_RZ_SCE=y CFG_RZ_SCE_LIB_DIR=${SYMLINK_NATIVE_SEC_LIB_DIR} \
	CROSS_COMPILE64=${TARGET_PREFIX} \
"

do_compile() {
	oe_runmake

	if [ "${TRUSTED_BOARD_BOOT}" = "1" ]; then
		python3 ${MANIFEST_GENERATION_KCERT} -info ${DIRPATH_MANIFEST_GENTOOL}/info/bl32_${IMG_AUTH_MODE}_info.xml \
			-iskey ${SYMLINK_NATIVE_BOOT_KEY_DIR}/bl32_key.pem -certout ${S}/out/arm-plat-${PLATFORM}/core/bl32-kcert.bin
		
		python3 ${MANIFEST_GENERATION_CCERT} -info ${DIRPATH_MANIFEST_GENTOOL}/info/bl32_${IMG_AUTH_MODE}_info.xml \
			-iskey ${SYMLINK_NATIVE_BOOT_KEY_DIR}/bl32_key.pem -imgin ${S}/out/arm-plat-${PLATFORM}/core/tee-raw.bin \
			-certout ${S}/out/arm-plat-${PLATFORM}/core/bl32-ccert.bin -imgout ${S}/out/arm-plat-${PLATFORM}/core/tee_tbb.bin
	fi
}

do_install() {
	#install TA devkit
	install -d ${D}/usr/include/optee/export-user_ta/

	for f in  ${B}/out/arm-plat-${PLATFORM}/export-ta_arm64/* ; do
		cp -aR	$f	${D}/usr/include/optee/export-user_ta/
	done

	# install firmware images
	install -d ${D}/boot

	# Copy TEE OS to install folder
	install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/tee.elf     ${D}/boot/tee-${MACHINE}.elf
	install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/tee-raw.bin ${D}/boot/tee-${MACHINE}.bin
	
	if [ "${TRUSTED_BOARD_BOOT}" = "1" ]; then
		install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/bl32-kcert.bin ${D}/boot/bl32-kcert-${MACHINE}.bin
		install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/bl32-ccert.bin ${D}/boot/bl32-ccert-${MACHINE}.bin
		install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/tee_tbb.bin    ${D}/boot/tee-${MACHINE}_tbb.bin
	fi
}

FILES_${PN} = "/boot "
SYSROOT_DIRS += "/boot"

FILES_${PN}-dev = "/usr/include/optee"

INSANE_SKIP_${PN}-dev = "staticdev"
