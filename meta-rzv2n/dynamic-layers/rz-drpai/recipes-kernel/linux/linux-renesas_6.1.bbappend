# Override DRPAI device tree patches for SolidRun RZ/V2N kernel fork
# Our patches reference the correct board DTS files:
#   r9a09g056n48-rzv2n-evk.dts (instead of r9a09g056n44-evk.dts)
#   rzv2n-sr-som.dtsi (instead of r9a09g056n44-dev.dts)
FILESEXTRAPATHS:prepend:rzv2n-sr-som := "${THISDIR}/${PN}:"
