FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI:remove = " git://github.com/renesas-rz/rzg_trusted-firmware-a.git;branch=${BRANCH};protocol=https"
SRC_URI:append = " git://github.com/SolidRun/arm-trusted-firmware.git;branch=v2.9/rz-sr;protocol=https"
SRCREV = "ee439acb1fe784706165697b1d1ba5fdc8af0bff"

COMPATIBLE_MACHINE:solidrun-rzg2lc-som = "(${MACHINE})"
PLATFORM:solidrun-rzg2lc-som = "g2l"
EXTRA_FLAGS:solidrun-rzg2lc-som = "BOARD=sr_rzg2lc"
FLASH_ADDRESS_BL2_BP:solidrun-rzg2lc-som = "00000"
FLASH_ADDRESS_FIP:solidrun-rzg2lc-som = "1D200"

COMPATIBLE_MACHINE:solidrun-rzg2l-som = "(${MACHINE})"
PLATFORM:solidrun-rzg2l-som = "g2l"
EXTRA_FLAGS:solidrun-rzg2l-som = "BOARD=sr_rzg2l"
FLASH_ADDRESS_BL2_BP:solidrun-rzg2l-som = "00000"
FLASH_ADDRESS_FIP:solidrun-rzg2l-som = "1D200"

COMPATIBLE_MACHINE:solidrun-rzv2l-som = "(${MACHINE})"
PLATFORM:solidrun-rzv2l-som = "v2l"
EXTRA_FLAGS:solidrun-rzv2l-som = "BOARD=sr_rzv2l"
FLASH_ADDRESS_BL2_BP:solidrun-rzv2l-som = "00000"
FLASH_ADDRESS_FIP:solidrun-rzv2l-som = "1D200"

EXTRA_FLAGS:append = " FIP_ALIGN=16"

# need specify MBEDTLS_DIR sources at build-time
export MBEDTLS_DIR="${WORKDIR}/mbedtls"
