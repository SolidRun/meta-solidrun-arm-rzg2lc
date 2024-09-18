UBOOT_URL = "git://github.com/SolidRun/u-boot.git"
BRANCH = "v2021.10/rz-sr"

SRCREV = "cb93dca45a88885af31f0cd23903b0a06f63da41"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-2021.10:"

# add EU205 patches
SRC_URI:append:eu205 = " \
	file://0001-rzg2l-solidrun-eu205-default-fdtfile.patch \
"
