#!/bin/sh
scriptname=`basename $0`
log() {
    echo "$scriptname: $@"
}
logn() {
    echo -n "$scriptname: $@"
}

mode0=$1
mode1=$2
if [ "$mode0" = "" ]; then
    mode0=4k
fi
if [ "$mode1" = "" ]; then
    mode1=$mode0
fi

if [[ ( "$mode0" = "4k" || "$mode0" = "hdr" || "$mode0" = "dol" ) && ( "$mode1" = "2k" || "$mode1" = "2khdr" || "$mode1" = "2kdol" ) ]]; then
    echo "${mode0} ${mode1} is not supported, use ${mode1} ${mode0} instead."
    exit
fi

env_effective_width=${effective_width}
env_effective_height=${effective_height}

load_modules() {
    udev_services="systemd-udevd systemd-udevd-kernel.socket systemd-udevd-control.socket"
    is_mod=`zcat /proc/config.gz | sed -ne 's/^CONFIG_VIDEO_RZV2N_ISP=//p'`
    case "$is_mod" in
        y)
            ;;
        *)
            if ! lsmod | grep -q mali_iv021_isp_iq; then
                systemctl stop $udev_services
                insmod /lib/modules/`uname -r`/extra/mali_iv021_isp_sensor.ko
                insmod /lib/modules/`uname -r`/extra/mali_iv021_isp_lens.ko
                insmod /lib/modules/`uname -r`/extra/mali_iv021_isp_iq.ko
                systemctl start $udev_services
            fi
            ;;
    esac
    devices=""
    for cam in 0 1; do
        if [ ! -c /dev/video${cam}fr ]; then
            continue;
        fi
        devices="$devices /dev/video${cam}fr"
    done
}

run_userspace_driver() {
    ps | grep mali_iv021_is[p] | awk '{print $1}' | xargs kill 2> /dev/null
    if [ -c /dev/video1fr ]; then
        mali_iv021_isp.elf &
    else
        mali_iv021_isp-single.elf &
    fi
}

calc_selection() {
    width=$1
    height=$2
    effective_width=${env_effective_width:-$3}
    effective_height=${env_effective_height:-$4}
    top=$(((height-effective_height)/2))
    left=$(((width-effective_width)/2))
}

check_selection() {
    err=""
    [ $width -le 0 ] && err="width <= 0\n$err"
    [ $height -le 0 ] && err="height <= 0 \n$err"
    [ $effective_height -le 0 ] && err="effective_height <= 0\n$err"
    [ $effective_width -le 0 ] && err="effective_width <= 0\n$err"
    [ $top -lt 0 ] && err="top < 0\n$err"
    [ $left -lt 0 ] && err="left < 0\n$err"
    if [ "$err" != "" ]; then
        echo "selection error."
        echo -ne $err
        exit 1
    fi
}

set_mode() {
    case "$1" in
# MODE_START
        rawHDplus)
            # RAW-only CRU mode (NO ISP)
            width=1600
            height=900
            effective_width=1600
            effective_height=900
            top=0
            left=0
            preset=0
            RAW_ONLY=1
            ;;
        rawFHD)
            # RAW-only CRU mode (NO ISP)
            width=1920
            height=1080
            effective_width=1920
            effective_height=1080
            top=0
            left=0
            preset=0
            RAW_ONLY=1
            ;;
        raw4k)
            # RAW-only CRU mode (NO ISP)
            width=3840
            height=2160
            effective_width=3840
            effective_height=2160
            top=0
            left=0
            preset=0
            RAW_ONLY=1
            ;;
        2k)
            calc_selection 1932 1088 1920 1080
            preset=2
            ;;
        2kdol)
            calc_selection 1932 1088 1920 1080
            preset=8
            ;;
        2khdr)
            calc_selection 1932 1088 1920 1080
            preset=10
            ;;
        dol)
            calc_selection 3864 2176 3840 2160
            preset=4
            ;;
        hdr)
            calc_selection 3864 2176 3840 2160
            preset=6
            ;;
        4k)
            calc_selection 3864 2176 3840 2160
            preset=0
            ;;
# MODE_END
        *)
            echo "unknown mode - $1" 1>&2
            echo -n "supported modes: "
            sed -ne '/^# MODE_START/,/^# MODE_END/s/\s*\(.*\))/\1/p' < $0 | tr "\n" " "
            echo
            exit 1
            ;;
    esac
}

run_media_ctl() {
    cam=$1
    mode=$2
    set_mode $mode
    if [ ! -c /dev/video${cam}fr ]; then
        return
    fi

    log "$cam: preset=$(($preset+$cam)), ($width, $height) => ${effective_width}x${effective_height}+$left+$top"
    check_selection

    fmt="fmt:SBGGR12_1X12/${width}x${height} field:none"

    csi2=""
    sensor=""
    cru=""
    while read entity; do
        case "$entity" in
            rzg2l_csi2*) csi2="$entity" ;;
            imx415*) sensor="$entity" ;;
            CRU*) cru="$entity" ;;
        esac
    done <<EOT
    `media-ctl -p -d /dev/media$cam | sed -ne 's/- entity [0-9]*: \(.*\) (.*$/\1/p'`
EOT
    if [ "$csi2" != "" ] && [ "$sensor" != "" ] && [ "$cru" != "" ]; then
        media-ctl -d /dev/media$cam -r
        media-ctl -d /dev/media$cam -V "'$csi2':1 [$fmt]"
        media-ctl -d /dev/media$cam -V "'$sensor':0 [$fmt]"
        media-ctl -d /dev/media$cam -l "'$csi2':1 -> '$cru':0 [1]"
        media-ctl -d /dev/media$cam -l "'$sensor':0 -> '$csi2':0 [1]"
        v4l2-ctl -d `media-ctl -d /dev/media$cam -e "$cru"` --set-fmt-video=width=$width,height=$height,pixelformat=BG12
        #-# echo "media-ctl -d /dev/media$cam -r"
        #-# echo "media-ctl -d /dev/media$cam -V \"'$csi2':1 [$fmt]\""
        #-# echo "media-ctl -d /dev/media$cam -V \"'$sensor':0 [$fmt]\""
        #-# echo "media-ctl -d /dev/media$cam -l \"'$csi2':1 -> '$cru':0 [1]\""
        #-# echo "media-ctl -d /dev/media$cam -l \"'$sensor':0 -> '$csi2':0 [1]\""
        #-# echo "v4l2-ctl -d `media-ctl -d /dev/media$cam -e \"$cru\"` --set-fmt-video=width=$width,height=$height,pixelformat=BG12"
    fi
    set_preset $cam $mode
}

set_preset() {
    cam=$1
    set_mode $2
    if [ ! -c /dev/video${cam}fr ]; then
        return;
    fi
    v4l2-ctl -d /dev/video${cam}fr -c isp_sensor_preset=$(($preset+$cam))
    #-# echo "v4l2-ctl -d /dev/video${cam}fr -c isp_sensor_preset=$(($preset+$cam))"
}

set_selection() {
    cam=$1
    set_mode $2
    if [ ! -c /dev/video${cam}fr ]; then
        return;
    fi

    for t in `seq 0 10`; do
        v4l2-ctl -d /dev/video${cam}fr --set-selection target=crop,left=$left,top=$top,width=$effective_width,height=$effective_height
        #-# echo "v4l2-ctl -d /dev/video${cam}fr --set-selection target=crop,left=$left,top=$top,width=$effective_width,height=$effective_height"
        if [ "`v4l2-ctl -d /dev/video${cam}fr --get-selection target=crop | awk '{print $6$8$10$12}'`" = "$left,$top,${effective_width},${effective_height}," ]; then
            break
        fi
        if [ "$t" -eq 10 ]; then
            log "failed to set selections."
            break
        fi
        sleep 0.01
    done
}

run_dummy_sample_app() {
    (
        echo q | /root/sample-app $devices -w 1920 -h 1080 > /dev/null 2>&1 &
        pid=$!
        (
            sleep 3
            kill $pid > /dev/null 2>&1  /dev/null
        ) > /dev/null 2>&1 &
        pid2=$!
        wait $pid > /dev/null 2>&1
        status=$?
        kill $pid2 > /dev/null 2>&1
    )
}

run_dummy_gstreamer() {
    (
        exec > /dev/null
        exec 2> /dev/null
        gst-launch-1.0 -v v4l2src device=/dev/video0fr ! fakesink > /dev/null 2>&1 &
        pid3=$!
        sleep 1
        kill $pid3
        exec > /dev/null
        exec 2> /dev/null
        gst-launch-1.0 -v v4l2src device=/dev/video1fr ! fakesink > /dev/null 2>&1 &
        pid3=$!
        sleep 1
        kill $pid3
    )
}

load_modules

run_media_ctl 0 $mode0
run_media_ctl 1 $mode1

logn "Initializing ."

for i in 1 2; do
    echo -n "."
    [ "$RAW_ONLY" = "1" ] || run_dummy_sample_app
    echo -n "."
    [ "$RAW_ONLY" = "1" ] || run_dummy_gstreamer
done
echo
[ "$RAW_ONLY" = "1" ] || run_userspace_driver
[ "$RAW_ONLY" = "1" ] || run_dummy_sample_app
[ "$RAW_ONLY" = "1" ] || set_selection 0 $mode0
[ "$RAW_ONLY" = "1" ] || set_selection 1 $mode1
log "done."
exit 0
