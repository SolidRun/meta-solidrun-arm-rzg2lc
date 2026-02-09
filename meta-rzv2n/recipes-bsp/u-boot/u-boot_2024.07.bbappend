# Override U-Boot source for SolidRun RZ/V2N SoM
UBOOT_URI:rzv2n-sr-som = "git://github.com/SolidRun/u-boot.git;protocol=https"
UBOOT_BRANCH:rzv2n-sr-som = "v2024.07-rzv2n_1.2.0"
UBOOT_REV:rzv2n-sr-som = "0363f4432f7cabfbdd9007ae77926d48145391ac"

# Add ISSI SPI flash support (for IS25WP032D on HummingBoard)
FILESEXTRAPATHS:prepend:rzv2n-sr-som := "${THISDIR}/files:"
SRC_URI:append:rzv2n-sr-som = " file://issi-flash.cfg"