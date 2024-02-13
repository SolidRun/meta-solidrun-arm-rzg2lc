require conf/machine/include/cip-core.inc

DEFAULTTUNE ?= "cortexa55"

TUNE_CONF ?= "conf/machine/include/tune-cortexa55.inc"
require ${TUNE_CONF}

PREFERRED_PROVIDER_virtual/kernel = "linux-renesas"

# flash writer
EXTRA_IMAGEDEPENDS += "flash-writer"

# build sdcard image by default
IMAGE_FSTYPES += "wic wic.zst wic.bmap"
WKS_DEFAULT_FILE ?= "rzg2lc-sdcard.wks"
WKS_FILES ?= "rzg2lc-sdcard.wks"

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += " kernel-module-brcmfmac kernel-module-brcmutil \
                                        linux-firmware-bcm43439 linux-firmware-bcm43455"
MACHINE_FEATURES += "bluetooth wifi"

MACHINEOVERRIDES .= ":solidrun-rz"
