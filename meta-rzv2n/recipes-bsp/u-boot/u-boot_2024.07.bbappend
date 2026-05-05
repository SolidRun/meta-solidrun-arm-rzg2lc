# Override U-Boot source for SolidRun RZ/V2N SoM
UBOOT_URI:rzv2n-sr-som = "git://github.com/SolidRun/u-boot.git;protocol=https"
UBOOT_BRANCH:rzv2n-sr-som = "v2024.07-rzv2n_1.2.0"
UBOOT_REV:rzv2n-sr-som = "b6c3b5eb93b9a93597b6a11a0aa340b48e862599"

# Add ISSI SPI flash support (for IS25WP032D on HummingBoard)
FILESEXTRAPATHS:prepend:rzv2n-sr-som := "${THISDIR}/files:"
SRC_URI:append:rzv2n-sr-som = " file://issi-flash.cfg"

# Remove DRP-AI ether-setting patch (applies with fuzz to SolidRun U-Boot fork)
SRC_URI:remove:rzv2n-sr-som = "file://0001-add-ether-setting.patch"