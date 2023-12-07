#!/bin/sh

cru=$(cat /sys/class/video4linux/video*/name | grep "CRU")
csi2=$(cat /sys/class/video4linux/v4l-subdev*/name | grep "csi2")

# Available resolution of AR0521.
# Please choose one of a following resolution then comment out the rest.
#ar0521_res=1280x800
ar0521_res=1920x1080
#ar0521_res=2592x1944

if [ -z "$cru" ]
then
	echo "No CRU video device founds"
else
	media-ctl -d /dev/media0 -r
	if [ -z "$csi2" ]
	then
		echo "No MIPI CSI2 sub video device founds"
	else
		media-ctl -d /dev/media0 -l "'rzg2l_csi2 10830400.csi2':1 -> 'CRU output':0 [1]"
		media-ctl -d /dev/media0 -V "'rzg2l_csi2 10830400.csi2':1 [fmt:SGRBG8_1X8/$ar0521_res field:none]"
		media-ctl -d /dev/media0 -V "'ar0521 0-0036':0 [fmt:SGRBG8_1X8/$ar0521_res field:none]"
		echo "Link CRU/CSI2 to ar0521 0-0036 with format SGRBG8_1X8 and resolution $ar0521_res"
	fi
fi

v4l2-ctl -c linear_matrix_processing_enable=1
v4l2-ctl -c linear_matrix_rr_coefficient=1501
v4l2-ctl -c linear_matrix_gg_coefficient=1024
v4l2-ctl -c linear_matrix_bb_coefficient=1380
v4l2-ctl -c analogue_gain=130
v4l2-ctl -c gain=70
v4l2-ctl -c exposure=700
