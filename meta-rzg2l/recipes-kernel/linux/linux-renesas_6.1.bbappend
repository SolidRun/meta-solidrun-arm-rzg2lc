# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.1-solidrun:"

# use solidrun fork
KERNEL_URL = "git://github.com/SolidRun/linux-stable.git;protocol=https"
KERNEL_BRANCH = "rz-6.1-vlp-4.0.0-sr"
LINUX_VERSION = "6.1.107-cip28-sr"
KERNEL_REV = "42fd6b32e95ad031648141cdd1e0829a9673f277"

# add solidrun configuration snippets
SRC_URI:append:rzg2l-sr-som-common = " file://rzg2lc-sr-som.cfg "
