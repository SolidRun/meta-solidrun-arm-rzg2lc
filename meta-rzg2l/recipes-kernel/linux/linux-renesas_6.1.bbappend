# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.1-solidrun:"

# use solidrun fork
KERNEL_URL = "git://github.com/SolidRun/linux-stable.git;protocol=https"
KERNEL_BRANCH = "rz-6.1-vlp-4.0.0-sr"
LINUX_VERSION = "6.1.107-cip28-sr"
KERNEL_REV = "81187a547b6d325bfb51505b753cb21ce4ed907e"

# add solidrun configuration snippets
SRC_URI:append:rzg2lc-sr-som = " file://rzg2lc-sr-som.cfg "
