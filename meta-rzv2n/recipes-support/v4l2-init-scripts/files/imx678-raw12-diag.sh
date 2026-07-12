#!/bin/sh
#
# IMX678 RAW12 truncation diagnostic (RZ/V2N HummingBoard-IIoT / SolidSense-AIOT)
#
# Purpose:
#   Reproduce and MEASURE the "RAW12 truncated to ~55% per line" issue
#   (Renesas ticket MPU-4592) so a candidate CRU fix can be validated.
#
# Root-cause hypothesis being tested:
#   RZ/V2N CRU is RZV2H_CRU_TYPE with has_stride=true. It writes RAW12 as
#   MIPI-packed 1.5 bytes/pixel, but the driver programs bytesperline and the
#   AMnIS memory stride (= bytesperline/128) as 2 bytes/pixel. The stride
#   mismatch cuts each line short. UYVY works because its 2 B/px packing
#   matches its bytesperline.
#
# This script CAPTURES raw frames + register/pipeline state. Analyze the
# frames on a host with imx678-raw12-analyze.py.
#
# Usage: imx678-raw12-diag.sh [WxH]     (default 3840x2160)

set -e

RES="${1:-3840x2160}"
W=$(echo "$RES" | cut -dx -f1)
H=$(echo "$RES" | cut -dx -f2)

MEDIA_DEV="/dev/media0"
VIDEO_DEV="/dev/video0"
SENSOR="imx678 4-001a"
CSI2="csi-16010400.csi21"
CRU="cru-ip-16010000.video1"
MEDIA_FMT="SRGGB12_1X12"

OUT="/tmp/imx678-diag"
mkdir -p "$OUT"

log() { echo "[diag] $*"; }

configure_pipe() {
    media-ctl -d "$MEDIA_DEV" -r
    media-ctl -d "$MEDIA_DEV" -l "'${CSI2}':1 -> '${CRU}':0 [1]" 2>/dev/null || true
    for ent in "${SENSOR}:0" "${CSI2}:0" "${CSI2}:1" "${CRU}:0" "${CRU}:1"; do
        e=$(echo "$ent" | sed 's/:[01]$//'); p=$(echo "$ent" | sed 's/.*://')
        media-ctl -d "$MEDIA_DEV" -V "'${e}':${p} [fmt:${MEDIA_FMT}/${RES} field:none]"
    done
}

capture() {
    fourcc="$1"; n="$2"
    f="$OUT/frame_${fourcc}_${W}x${H}.raw"
    log "Setting V4L2 format $fourcc ${W}x${H}"
    if ! v4l2-ctl -d "$VIDEO_DEV" --set-fmt-video=width=${W},height=${H},pixelformat=${fourcc}; then
        log "  format $fourcc REJECTED by driver, skipping"; return 0
    fi
    v4l2-ctl -d "$VIDEO_DEV" --get-fmt-video | sed 's/^/  /'
    log "Capturing $n frame(s) -> $f"
    if v4l2-ctl -d "$VIDEO_DEV" --stream-mmap --stream-count="$n" --stream-to="$f" 2>"$OUT/${fourcc}.stream.log"; then
        sz=$(stat -c %s "$f" 2>/dev/null || wc -c <"$f")
        log "  captured $sz bytes ($(( sz / n )) bytes/frame)"
    else
        log "  CAPTURE FAILED (see $OUT/${fourcc}.stream.log)"; cat "$OUT/${fourcc}.stream.log" | sed 's/^/    /'
    fi
}

log "=== IMX678 RAW12 diagnostic, ${W}x${H} ==="
dmesg -c >/dev/null 2>&1 || true   # clear ring so we capture only new CRU/CSI msgs

configure_pipe
log "--- media topology ---"
media-ctl -d "$MEDIA_DEV" -p > "$OUT/media-topology.txt" 2>&1 || true

# Native CRU packed 12-bit and the standard 12-in-16 Bayer, plus 8-bit ref.
capture CR12 1     # V4L2_PIX_FMT_RAW_CRU12 (native)
capture RG12 1     # V4L2_PIX_FMT_SRGGB12   (2 B/px, added by patch)
capture RGGB 1     # V4L2_PIX_FMT_SRGGB8    (8-bit reference)

# CRU register base for RZ/V2N CRU-IP is 0x16010000 (cru-ip-16010000).
# Dump a few registers if devmem is available (best-effort, non-fatal).
if command -v devmem >/dev/null 2>&1 || command -v devmem2 >/dev/null 2>&1; then
    DM=$(command -v devmem2 || command -v devmem)
    log "--- CRU register peek (base 0x16010000) via $DM ---"
    {
        for off in 0x00 0x04 0x28 0x2c 0x30 0x70 0x74; do
            a=$(printf '0x%x' $((0x16010000 + off)))
            v=$($DM "$a" 2>/dev/null | tail -1)
            echo "  [$a] $v"
        done
    } > "$OUT/cru-regs.txt" 2>&1 || true
    cat "$OUT/cru-regs.txt"
fi

log "--- new kernel messages (CRU/CSI/imx678) ---"
dmesg | grep -iE "cru|csi|imx678|rzg2l|overrun|MB address|demosaic" | tail -40 | tee "$OUT/dmesg.txt"

cat <<EOF

[diag] DONE. Artifacts in $OUT :
  frame_CR12_${W}x${H}.raw   frame_RG12_${W}x${H}.raw   frame_RGGB_${W}x${H}.raw
  media-topology.txt  dmesg.txt  *.stream.log  cru-regs.txt (if devmem present)

Copy to a host and analyze, e.g.:
  scp root@<board>:$OUT/frame_RG12_${W}x${H}.raw .
  python3 imx678-raw12-analyze.py frame_RG12_${W}x${H}.raw ${W} ${H} --assumed-bpp 2

Expect the analyzer to report last-nonzero column ~= 0.55*width if the
packed-vs-stride hypothesis holds.
EOF
