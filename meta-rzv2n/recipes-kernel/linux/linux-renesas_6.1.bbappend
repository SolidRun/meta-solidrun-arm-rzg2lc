# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.1-solidrun:"

# use solidrun fork
KERNEL_URL = "git://github.com/SolidRun/linux-stable.git;protocol=https"
KERNEL_BRANCH:rzv2n-sr-som = "rz-6.1-cip43"
LINUX_VERSION:rzv2n-sr-som = "6.1.141-cip43"
KERNEL_REV:rzv2n-sr-som = "6a46f373942626997bf727f24bc37ef7c7156d48"

# add solidrun configuration snippets
SRC_URI:append:rzv2n-sr-som = " file://rzv2n-sr-som.cfg "

# IMX678 camera fixes: CSI-2 max width for 4K + pixel rate/link freq
SRC_URI:append:rzv2n-sr-som = " \
    file://0001-media-rzg2l-cru-increase-CSI-2-max-width-to-4095-for.patch \
    file://0002-media-imx678-fix-pixel-rate-and-link-freq-for-SDR-mo.patch \
"

# pca953x: backport level-triggered IRQ support from 6.6 for touchscreen
SRC_URI:append:rzv2n-sr-som = " \
    file://0003-gpio-pca953x-add-level-triggered-irq-support.patch \
"

# DT: fix tca6416_u21 IRQ, remove lvds-irq-hog, use LEVEL_LOW for touchscreen
SRC_URI:append:rzv2n-sr-som = " \
    file://0004-arm64-dts-rzv2n-fix-tca6416_u21-IRQ-and-touchscreen-.patch \
"
