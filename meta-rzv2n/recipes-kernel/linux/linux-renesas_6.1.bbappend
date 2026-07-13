# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.1-solidrun:"

# use solidrun fork (apply to RZ/V2N machines)
KERNEL_URL:rzv2n-sr-som = "git://github.com/SolidRun/linux-stable.git;protocol=https"
KERNEL_BRANCH:rzv2n-sr-som = "rz-6.1-cip43"
LINUX_VERSION:rzv2n-sr-som = "6.1.141-cip43"
KERNEL_REV:rzv2n-sr-som = "686b0f4972a043204292a2361fb32cf0a0b916bf"

# add solidrun configuration snippets
SRC_URI:append:rzv2n-sr-som = " file://rzv2n-sr-som.cfg file://imx678.cfg "

# IMX678 RAW12 camera support (RZ/V2N CRU, no ISP). Apply order matters:
#   0001  camera support: will127534 IMX678 driver tuning (reference registers,
#         reworked link-freq/pixel-rate, crop window, set_pad_format fix) +
#         CRU standard 12-bit Bayer output (RG12/...). Rolled up from the
#         linux-stable rz-6.1-cip43 dev head; applies on the pinned KERNEL_REV.
#   0002  CSI-2 max width 4095 (enables 4K; base kernel caps at 2800).
#   0003  pack RAW Bayer bytesperline -> fixes the ~55%/line RAW12 truncation
#         (Renesas MPU-4592). THE key fix.
#   0004  add power-domains to the CSI-2 nodes -> fixes a synchronous external
#         abort in rzg2l_csi2_probe (CSI-2 block was never clocked); required
#         for /dev/media0 to appear.
SRC_URI:append:rzv2n-sr-som = " \
    file://0001-media-imx678-rzv2n-camera-support.patch \
    file://0002-media-rzg2l-cru-increase-CSI-2-max-width-to-4095.patch \
    file://0003-media-rzg2l-cru-pack-raw12-bytesperline-for-rzv2n.patch \
    file://0004-arm64-dts-r9a09g056-add-power-domains-to-csi2.patch \
"
