# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.1-solidrun:"

# use solidrun fork
KERNEL_URL = "git://github.com/SolidRun/linux-stable.git;protocol=https"
KERNEL_BRANCH:rzv2n-sr-som = "rz-6.1-cip43"
LINUX_VERSION:rzv2n-sr-som = "6.1.141-cip43"
KERNEL_REV:rzv2n-sr-som = "ac6e7becdfdc3d553aa2617d53f364afd41ec4b9"

# add solidrun configuration snippets
SRC_URI:append:rzv2n-sr-som = " file://rzv2n-sr-som.cfg "
