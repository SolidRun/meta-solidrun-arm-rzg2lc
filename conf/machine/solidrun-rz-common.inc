require conf/machine/include/cip-core.inc

DEFAULTTUNE ?= "cortexa55"

TUNE_CONF ?= "conf/machine/include/tune-cortexa55.inc"
require ${TUNE_CONF}

PREFERRED_PROVIDER_virtual/kernel = "linux-renesas"
KERNEL_DTC_FLAGS:append = " -@"

# flash writer
EXTRA_IMAGEDEPENDS += "flash-writer boot-overlays"

# build sdcard image by default
IMAGE_FSTYPES += "wic wic.zst wic.bmap"
WKS_DEFAULT_FILE ?= "rzg2lc-sdcard.wks.in"
WKS_FILES ?= "rzg2lc-sdcard.wks.in"
WIC_INPUT_DEPENDS = "firmware-pack:do_deploy flash-writer:do_deploy boot-overlays:do_deploy"

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += " kernel-module-brcmfmac kernel-module-brcmutil \
                                        linux-firmware-bcm43439 linux-firmware-bcm43455 \
                                        kernel-module-hci-uart \
                                        kernel-module-leds-lp55xx-common kernel-module-leds-lp5562 \
                                        kernel-module-tpm-tis-core kernel-module-tpm-tis-spi \
                                        kernel-module-ar0521 kernel-module-imx219 \
                                        u-boot \
"

MACHINE_FEATURES += "bluetooth wifi"

MACHINEOVERRIDES .= ":solidrun-rz"
