# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.1-solidrun:"

# use solidrun fork (apply to RZ/V2N machines)
KERNEL_URL:rzv2n-sr-som = "git://github.com/SolidRun/linux-stable.git;protocol=https"
KERNEL_BRANCH:rzv2n-sr-som = "rz-6.1-cip43"
LINUX_VERSION:rzv2n-sr-som = "6.1.141-cip43"
KERNEL_REV:rzv2n-sr-som = "a18b38a6183bc5c9f4b412fffceb1a552a97c118"

# add solidrun configuration snippets
SRC_URI:append:rzv2n-sr-som = " file://rzv2n-sr-som.cfg "

# IMX678 camera fixes: CSI-2 max width for 4K + pixel rate/link freq
SRC_URI:append:rzv2n-sr-som = " \
    file://0001-media-rzg2l-cru-increase-CSI-2-max-width-to-4095-for.patch \
    file://0002-media-imx678-fix-pixel-rate-and-link-freq-for-SDR-mo.patch \
"
