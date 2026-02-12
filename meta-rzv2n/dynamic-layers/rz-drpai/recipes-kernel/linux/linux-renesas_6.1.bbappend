# Override DRPAI device tree patch for SolidRun RZ/V2N kernel fork
# The original patch references r9a09g056n44-dev.dts and r9a09g056n44-evk.dts
# which don't exist in SolidRun's kernel. Replace with corrected version.
FILESEXTRAPATHS:prepend:rzv2n-sr-som := "${THISDIR}/${PN}:"
SRC_URI:remove:rzv2n-sr-som = "file://0001-add-drpai-property-to-devicetree.patch"
SRC_URI:append:rzv2n-sr-som = " file://0001-add-drpai-property-to-devicetree-solidrun.patch"
