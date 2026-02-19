#!/bin/sh
#
# IMX678 Camera Initialization Script for RZ/V2N HummingBoard IIoT
#
# Hardware:
#   Sensor  : Sony IMX678 (4-lane MIPI CSI-2, 12-bit Bayer)
#   CSI-2   : csi-16010400.csi21
#   CRU     : cru-ip-16010000.video1
#   Media   : /dev/media0
#   Video   : /dev/video0
#
# The IMX678 outputs SRGGB12_1X12 (12-bit raw Bayer).
# RZ/V2N CRU does NOT support HW demosaicing (Bayer→YUV).
# For display: use RGGB (8-bit Bayer) + GStreamer bayer2rgb.
# For raw capture: use CR12 (12-bit CRU packed) + v4l2-ctl.
#
# Note: Output is greyscale because 12-bit sensor data is truncated
# to 8-bit by the CRU. This is expected with RGGB format.
#
# Requires kernel patches:
#   - 0001-media-rzg2l-cru-increase-CSI-2-max-width-to-4095-for.patch
#   - 0002-media-imx678-fix-pixel-rate-and-link-freq-for-SDR-mo.patch
#
# Supported resolutions: 3840x2160 (default), 1920x1080

MEDIA_DEV="/dev/media0"
VIDEO_DEV="/dev/video0"

SENSOR="imx678 4-001a"
CSI2="csi-16010400.csi21"
CRU="cru-ip-16010000.video1"

MEDIA_FMT="SRGGB12_1X12"
DEFAULT_RES="3840x2160"

# --- Usage ---
print_usage() {
    echo "Usage: $0 [resolution] [--raw]"
    echo ""
    echo "Resolutions: 3840x2160 (default), 1920x1080"
    echo "Options:"
    echo "  --raw    Use CR12 raw Bayer output (12-bit packed, for v4l2-ctl capture)"
    echo "           Default is RGGB (8-bit Bayer for GStreamer bayer2rgb display)"
    echo ""
    echo "Examples:"
    echo "  $0                    # 3840x2160, RGGB for display"
    echo "  $0 1920x1080          # 1080p, RGGB for display"
    echo "  $0 --raw              # 3840x2160, CR12 raw capture"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_usage
    exit 0
fi

# --- Parse arguments ---
RAW_MODE=0
imx678_res="$DEFAULT_RES"

for arg in "$@"; do
    case "$arg" in
        --raw) RAW_MODE=1 ;;
        [0-9]*x[0-9]*) imx678_res="$arg" ;;
    esac
done

case "$imx678_res" in
    3840x2160) echo "Resolution: 3840x2160 (4K @ 30fps)" ;;
    1920x1080) echo "Resolution: 1920x1080 (1080p @ 30fps, binning)" ;;
    *)
        echo "WARNING: $imx678_res may not be supported by the IMX678 driver."
        echo "Supported: 3840x2160, 1920x1080"
        ;;
esac

# --- Detect devices ---
cru_name=$(cat /sys/class/video4linux/video*/name 2>/dev/null | grep -i "CRU" | head -1)
csi2_name=$(cat /sys/class/video4linux/v4l-subdev*/name 2>/dev/null | grep -i "csi" | head -1)
sensor_name=$(cat /sys/class/video4linux/v4l-subdev*/name 2>/dev/null | grep -i "imx678" | head -1)

if [ -z "$cru_name" ]; then
    echo "ERROR: No CRU video device found"
    exit 1
fi

if [ -z "$csi2_name" ]; then
    echo "ERROR: No MIPI CSI-2 sub-device found"
    exit 1
fi

if [ -z "$sensor_name" ]; then
    echo "ERROR: No IMX678 sensor found"
    exit 1
fi

echo "Found CRU   : $cru_name"
echo "Found CSI-2 : $csi2_name"
echo "Found Sensor: $sensor_name"

# --- Configure media pipeline ---
echo ""
echo "Configuring media pipeline for ${imx678_res} ..."

# Reset formats
media-ctl -d $MEDIA_DEV -r

# Enable link: CSI-2 output -> CRU input
media-ctl -d $MEDIA_DEV -l "'${CSI2}':1 -> '${CRU}':0 [1]"

# Set formats (SRGGB12_1X12 throughout the media pipeline)
media-ctl -d $MEDIA_DEV -V "'${SENSOR}':0 [fmt:${MEDIA_FMT}/${imx678_res} field:none]"
media-ctl -d $MEDIA_DEV -V "'${CSI2}':0 [fmt:${MEDIA_FMT}/${imx678_res} field:none]"
media-ctl -d $MEDIA_DEV -V "'${CSI2}':1 [fmt:${MEDIA_FMT}/${imx678_res} field:none]"
media-ctl -d $MEDIA_DEV -V "'${CRU}':0 [fmt:${MEDIA_FMT}/${imx678_res} field:none]"
media-ctl -d $MEDIA_DEV -V "'${CRU}':1 [fmt:${MEDIA_FMT}/${imx678_res} field:none]"

# Set V4L2 video device format
width=$(echo "$imx678_res" | cut -dx -f1)
height=$(echo "$imx678_res" | cut -dx -f2)

if [ "$RAW_MODE" -eq 1 ]; then
    # CR12: 12-bit Raw CRU Packed, raw passthrough
    v4l2-ctl -d $VIDEO_DEV --set-fmt-video=width=${width},height=${height},pixelformat=CR12
    V4L2_FMT="CR12"
else
    # RGGB: 8-bit Bayer for GStreamer bayer2rgb display
    v4l2-ctl -d $VIDEO_DEV --set-fmt-video=width=${width},height=${height},pixelformat=RGGB
    V4L2_FMT="RGGB"
fi

echo ""
echo "Pipeline configured (${V4L2_FMT}). Verifying..."
media-ctl -d $MEDIA_DEV -p
echo ""

echo "=========================================="
echo "  IMX678 ready: ${imx678_res} (${V4L2_FMT})"
echo "=========================================="
echo ""

if [ "$RAW_MODE" -eq 1 ]; then
    echo "--- Raw capture (CR12) ---"
    echo ""
    echo "  Capture single frame:"
    echo "    v4l2-ctl -d $VIDEO_DEV --stream-mmap --stream-count=1 --stream-to=/tmp/frame.raw"
    echo ""
    echo "  Streaming test (10 frames):"
    echo "    v4l2-ctl -d $VIDEO_DEV --stream-mmap --stream-count=10"
    echo ""
    echo "  Frame size: ${width}x${height} x 2 bytes = $(( width * height * 2 )) bytes"
else
    echo "--- GStreamer display (Weston/Wayland) ---"
    echo ""
    echo "  Live display (scaled to 1024x600):"
    echo "    gst-launch-1.0 v4l2src device=$VIDEO_DEV ! \\"
    echo "      video/x-bayer,format=rggb,width=${width},height=${height} ! \\"
    echo "      queue leaky=downstream max-size-buffers=2 ! \\"
    echo "      bayer2rgb ! videoconvert ! videoscale ! \\"
    echo "      video/x-raw,width=1024,height=600 ! \\"
    echo "      waylandsink sync=false"
    echo ""
    echo "  Full resolution display:"
    echo "    gst-launch-1.0 v4l2src device=$VIDEO_DEV ! \\"
    echo "      video/x-bayer,format=rggb,width=${width},height=${height} ! \\"
    echo "      queue leaky=downstream max-size-buffers=2 ! \\"
    echo "      bayer2rgb ! videoconvert ! waylandsink sync=false"
    echo ""
    echo "  Save snapshot as PNG:"
    echo "    gst-launch-1.0 v4l2src device=$VIDEO_DEV num-buffers=1 ! \\"
    echo "      video/x-bayer,format=rggb,width=${width},height=${height} ! \\"
    echo "      bayer2rgb ! videoconvert ! pngenc ! filesink location=/tmp/snapshot.png"
    echo ""
    echo "NOTE: Image will appear greyscale. The 12-bit sensor data is"
    echo "      truncated to 8-bit by the CRU. This is a known limitation."
    echo "      Use --raw for full 12-bit raw data capture."
fi
echo ""
