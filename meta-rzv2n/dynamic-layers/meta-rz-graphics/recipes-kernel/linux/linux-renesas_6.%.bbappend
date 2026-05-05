# Enable Mali GPU in device tree when proprietary graphics layer is present
FILESEXTRAPATHS:prepend:rzv2n-sr-som := "${THISDIR}/${PN}:"
SRC_URI:append:rzv2n-sr-som = " file://0001-arm64-dts-renesas-rzv2n-sr-som-enable-Mali-GPU.patch"
