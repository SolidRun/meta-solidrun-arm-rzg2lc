# Override DRP device tree patches for SolidRun RZ/V2N kernel fork
# Our patches reference the correct board DTS files:
#   r9a09g056n48-rzv2n-evk.dts (instead of r9a09g056n44-evk.dts)
#   rzv2n-sr-som.dtsi (instead of r9a09g056n44-dev.dts)
FILESEXTRAPATHS:prepend:rzv2n-sr-som := "${THISDIR}/${PN}:"

# Remove the original Renesas DRP DT patch (targets n44 boards that don't
# exist in the SolidRun kernel fork) and add our adapted version.
SRC_URI:remove:rzv2n-sr-som = "file://0001-add-drp-property-to-devicetree.patch"
SRC_URI:append:rzv2n-sr-som = " file://0001-add-drp-property-to-devicetree-solidrun.patch"
