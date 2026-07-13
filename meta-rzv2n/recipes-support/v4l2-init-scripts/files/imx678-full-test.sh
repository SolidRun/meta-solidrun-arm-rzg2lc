#!/bin/sh
#
# IMX678 RAW12 comprehensive test for RZ/V2N (HummingBoard-IIoT), aligned with
# Renesas' imx415 RAW procedure (v4l2-init_ISP_or_RAW12.sh raw modes).
#
# Renesas imx415 (reference):  SBGGR12_1X12 / BG12, res 3840x2160 / 1920x1080 / 1600x900
# IMX678 (this board):         SRGGB12_1X12 / RG12 (RGGB), same resolutions
# No ISP -> software debayer (2 px / 3 bytes, bilinear).
#
# Usage:
#   imx678-full-test.sh capture            # both res: media-ctl -p, capture, analyse
#   imx678-full-test.sh capture 1920x1080  # one res
#   imx678-full-test.sh stream-bayer  <res>  # v4l2src->bayer2rgb (NO python)  [expected: fails on packed RG12]
#   imx678-full-test.sh stream-uyvy   <res>  # CRU HW demosaic UYVY (NO python)
#   imx678-full-test.sh stream-sw     <res>  # packed RG12 -> python unpack -> waylandsink (WITH python)
#   imx678-full-test.sh stream-net    <res>  # packed RG12 -> python unpack -> MJPEG over network (headless, no compositor)
#   imx678-full-test.sh still         <res>  # capture 1 frame -> python debayer -> BMP (WITH python)
#
# stream-net (Ethernet, no display needed):
#   Default = TCP server on the board; the HOST connects to the board's IP.
#     board:  imx678-full-test.sh stream-net 1920x1080          # serves MJPEG/TCP on :5000
#     host :  gst-launch-1.0 tcpclientsrc host=<BOARD_IP> port=5000 ! multipartdemux ! jpegdec ! videoconvert ! autovideosink sync=false
#   Set HOST=<host-ip> to push low-latency RTP/JPEG over UDP instead (board -> host):
#     board:  HOST=192.168.1.20 imx678-full-test.sh stream-net 1920x1080
#     host :  gst-launch-1.0 udpsrc port=5000 caps="application/x-rtp,media=video,encoding-name=JPEG,payload=26" ! rtpjpegdepay ! jpegdec ! autovideosink sync=false

MEDIA=/dev/media0; VID=/dev/video0; SUBDEV=/dev/v4l-subdev1
SENSOR="imx678 4-001a"; CSI2="csi-16010400.csi21"; CRU="cru-ip-16010000.video1"
FMT=SRGGB12_1X12; V4L2FMT=RG12; BAYER=rggb
OUT=/tmp/imx678-test; mkdir -p "$OUT"
EXPO=${EXPO:-500}; GAIN=${GAIN:-100}

wayland_env() {
    # Weston runs as its own uid (e.g. 996), so its socket is under
    # /run/user/<uid>/, not /run/user/0. Auto-detect it.
    for d in /run/user/*; do
        s=$(ls "$d"/wayland-* 2>/dev/null | grep -v '\.lock' | head -1)
        [ -n "$s" ] && { export XDG_RUNTIME_DIR="$d"; export WAYLAND_DISPLAY=$(basename "$s"); break; }
    done
    echo "  WAYLAND_DISPLAY=$WAYLAND_DISPLAY  XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
}

pipeline() {   # $1 = WxH   -> raw SRGGB12 passthrough, all pads incl. cru-ip
    RES=$1
    media-ctl -d $MEDIA -r
    media-ctl -d $MEDIA -V "'$SENSOR':0 [fmt:$FMT/$RES field:none]"
    media-ctl -d $MEDIA -V "'$CSI2':0   [fmt:$FMT/$RES field:none]"
    media-ctl -d $MEDIA -V "'$CSI2':1   [fmt:$FMT/$RES field:none]"
    media-ctl -d $MEDIA -V "'$CRU':0    [fmt:$FMT/$RES field:none]"
    media-ctl -d $MEDIA -V "'$CRU':1    [fmt:$FMT/$RES field:none]"
    v4l2-ctl -d $VID --set-fmt-video=width=${RES%x*},height=${RES#*x},pixelformat=$V4L2FMT
    v4l2-ctl -d $SUBDEV -c exposure=$EXPO -c analogue_gain=$GAIN 2>/dev/null
}

modinfo_md5() {
    echo "=== loaded camera modules (md5) ==="
    for m in rzg2l_cru rzg2l_csi2 imx678; do
        f=$(modinfo -F filename $m 2>/dev/null)
        [ -n "$f" ] && echo "  $m: $(md5sum "$f" 2>/dev/null | cut -d' ' -f1)  $f"
    done
    echo "  (fixed rzg2l-cru = 1b2e53f86b18db55206b6611cf85bb11 ; fixed rzg2l-csi2 built with lane-check patch)"
}

analyse() {   # $1 raw file  $2 W  $3 H
    python3 - "$1" "$2" "$3" <<'PY'
import sys, numpy as np
fn,W,H=sys.argv[1],int(sys.argv[2]),int(sys.argv[3])
bpl=((W*3//2+127)//128)*128
raw=np.fromfile(fn,np.uint8)
print("  file=%d bytes  expected=%d (bpl=%d x H=%d)"%(raw.size,bpl*H,bpl,H))
if raw.size < bpl*H: print("  SHORT FRAME"); sys.exit()
f=raw[:bpl*H].reshape(H,bpl); nz=(f>2)
lc=np.where(nz.any(1),(bpl-1-nz[:,::-1].argmax(1)),0)
pct=100*lc.mean()/bpl
print("  per-line fill: mean=%.1f%% (last byte %d of %d)  min=%d max=%d"%(pct,lc.mean(),bpl,lc.min(),lc.max()))
print("  VERDICT:", "FULL LINE (truncation fixed)" if pct>97 else "TRUNCATED at ~%.0f%% (AXI/bandwidth bug)"%pct)
PY
}

capture_one() {   # $1 WxH
    RES=$1; W=${RES%x*}; H=${RES#*x}
    echo; echo "########################  $RES  ########################"
    pipeline "$RES"
    echo "--- media-ctl -p (topology) ---"
    media-ctl -p -d $MEDIA | sed -n '/Device topology/,$p'
    echo "--- v4l2 capture format ---"
    v4l2-ctl -d $VID --get-fmt-video | sed 's/^/  /'
    RAW="$OUT/imx678_${RES}.raw"
    echo "--- capturing 1 frame -> $RAW ---"
    v4l2-ctl -d $VID --stream-mmap --stream-count=1 --stream-to="$RAW"
    echo "--- analysis ---"
    analyse "$RAW" "$W" "$H"
    # on-board debayer to BMP if PIL present
    if python3 -c "import PIL" 2>/dev/null; then
        /root/debayer_raw12_to_bmp.py "$RAW" --width $W --height $H --bayer $BAYER --outfile "$OUT/imx678_${RES}.bmp" 2>/dev/null \
          && echo "  BMP: $OUT/imx678_${RES}.bmp"
    fi
}

make_raw12_bin() {
cat > /root/raw12_bin.py <<'PY'
#!/usr/bin/env python3
# Unpack packed RAW12 (2px/3B) -> 2x2-binned RGB8. Drops stale frames so the
# preview stays low-latency even when unpacking is slower than the capture rate.
import sys, select, numpy as np, argparse
ap=argparse.ArgumentParser(); ap.add_argument("--width",type=int,default=3840)
ap.add_argument("--height",type=int,default=2160); ap.add_argument("--bpl",type=int,default=0)
a=ap.parse_args(); W,H=a.width,a.height
bpl=a.bpl or ((W*3//2+127)//128)*128; fsz=bpl*H; payload=W*3//2
o=sys.stdout.buffer; i=sys.stdin.buffer; ifd=i.fileno()
def readframe():
    b=b''
    while len(b)<fsz:
        c=i.read(fsz-len(b))
        if not c: return None
        b+=c
    return b
while True:
    buf=readframe()
    if buf is None: break
    # drain backlog: keep only the newest fully-available frame
    while select.select([ifd],[],[],0)[0]:
        nxt=readframe()
        if nxt is None: break      # EOF: keep current buf, process it below
        buf=nxt
    f=np.frombuffer(buf,np.uint8).reshape(H,bpl)[:,:payload]
    t=f.reshape(H,W//2,3).astype(np.uint16); b0,b1,b2=t[:,:,0],t[:,:,1],t[:,:,2]
    px=np.empty((H,W),np.uint16); px[:,0::2]=(b0<<4)|(b2&0xF); px[:,1::2]=(b1<<4)|(b2>>4)
    R=px[0::2,0::2]; Gr=px[0::2,1::2]; Gb=px[1::2,0::2]; B=px[1::2,1::2]
    rgb=np.empty((H//2,W//2,3),np.uint8)
    rgb[:,:,0]=(R>>4).astype(np.uint8); rgb[:,:,1]=(((Gr+Gb)>>1)>>4).astype(np.uint8); rgb[:,:,2]=(B>>4).astype(np.uint8)
    try:
        o.write(rgb.tobytes()); o.flush()
    except BrokenPipeError:
        break
PY
chmod +x /root/raw12_bin.py
}

case "$1" in
    capture)
        modinfo_md5
        if [ -n "$2" ]; then capture_one "$2"; else capture_one 3840x2160; capture_one 1920x1080; fi
        echo; echo "Copy $OUT/*.raw (+ *.bmp) to a host to inspect."
        ;;
    stream-bayer)   # NO python; direct bayer2rgb (expected to FAIL on packed RG12)
        RES=${2:-3840x2160}; pipeline "$RES"; wayland_env
        echo "[stream-bayer] v4l2src ! video/x-bayer(bpp=12) ! bayer2rgb  (expected: negotiation fail on packed RG12)"
        gst-launch-1.0 v4l2src device=$VID ! \
          "video/x-bayer,format=$BAYER,width=${RES%x*},height=${RES#*x},bpp=12" ! \
          bayer2rgb ! videoconvert ! videoscale ! video/x-raw,width=1280,height=720 ! waylandsink sync=false
        ;;
    stream-uyvy)    # NO python; CRU hardware demosaic to UYVY
        RES=${2:-3840x2160}
        media-ctl -d $MEDIA -r
        media-ctl -d $MEDIA -V "'$SENSOR':0 [fmt:$FMT/$RES field:none]"
        media-ctl -d $MEDIA -V "'$CSI2':1 [fmt:$FMT/$RES field:none]"
        v4l2-ctl -d $VID --set-fmt-video=width=${RES%x*},height=${RES#*x},pixelformat=UYVY
        v4l2-ctl -d $SUBDEV -c exposure=$EXPO -c analogue_gain=$GAIN 2>/dev/null
        wayland_env
        echo "[stream-uyvy] v4l2src UYVY ! waylandsink  (works only if CRU HW-demosaic is real)"
        gst-launch-1.0 v4l2src device=$VID ! \
          "video/x-raw,format=UYVY,width=${RES%x*},height=${RES#*x}" ! \
          videoconvert ! videoscale ! video/x-raw,width=1280,height=720 ! waylandsink sync=false
        ;;
    stream-sw)      # WITH python; packed RG12 -> unpack -> waylandsink
        RES=${2:-3840x2160}; W=${RES%x*}; H=${RES#*x}; make_raw12_bin; pipeline "$RES"; wayland_env
        echo "[stream-sw] v4l2-ctl | raw12_bin.py | fdsrc ! waylandsink  (software preview ${W}x${H}->$((W/2))x$((H/2)))"
        v4l2-ctl -d $VID --stream-mmap --stream-count=0 --stream-to=- 2>/dev/null \
          | /root/raw12_bin.py --width $W --height $H \
          | gst-launch-1.0 fdsrc ! rawvideoparse format=rgb width=$((W/2)) height=$((H/2)) framerate=15/1 ! \
              queue leaky=downstream max-size-buffers=2 ! videoconvert ! videoscale ! \
              video/x-raw,width=1280,height=720 ! waylandsink sync=false
        ;;
    stream-net)     # WITH python; packed RG12 -> unpack -> MJPEG over Ethernet (no compositor needed)
        RES=${2:-3840x2160}; W=${RES%x*}; H=${RES#*x}; make_raw12_bin; pipeline "$RES"
        PW=$((W/2)); PH=$((H/2)); PORT=${PORT:-5000}; FPS=${FPS:-15}; Q=${JPEG_Q:-85}
        if [ -n "$HOST" ]; then
            NETSINK="rtpjpegpay ! udpsink host=$HOST port=$PORT sync=false"
            echo "[stream-net] UDP/RTP-JPEG -> $HOST:$PORT   (preview ${PW}x${PH} @ ${FPS}fps)"
            echo "  On the HOST run:"
            echo "    gst-launch-1.0 udpsrc port=$PORT caps=\"application/x-rtp,media=video,encoding-name=JPEG,payload=26\" ! \\"
            echo "      rtpjpegdepay ! jpegdec ! videoconvert ! autovideosink sync=false"
        else
            NETSINK="multipartmux boundary=spionisto ! tcpserversink host=0.0.0.0 port=$PORT sync=false"
            BIP=$(ip -4 route get 1.1.1.1 2>/dev/null | grep -o 'src [0-9.]*' | awk '{print $2}')
            echo "[stream-net] MJPEG/TCP server on 0.0.0.0:$PORT (board IP ${BIP:-?})   (preview ${PW}x${PH} @ ${FPS}fps)"
            echo "  On the HOST run:"
            echo "    gst-launch-1.0 tcpclientsrc host=${BIP:-<BOARD_IP>} port=$PORT ! \\"
            echo "      multipartdemux ! jpegdec ! videoconvert ! autovideosink sync=false"
        fi
        v4l2-ctl -d $VID --stream-mmap --stream-count=0 --stream-to=- 2>/dev/null \
          | /root/raw12_bin.py --width $W --height $H \
          | gst-launch-1.0 fdsrc ! rawvideoparse format=rgb width=$PW height=$PH framerate=$FPS/1 ! \
              queue leaky=downstream max-size-buffers=2 ! videoconvert ! \
              jpegenc quality=$Q ! $NETSINK
        ;;
    still)          # WITH python; one frame frozen on the panel (no BMP decoder needed)
        RES=${2:-3840x2160}; W=${RES%x*}; H=${RES#*x}; make_raw12_bin; pipeline "$RES"; wayland_env
        v4l2-ctl -d $VID --stream-mmap --stream-count=1 --stream-to=$OUT/still_$RES.raw
        # unpack the one frame to raw RGB (W/2 x H/2) and freeze it on the panel
        /root/raw12_bin.py --width $W --height $H < $OUT/still_$RES.raw > $OUT/still_$RES.rgb
        # also keep a BMP for copying to a host
        python3 -c "import PIL" 2>/dev/null && \
          /root/debayer_raw12_to_bmp.py $OUT/still_$RES.raw --width $W --height $H --bayer $BAYER --outfile $OUT/still_$RES.bmp 2>/dev/null
        gst-launch-1.0 filesrc location=$OUT/still_$RES.rgb ! \
          rawvideoparse format=rgb width=$((W/2)) height=$((H/2)) framerate=1/1 ! \
          imagefreeze ! videoconvert ! videoscale ! video/x-raw,width=1280,height=720 ! \
          waylandsink sync=false
        ;;
    *)
        echo "Usage: $0 {capture [WxH] | stream-bayer <res> | stream-uyvy <res> | stream-sw <res> | stream-net <res> | still <res>}"
        echo "  res: 3840x2160 (4K) or 1920x1080 (FHD)"
        ;;
esac
