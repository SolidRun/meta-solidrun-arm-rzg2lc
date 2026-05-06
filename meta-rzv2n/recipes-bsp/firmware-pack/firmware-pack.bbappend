# Remove boot-overlays dependency for RZ/V2N machines
# V2N doesn't have SD/MMC overlay switching yet
DEPENDS:remove:rzv2n-sr-som = "boot-overlays"