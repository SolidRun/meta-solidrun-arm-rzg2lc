require recipes-graphics/images/core-image-weston.bb
require include/rz-distro-common.inc
require include/rz-modules-common.inc

SUMMARY = "SolidRun RZ/V2N Quick Draw AI Demo Image"
DESCRIPTION = "Weston-based image with the Quick Draw AI demo application pre-installed and auto-starting"

IMAGE_INSTALL:append = " \
	gstreamer1.0 \
	gstreamer1.0-plugins-base \
	gstreamer1.0-plugins-good \
	gstreamer1.0-plugins-bad \
	gstreamer1.0-plugins-bad-bayer \
	gstreamer1.0-plugins-ugly \
	libdrm \
	libdrm-tests \
	fb-test \
	python3-pillow \
	python3-numpy \
	evtest \
	xcursor-transparent-theme \
	adwaita-icon-theme \
	v4l2-init-scripts \
	quickdraw-init \
"
