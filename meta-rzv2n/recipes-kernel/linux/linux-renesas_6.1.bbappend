# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.1-solidrun:"

# use solidrun fork
KERNEL_URL = "git://github.com/SolidRun/linux-stable.git;protocol=https"
KERNEL_BRANCH:rzv2n-sr-som = "sr-rzv2n-6.1-cip28"
LINUX_VERSION:rzv2n-sr-som = "6.1.107-cip28-sr"
KERNEL_REV:rzv2n-sr-som = "faeb2ebe1c2a9c5e627a5b5bb9c41b604d10bb6b"

# add solidrun configuration snippets
SRC_URI:append:rzv2n-sr-som = " file://rzv2n-sr-som.cfg "
