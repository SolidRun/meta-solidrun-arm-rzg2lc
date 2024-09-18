FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI:remove = " git://github.com/renesas-rz/rzg_trusted-firmware-a.git;branch=${BRANCH};protocol=https"
SRC_URI:append = " git://github.com/SolidRun/arm-trusted-firmware.git;branch=v2.9/rz-sr;protocol=https"
SRCREV = "6d212fffd11a22aebe18a8fa924541b2513d6f68"

COMPATIBLE_MACHINE_rzg2lc-hummingboard = "(rzg2lc-hummingboard)"
PLATFORM_rzg2lc-hummingboard = "g2l"
EXTRA_FLAGS_rzg2lc-hummingboard = "BOARD=sr_rzg2lc"
FLASH_ADDRESS_BL2_BP_rzg2lc-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzg2lc-hummingboard = "1D200"

COMPATIBLE_MACHINE_rzg2l-hummingboard = "(rzg2l-hummingboard)"
PLATFORM_rzg2l-hummingboard = "g2l"
EXTRA_FLAGS_rzg2l-hummingboard = "BOARD=sr_rzg2l"
FLASH_ADDRESS_BL2_BP_rzg2l-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzg2l-hummingboard = "1D200"


COMPATIBLE_MACHINE_rzv2l-hummingboard = "(rzv2l-hummingboard)"
PLATFORM_rzv2l-hummingboard = "v2l"
EXTRA_FLAGS_rzv2l-hummingboard = "BOARD=sr_rzv2l"
FLASH_ADDRESS_BL2_BP_rzv2l-hummingboard = "00000"
FLASH_ADDRESS_FIP_rzv2l-hummingboard = "1D200"

# need specify MBEDTLS_DIR sources at build-time
export MBEDTLS_DIR="${WORKDIR}/mbedtls"
