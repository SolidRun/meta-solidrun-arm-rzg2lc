# Add GStreamer and graphics packages for RZ/V2N Weston images
IMAGE_INSTALL:append:rzv2n-sr-som = " \
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
"
