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
# The RZ/V2N CRU can:
#   - Pass through raw Bayer (CR12 format, 12-bit CRU packed)
#   - Demosaic Bayer→YUV for display (YUYV format)
#
# Requires kernel patch:
#   - 0002-media-imx678-fix-pixel-rate-and-link-freq-for-SDR-mo.patch
#
# Note: RZ/V2N CSI-2 max width is 2800 pixels. 4K (3840x2160) is NOT
# supported. Use 1920x1080 (IMX678 binning mode).
#
# Supported resolutions: 1920x1080

MEDIA_DEV="/dev/media0"
VIDEO_DEV="/dev/video0"

SENSOR="imx678 4-001a"
CSI2="csi-16010400.csi21"
CRU="cru-ip-16010000.video1"

MEDIA_FMT="SRGGB12_1X12"
DEFAULT_RES="1920x1080"

# --- Usage ---
print_usage() {
    echo "Usage: $0 [--raw]"
    echo ""
    echo "Resolution: 1920x1080 (CSI-2 max width is 2800, 4K not supported)"
    echo "Options:"
    echo "  --raw    Use CR12 raw Bayer output (for v4l2-ctl capture, no display)"
    echo "           Default is YUYV (CRU demosaicing for GStreamer display)"
    echo ""
    echo "Examples:"
    echo "  $0                    # 1920x1080, YUYV for display"
    echo "  $0 --raw              # 1920x1080, CR12 raw capture"
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
    esac
done

echo "Resolution: ${imx678_res} (1080p @ 30fps, binning mode)"

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
    # YUYV: CRU demosaics Bayer→YUV for GStreamer display
    v4l2-ctl -d $VIDEO_DEV --set-fmt-video=width=${width},height=${height},pixelformat=YUYV
    V4L2_FMT="YUYV"
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
    echo "      video/x-raw,format=YUY2,width=${width},height=${height},framerate=30/1 ! \\"
    echo "      queue leaky=downstream max-size-buffers=2 ! \\"
    echo "      videoconvert ! videoscale ! \\"
    echo "      video/x-raw,width=1024,height=600 ! \\"
    echo "      waylandsink sync=false"
    echo ""
    echo "  Full resolution display:"
    echo "    gst-launch-1.0 v4l2src device=$VIDEO_DEV ! \\"
    echo "      video/x-raw,format=YUY2,width=${width},height=${height},framerate=30/1 ! \\"
    echo "      queue leaky=downstream max-size-buffers=2 ! \\"
    echo "      videoconvert ! waylandsink sync=false"
    echo ""
    echo "  Save snapshot as PNG:"
    echo "    gst-launch-1.0 v4l2src device=$VIDEO_DEV num-buffers=1 ! \\"
    echo "      video/x-raw,format=YUY2,width=${width},height=${height} ! \\"
    echo "      videoconvert ! pngenc ! filesink location=/tmp/snapshot.png"
    echo ""
    echo "NOTE: CRU demosaicing from 12-bit Bayer may produce greyscale."
    echo "      If colors look wrong, the HW demosaicing may not fully"
    echo "      support 12-bit input. Use --raw for correct raw data."
fi
echo ""
