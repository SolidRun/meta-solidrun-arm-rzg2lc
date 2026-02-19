# Yocto Build Instructions for SolidRun RZ/V2N SoM

This document describes how to build a Yocto image for the SolidRun RZ/V2N SoM with optional proprietary graphics, video codec, and DRP-AI support.

## HW Compatibility

- [RZ/V2N SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-v2n-som/)

  - [HummingBoard IIoT](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2l-iot-sbc/)
  - [SolidSense AIoT](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/solidsense-aiot/)

## Host Dependencies

Install the [repo](https://gerrit.googlesource.com/git-repo/) command, as well as the "Build Host Packages" per [Yocto Documentation](https://docs.yoctoproject.org/5.0.8/brief-yoctoprojectqs/index.html#build-host-packages).

Alternatively it is possible to use docker for a consistent build environment meeting all requirements:

    docker run --rm -it -v $PWD:/home/pokyuser crops/poky:ubuntu-22.04

For Podman:

    docker run --userns=keep-id:uid=1000,gid=1000 --pids-limit=16384 --rm -it -v $PWD:/home/pokyuser crops/poky:ubuntu-22.04

## Download Yocto Recipes

Start in a new empty directory with plenty of free disk space - at least 150GB. Then download the build recipes:

    repo init -u https://github.com/SolidRun/meta-solidrun-arm-rzg2lc -b scarthgap_rzv2n_dev -m meta-solidrun-arm-rz.xml
    repo sync

### Optional Proprietary Packages

Renesas offers proprietary drivers for graphics, video codecs, and AI acceleration as part of the [RZ/V2N AI SDK](https://www.renesas.com/en/software-tool/rzv2n-ai-software-development-kit).

To obtain the RZ/V2N AI SDK v6.00 source code:

1. Visit the [RZ/V2N AI SDK build instructions](https://renesas-rz.github.io/rzv_ai_sdk/6.00/howto_build_aisdk_v2n.html) page.
2. Follow the link to download the [RZ/V2N AI SDK v6.00 Source Code](https://www.renesas.com/en/document/sws/rzv2n-ai-sdk-v600-source-code) (`RTK0EF0189F06000SJ_linux-src.zip`).

Extract the archive and copy `meta-rz-features` into the Yocto workspace (alongside `meta-solidrun-arm-rzg2lc`):

    unzip RTK0EF0189F06000SJ_linux-src.zip
    cp -r meta-rz-features/ <your-yocto-workspace>/

This provides the following layers needed when enabling GPU, DRP-AI, codecs, or OpenCVA support:

- `meta-rz-graphics` - Mali GPU library
- `meta-rz-codecs` - Video codec and DRP library
- `meta-rz-drpai` - DRP-AI accelerator support
- `meta-rz-opencva` - OpenCV accelerator

These packages are optional — Yocto can be built without them.

## Setup Build Directory

Initialise a new build directory from Renesas configuration templates:

    TEMPLATECONF=$PWD/meta-renesas/meta-rz-distro/conf/templates/vlp-v4-conf/ source poky/oe-init-build-env build

Then add to `conf/bblayers.conf` the SolidRun meta layers:

    bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta
    bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta-rzg2l
    bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta-rzv2n

When returning to the build directory at a later time the command below should be used instead:

    source poky/oe-init-build-env build

### Enable Optional Features

#### Proprietary Graphics

    bitbake-layers add-layer ../meta-rz-features/meta-rz-graphics

#### Proprietary Codecs

    bitbake-layers add-layer ../meta-rz-features/meta-rz-codecs

#### DRP-AI

    bitbake-layers add-layer ../meta-rz-features/meta-rz-drpai

#### OpenCVA

    bitbake-layers add-layer ../meta-rz-features/meta-rz-opencva

#### Docker

    bitbake-layers add-layer ../meta-openembedded/meta-networking
    bitbake-layers add-layer ../meta-openembedded/meta-filesystems
    bitbake-layers add-layer ../meta-virtualization

#### ROS2 Humble

ROS2 support is provided by the [Renesas RZ/V2N ROS2 Package](https://github.com/renesas-rz/rzv2n_ros2) which depends on [meta-ros](https://github.com/ros/meta-ros). This requires the proprietary graphics layer (meta-rz-graphics) to be enabled first.

Clone the required repositories from the top-level Yocto directory (above `build/`):

    git clone -b scarthgap https://github.com/ros/meta-ros.git
    git clone https://github.com/renesas-rz/rzv2n_ros2.git
    cp -r rzv2n_ros2/meta-rz-features-ros/meta-rzv2-ros-humble .

Enable the ROS2 package configuration by adding the following to `conf/local.conf`:

    include conf/ros2.inc

The `ros2.inc` file is provided by the `meta-rzv2n` layer (at `meta-rzv2n/conf/ros2.inc`) and includes the ROS2 package list, Mali GPU provider preferences, and build fixes. It is based on the Renesas `meta-ros-humble.patch` with fixes for packages that have missing dependencies.

Then from the build directory, add the ROS2 layers:

    bitbake-layers add-layer ../meta-ros/meta-ros-common
    bitbake-layers add-layer ../meta-ros/meta-ros2
    bitbake-layers add-layer ../meta-ros/meta-ros2-humble
    bitbake-layers add-layer ../meta-rzv2-ros-humble

**Note:** The ROS2 build requires network access to fetch some packages. The `ros2.inc` file sets `BB_NO_NETWORK = "0"` automatically.

**Note:** The `meta-rzv2-ros-humble` layer includes a `librealsense2` bbappend that requires the Intel RealSense recipe. If you are not using a RealSense camera, add the following to `conf/local.conf` to avoid the dangling bbappend error:

    BB_DANGLINGAPPENDS_WARNONLY = "1"

#### Testing ROS2

After booting the image on the board, verify ROS2 is working with the talker/listener demo. Open two SSH sessions to the board:

**Terminal 1** — start the C++ talker node:

    source /opt/ros/humble/setup.bash
    ros2 run demo_nodes_cpp talker

Expected output:

    [INFO] [talker]: Publishing: 'Hello World: 1'
    [INFO] [talker]: Publishing: 'Hello World: 2'

**Terminal 2** — start the Python listener node:

    source /opt/ros/humble/setup.bash
    ros2 run demo_nodes_py listener

Expected output:

    [INFO] [listener]: I heard: [Hello World: 1]
    [INFO] [listener]: I heard: [Hello World: 2]

Useful commands for inspecting the ROS2 environment:

    ros2 topic list          # list active topics (e.g. /chatter)
    ros2 node list           # list active nodes (e.g. /talker, /listener)
    ros2 topic echo /chatter # print messages on a topic

### Full AI Build

To enable all proprietary features (graphics, codecs, DRP-AI) along with Docker support, run all layer additions together:

    bitbake-layers add-layer ../meta-openembedded/meta-networking
    bitbake-layers add-layer ../meta-openembedded/meta-filesystems
    bitbake-layers add-layer ../meta-virtualization
    bitbake-layers add-layer ../meta-rz-features/meta-rz-graphics
    bitbake-layers add-layer ../meta-rz-features/meta-rz-codecs
    bitbake-layers add-layer ../meta-rz-features/meta-rz-drpai

## Supported Targets

- `firmware-pack`: atf + u-boot
- `core-image-minimal`
- `core-image-full-cmdline`: cli image
- `core-image-weston`: graphical image

### Graphics and Weston

The `core-image-weston` target includes a Weston compositor configured with the DRM backend. It works in two modes depending on available libraries:

- **With Mali GPU** (`meta-rz-graphics` enabled): Weston uses the GL renderer for hardware-accelerated compositing.
- **Without Mali GPU**: Weston uses the pixman software renderer. Add `use-pixman=true` to the `[core]` section of `/etc/xdg/weston/weston.ini` on the target:

      [core]
      backend=drm
      use-pixman=true

To verify GPU acceleration is active on the board:

    dmesg | grep -i mali        # should show "Probed as mali0"
    lsmod | grep mali            # should show mali_kbase loaded
    weston-simple-egl            # should report ~60 FPS

## Build

With the build directory set up, build the desired target:

    MACHINE=rzv2n-sr-som bitbake core-image-full-cmdline

### Output Artifacts

After completing, the images will be available in `tmp/deploy/images/rzv2n-sr-som/`. Key artifacts:

- `bl2_bp_spi-rzv2n-sr-som.bin` - BL2 boot loader
- `fip-rzv2n-sr-som.bin` - FIP image (ATF + U-Boot)
- `Flash_Writer_SCIF_RZV2N_SR_SOM_8GB_LPDDR4X.mot` - Flash Writer
- `core-image-full-cmdline-rzv2n-sr-som.rootfs.wic.gz` - SD card image

## Flashing

Write the SD card image using bmaptool or dd:

    bmaptool copy tmp/deploy/images/rzv2n-sr-som/core-image-full-cmdline-rzv2n-sr-som.rootfs.wic.gz /dev/sdX

Or:

    zcat tmp/deploy/images/rzv2n-sr-som/core-image-full-cmdline-rzv2n-sr-som.rootfs.wic.gz | dd of=/dev/sdX bs=1M iflag=fullblock oflag=direct status=progress

For firmware flashing (BL2, FIP, Flash Writer), refer to the SolidRun [RZ/V2N SoM documentation](https://solidrun.atlassian.net/wiki/spaces/developer/pages/661307393/).

## Device Tree Overlays

Optional hardware such as the DSI display panel and MIPI-CSI camera can be enabled via device tree overlays in `extlinux.conf`. After flashing the SD card, mount the boot partition and edit `/boot/extlinux/extlinux.conf`:

    label linux
      kernel ../Image
      devicetree ../renesas/r9a09g056n48-hummingboard-iiot.dtb
      fdtoverlays ../renesas/rzv2n-hummingboard-iiot-panel-dsi-WJ70N3TYJHMNG0.dtbo ../renesas/rzv2n-hummingboard-iiot-csi-camera-imx678.dtbo
      append root=/dev/mmcblk0p2 rootwait

Available overlays:

- `rzv2n-hummingboard-iiot-panel-dsi-WJ70N3TYJHMNG0.dtbo` - Winstar 7" DSI display panel
- `rzv2n-hummingboard-iiot-csi-camera-imx678.dtbo` - Sony IMX678 MIPI-CSI camera

Each overlay can be used independently — include only the ones for connected hardware.
