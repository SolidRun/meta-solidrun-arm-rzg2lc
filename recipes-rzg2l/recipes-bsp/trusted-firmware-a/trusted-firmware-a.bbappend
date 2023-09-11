FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0001-add-solidrun-rzg2lc-support.patch \
    file://0002-add-sr-rzg2l-1g-board-support.patch \
    file://0003-add-sr-rzv2l-2GB-board-support.patch \
"

COMPATIBLE_MACHINE_rzg2lc-hummingboard = "(rzg2lc-hummingboard)"
PLATFORM_rzg2lc-hummingboard = "g2l"
EXTRA_FLAGS_rzg2lc-hummingboard = "BOARD=sr_rzg2lc_1g"
FLASH_ADDRESS_BL2_BP_rzg2lc-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzg2lc-hummingboard = "1D200"

COMPATIBLE_MACHINE_rzg2l-hummingboard = "(rzg2l-hummingboard)"
PLATFORM_rzg2l-hummingboard = "g2l"
EXTRA_FLAGS_rzg2l-hummingboard = "BOARD=sr_rzg2l_1g"
FLASH_ADDRESS_BL2_BP_rzg2l-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzg2l-hummingboard = "1D200"


COMPATIBLE_MACHINE_rzv2l-hummingboard = "(rzv2l-hummingboard)"
PLATFORM_rzv2l-hummingboard = "v2l"
EXTRA_FLAGS_rzv2l-hummingboard = "BOARD=sr_rzv2l_2g"
FLASH_ADDRESS_BL2_BP_rzv2l-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzv2l-hummingboard = "1D200"

# need specify MBEDTLS_DIR sources at build-time
export MBEDTLS_DIR="${WORKDIR}/mbedtls"
