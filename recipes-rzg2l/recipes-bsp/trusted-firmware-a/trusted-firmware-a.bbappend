FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0001-add-solidrun-rzg2lc-support.patch \
    file://0002-add-sr-rzg2l-1g-board-support.patch \
    file://0003-add-sr-rzv2l-2GB-board-support.patch \
    file://0004-renesas-solidrun-Use-updated-memory-timing-configura.patch \
    file://0005-renesas-solidrun-add-sr-rzg2l-2g-board-support.patch \
    file://0006-renesas-solidrun-add-sr-rzg2ul-1g-board-support.patch \
    file://0007-renesas-solidrun-add-sr-rzg2ul-512MB-board-support.patch \
    file://0008-HACK-drivers-renesas-micro-delay-count-from-10-milli.patch \
    file://0009-import-rz-g3s-i2c-driver-from-v2.7-rzg3s.patch \
    file://0010-drivers-renesas-adapt-g3s-i2c-driver-for-rz-g2l-rz-v.patch \
    file://0011-drivers-renesas-i2c-change-api-to-support-multi-byte.patch \
    file://0012-drivers-renesas-i2c-add-tlv-library.patch \
    file://0013-plat-renesas-rz-ddr-call-new-function-ddr_param_setu.patch \
    file://0014-add-generic-sr_rzg2l-board-for-all-memory-sizes.patch \
    file://0015-plat-renesas-rz-return-optional-dtb-blob-with-dram-i.patch \
    file://0016-plat-renesas-rz-call-optional-board-specific-functio.patch \
    file://0017-board-sr_rzg2l-add-support-for-passing-dram-info-to-.patch \
    file://0018-plat-renesas-rz-ddr-fix-build-error-when-DDR_PARAM_S.patch \
    file://0019-board-sr_rzg2l-optimise-ddr-parameter-selection-for-.patch \
    file://0020-drivers-renesas-i2c-implement-i2c-bus-flushing-to-re.patch \
    file://0021-board-sr_rzg2l-unconditionally-flush-i2c-bus-before-.patch \
    file://0022-board-sr_rzg2l-enable-passing-dram-info-from-BL3-to-.patch \
"

COMPATIBLE_MACHINE_rzg2lc-hummingboard = "(rzg2lc-hummingboard)"
PLATFORM_rzg2lc-hummingboard = "g2l"
EXTRA_FLAGS_rzg2lc-hummingboard = "BOARD=sr_rzg2lc_1g"
FLASH_ADDRESS_BL2_BP_rzg2lc-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzg2lc-hummingboard = "1D200"

COMPATIBLE_MACHINE_rzg2l-hummingboard = "(rzg2l-hummingboard)"
PLATFORM_rzg2l-hummingboard = "g2l"
EXTRA_FLAGS_rzg2l-hummingboard = "BOARD=sr_rzg2l"
FLASH_ADDRESS_BL2_BP_rzg2l-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzg2l-hummingboard = "1D200"


COMPATIBLE_MACHINE_rzv2l-hummingboard = "(rzv2l-hummingboard)"
PLATFORM_rzv2l-hummingboard = "v2l"
EXTRA_FLAGS_rzv2l-hummingboard = "BOARD=sr_rzv2l_2g"
FLASH_ADDRESS_BL2_BP_rzv2l-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzv2l-hummingboard = "1D200"

# need specify MBEDTLS_DIR sources at build-time
export MBEDTLS_DIR="${WORKDIR}/mbedtls"
