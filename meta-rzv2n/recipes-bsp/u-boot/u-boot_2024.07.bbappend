SRC_URI:rzv2n-sr-som = "git://github.com/SolidRun/u-boot.git;protocol=https;branch=v2024.07-rzv2n_1.2.0"
SRCREV:rzv2n-sr-som = "f76018589390a42b050b10704573235fbd588529"

# Add ISSI SPI flash support (for IS25WP032D on HummingBoard)
FILESEXTRAPATHS:prepend:rzv2n-sr-som := "${THISDIR}/files:"
SRC_URI:append:rzv2n-sr-som = " file://issi-flash.cfg"