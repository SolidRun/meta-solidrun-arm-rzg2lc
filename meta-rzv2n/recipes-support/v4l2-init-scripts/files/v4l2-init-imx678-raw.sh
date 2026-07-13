#!/bin/sh
#
# IMX678 RAW12 capture init for RZ/V2N (HummingBoard-IIoT / SolidSense-AIOT).
# RAW-only path: sensor -> CSI-2 -> CRU -> DDR, NO ISP. Mirrors the raw4k mode
# of Renesas' meta-rz-imx415 v4l2-init, adapted for IMX678 (RGGB / RG12).
#
# Requires the meta-rz-imx678 kernel patches, especially 0008 (packed RAW12
# bytesperline) which fixes the ~55%/line truncation.
#
# Usage: v4l2-init-imx678-raw.sh [WxH]   (default 3840x2160; or 1920x1080)

RES="${1:-3840x2160}"
W=$(echo "$RES" | cut -dx -f1)
H=$(echo "$RES" | cut -dx -f2)

MEDIA_DEV="/dev/media0"
VIDEO_DEV="/dev/video0"
SENSOR="imx678 4-001a"
CSI2="csi-16010400.csi21"
CRU="cru-ip-16010000.video1"
MEDIA_FMT="SRGGB12_1X12"   # IMX678 is RGGB (imx415 was SBGGR12_1X12 / BGGR)
V4L2_FMT="RG12"            # standard 12-bit Bayer FourCC; CRU emits it packed

echo "IMX678 RAW12 (no ISP): ${W}x${H}"

media-ctl -d "$MEDIA_DEV" -r
media-ctl -d "$MEDIA_DEV" -l "'${CSI2}':1 -> '${CRU}':0 [1]" 2>/dev/null
media-ctl -d "$MEDIA_DEV" -V "'${SENSOR}':0 [fmt:${MEDIA_FMT}/${RES} field:none]"
media-ctl -d "$MEDIA_DEV" -V "'${CSI2}':0 [fmt:${MEDIA_FMT}/${RES} field:none]"
media-ctl -d "$MEDIA_DEV" -V "'${CSI2}':1 [fmt:${MEDIA_FMT}/${RES} field:none]"
# The CRU-IP pads do NOT auto-propagate on the mainline driver - set them too,
# otherwise the CRU defaults to UYVY/1280x960 and the capture is garbage.
media-ctl -d "$MEDIA_DEV" -V "'${CRU}':0 [fmt:${MEDIA_FMT}/${RES} field:none]"
media-ctl -d "$MEDIA_DEV" -V "'${CRU}':1 [fmt:${MEDIA_FMT}/${RES} field:none]"

v4l2-ctl -d "$VIDEO_DEV" --set-fmt-video=width=${W},height=${H},pixelformat=${V4L2_FMT}
v4l2-ctl -d "$VIDEO_DEV" --get-fmt-video | sed 's/^/  /'

# Expected (patch 0008): Bytes per Line = ALIGN(W*3/2,128); Size = bpl*H (512-al)
exp_bpl=$(( (W * 3 / 2 + 127) / 128 * 128 ))
echo "  expected packed bytesperline = ${exp_bpl}  (payload W*3/2 = $(( W * 3 / 2 )))"

cat <<EOF

Capture one frame:
  v4l2-ctl -d ${VIDEO_DEV} --stream-mmap --stream-count=1 --stream-to=/tmp/imx678_${W}x${H}.raw

Convert to BMP on the board (or copy to a host):
  ./debayer_raw12_to_bmp.py /tmp/imx678_${W}x${H}.raw --width ${W} --height ${H} --bayer rggb --outfile /tmp/imx678.bmp

Live view + more tests (packed RG12 needs a software unpack - bayer2rgb can't
eat it directly). Use the full-test helper:
  /root/imx678-full-test.sh stream-sw ${RES}   # software unpack -> Weston/DSI
  /root/imx678-full-test.sh still     ${RES}   # one frame -> BMP -> Weston/DSI

KNOWN LIMITATION: each line is currently truncated to ~58% (CSI-2/DPHY config
gap on the mainline RZ/V2N driver - deferred). The captured frame is real but
only the left ~58% is filled.
EOF
