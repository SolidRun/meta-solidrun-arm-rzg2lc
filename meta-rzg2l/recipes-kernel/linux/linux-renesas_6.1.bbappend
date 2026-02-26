# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.1-solidrun:"

# use solidrun fork (apply to all RZ/G2L family machines)
KERNEL_URL:rzg2l-sr-som-common = "git://github.com/SolidRun/linux-stable.git;protocol=https"
KERNEL_BRANCH:rzg2l-sr-som-common = "rz-6.1-vlp-4.0.1-sr"
LINUX_VERSION:rzg2l-sr-som-common = "6.1.141-cip43-sr"
KERNEL_REV:rzg2l-sr-som-common = "28167d98f121e6daf20ee5d182e8cfbd2b90ec71"

# add solidrun configuration snippets
SRC_URI:append:rzg2l-sr-som-common = " file://rzg2lc-sr-som.cfg "
