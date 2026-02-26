# Yocto BSP Layer for SolidRun Renesas SoC based Products

This is the SolidRun Yocto BSP Layer for products based on Renesas SoCs.

> **Note:** Platform-specific instructions are marked with **(RZ/G2L | G2LC | G2UL | V2L)** or **(RZ/V2N)**. Sections without markers apply to all platforms.

## HW Compatibility

Currently the following boards and MPUs are supported:

- [RZ/G2UL SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-g2ul-som/)

  - [HummingBoard Ripple](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2lc-base/)

- [RZ/G2LC SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-g2lc-som/)

  - [HummingBoard IIoT](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2l-iot-sbc/)
  - [HummingBoard Ripple](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2lc-base/)

- [RZ/G2L SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-g2l-som/)

  - [HummingBoard IIoT](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2l-iot-sbc/)
  - [HummingBoard Pro](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2l-sbc/)
  - [HummingBoard Ripple](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2lc-base/)

- [RZ/V2L SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-v2l-som/)

  **Partial support only, in particular NPU not yet supported in this release.**

  - [HummingBoard IIoT](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2l-iot-sbc/)
  - [HummingBoard Pro](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2l-sbc/)
  - [HummingBoard Ripple](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2lc-base/)

- [RZ/V2N SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-v2n-som/)

  - [HummingBoard IIoT](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/hummingboard-rz-series-sbcs/hummingboard-rz-g2l-iot-sbc/)
  - [SolidSense AIoT](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/solidsense-aiot/)

## Binaries

Binaries are generated automatically by our CI infrastructure:

- RZ/G2L, RZ/G2LC, RZ/G2UL, RZ/V2L, RZ/V2N: [images.solid-run.com/RZ/Yocto/vlp4/](https://images.solid-run.com/RZ/Yocto/vlp4/)

## Patches

To contribute to this layer you should email patches to support@solid-run.com. Please send .patch files as email attachments.

## Dependencies

This layer depends on and inherits from [meta-renesas](https://github.com/renesas-rz/meta-renesas):

- RZ/G2L, RZ/G2LC, RZ/G2UL, RZ/V2L: [BSP-4.0.0](https://github.com/renesas-rz/meta-renesas/tree/BSP-4.0.0)
- RZ/V2N: [RZV2N-BSP-2.0.1](https://github.com/renesas-rz/meta-renesas/tree/RZV2N-BSP-2.0.1)

## Build Instructions

### Host Dependencies

Install the [repo](https://gerrit.googlesource.com/git-repo/) command, as well as the "Build Host Packages" per [Yocto Documentation](https://docs.yoctoproject.org/5.0.8/brief-yoctoprojectqs/index.html#build-host-packages).

Alternatively it is possible to use docker for a consistent build environment meeting all requirements:

    docker run --rm -it -v $PWD:/home/pokyuser crops/poky:ubuntu-22.04

For Podman:

    docker run --userns=keep-id:uid=1000,gid=1000 --pids-limit=16384 --rm -it -v $PWD:/home/pokyuser crops/poky:ubuntu-22.04

### Download Yocto Recipes

Start in a new empty directory with plenty of free disk space - at least 150GB. Then download the build recipes:

    repo init -u https://github.com/SolidRun/meta-solidrun-arm-rzg2lc -b scarthgap_rzv2n_dev -m meta-solidrun-arm-rz.xml
    repo sync

#### Optional Proprietary Graphics & Multimedia Packages **(RZ/G2L | G2LC | G2UL | V2L)**

Renesas offers proprietary drivers for graphics and multimedia processing [here](https://www.renesas.com/en/software-tool/rz-mpu-verified-linux-package-61-cip#download):

- RZ MPU Graphics Library V4.1.2.6 for RZ/G2LC & RZ/G2L & RZ/V2L (`RTK0EF0045Z14001ZJ-4.1.2.6_EN.zip`)

      unzip -j RTK0EF0045Z14001ZJ-4.1.2.6_EN.zip RTK0EF0045Z14001ZJ-4.1.2.6_EN/meta-rz-features_graphics_4.1.2.6.tar.gz
      tar -xvf meta-rz-features_graphics_4.1.2.6.tar.gz
  
  This shall create in the working directory new path `meta-rz-features/meta-rz-graphics`.

- RZ MPU Video Codec Library V4.1.3.1 for RZ/G2L & RZ/V2L (`RTK0EF0045Z16001ZJ_v4.1.3.1_EN.zip`)

      unzip -j RTK0EF0045Z16001ZJ_v4.1.3.1_EN.zip RTK0EF0045Z16001ZJ_v4.1.3.1_EN/meta-rz-features_codec_v4.1.3.1.tar.gz
      tar -xvf meta-rz-features_codec_v4.1.3.1.tar.gz
  
  This shall create in the working directory new path `meta-rz-features/meta-rz-codecs`.

These packages are optional, yocto can be built without them.

#### Optional Proprietary Packages **(RZ/V2N)**

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

#### Optional QT Framework **(RZ/G2L | G2LC | G2UL | V2L)**

Renesas offers QT support for RZ SoCs [here](https://www.renesas.com/en/software-tool/rz-mpu-qt-package):

Qt6 packages V4.0.0.2 for RZ/G Verified Linux Package V4.0.1 (`RTK0EF0224Z00002ZJ_v4.0.0.2.zip`)

    unzip -j RTK0EF0224Z00002ZJ_v4.0.0.2.zip RTK0EF0224Z00002ZJ_v4.0.0.2/rzg_bsp_qt6.8.3_v4.0.0.2.tar.gz
    tar -xvf rzg_bsp_qt6.8.3_v4.0.0.2.tar.gz

This shall create in the working directory new paths `meta-qt6` and `meta-rz-qt6`.

Note that RZ QT depoends on Proprietary Graphics Layer (RZ/G2LC & RZ/G2L & RZ/V2L) and Proprietary Codecs (RZ/G2L & RZ/V2L only).

### Setup Build Directory

Initialise a new build directory from Renesas configuration templates:

    TEMPLATECONF=$PWD/meta-renesas/meta-rz-distro/conf/templates/vlp-v4-conf/ source poky/oe-init-build-env build

Then add to `conf/bblayers.conf` the SolidRun meta layers:

    BBLAYERS += "${TOPDIR}/../meta-solidrun-arm-rzg2lc/meta"
    BBLAYERS += "${TOPDIR}/../meta-solidrun-arm-rzg2lc/meta-rzg2l"
    BBLAYERS += "${TOPDIR}/../meta-solidrun-arm-rzg2lc/meta-rzv2n"

Finally review and modify default configuration files as needed:

- `conf/bblayers.conf`
- `conf/local.conf`

When returning to the build directory at a later time the command below should be used instead:

    source poky/oe-init-build-env build

### Enable Optional Features

#### Proprietary Graphics **(All Platforms)**

Inside build directory, run:

    bitbake-layers add-layer ../meta-rz-features/meta-rz-graphics

#### Proprietary Codecs **(All Platforms)**

Inside build directory, run:

    bitbake-layers add-layer ../meta-rz-features/meta-rz-codecs

#### DRP-AI **(RZ/V2N Only)**

    bitbake-layers add-layer ../meta-rz-features/meta-rz-drpai

#### OpenCVA **(RZ/V2N Only)**

    bitbake-layers add-layer ../meta-rz-features/meta-rz-opencva

#### QT **(RZ/G2L | G2LC | G2UL | V2L)**

First enable proprietary graphics, and for G2L only, codecs. Then:

    bitbake-layers add-layer ../meta-qt6
    bitbake-layers add-layer ../meta-rz-qt6

#### Docker **(All Platforms)**

    bitbake-layers add-layer ../meta-openembedded/meta-networking
    bitbake-layers add-layer ../meta-openembedded/meta-filesystems
    bitbake-layers add-layer ../meta-virtualization

#### ROS2 Humble **(RZ/V2N Only)**

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

##### Testing ROS2

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

### Supported Machines

- `rzg2lc-sr-som`: RZ/G2LC SoM on Hummingboard IIoT & Ripple
- `rzg2l-sr-som`: RZ/G2L SoM on Hummingboard IIoT & Pro & Ripple
- `rzv2l-sr-som`: RZ/V2L SoM on Hummingboard IIoT & Pro & Ripple
- `rzv2n-sr-som`: RZ/V2N SoM on HummingBoard IIoT & SolidSense AIoT

The instructions below use `rzg2lc-sr-som`, substitute as needed.

### Supported Targets

#### RZ/G2L | G2LC | G2UL | V2L

- `firmware-pack`: atf + u-boot
- `core-image-minimal`
- `core-image-full-cmdline`: cli image
- `core-image-qt`: graphical image with QT
- `core-image-weston`: graphical image
- `solidrun-demo-image`: graphical image with QT examples and development tools

#### RZ/V2N

- `firmware-pack`: atf + u-boot
- `core-image-minimal`
- `core-image-full-cmdline`: cli image
- `core-image-weston`: graphical image

The instructions below use `core-image-full-cmdline`, substitute as needed.

### Build

With the build directory set up, any desirable yocto target may be built:

    MACHINE=rzg2lc-sr-som bitbake core-image-full-cmdline

Or for RZ/V2N:

    MACHINE=rzv2n-sr-som bitbake core-image-full-cmdline

After completing the images for the target machine will be available in the output directory `tmp/deploy/images/<machine>/`, e.g.:

```
❯ ls -lh tmp/deploy/images/rzg2lc-sr-som
insgesamt 1,4G
-rw-r--r-- 2 somebody users   54K  9. Nov 18:12 bl2_bp_esd-rzg2lc-sr-som.bin
-rw-r--r-- 2 somebody users  3,6K 10. Nov 17:00 core-image-full-cmdline-rzg2lc-sr-som.rootfs-20251110155524.wic.bmap
-rw-r--r-- 2 somebody users  232M 10. Nov 17:00 core-image-full-cmdline-rzg2lc-sr-som.rootfs-20251110155524.wic.gz
lrwxrwxrwx 2 somebody users    68 10. Nov 17:00 core-image-full-cmdline-rzg2lc-sr-som.rootfs.wic.bmap -> core-image-full-cmdline-rzg2lc-sr-som.rootfs-20251110155524.wic.bmap
lrwxrwxrwx 2 somebody users    66 10. Nov 17:00 core-image-full-cmdline-rzg2lc-sr-som.rootfs.wic.gz -> core-image-full-cmdline-rzg2lc-sr-som.rootfs-20251110155524.wic.gz
-rw-r--r-- 2 somebody users  683K  9. Nov 18:12 fip-rzg2lc-sr-som.bin
-rw-r--r-- 2 somebody users  276K  9. Nov 17:42 Flash_Writer_SCIF_RZG2LC_HUMMINGBOARD_DDR4_1GB_1PCS.mot
-rw-r--r-- 2 somebody users  276K  9. Nov 17:42 Flash_Writer_SCIF_RZG2LC_HUMMINGBOARD_DDR4_2GB_1PCS.mot
-rw-r--r-- 2 somebody users  276K  9. Nov 17:42 Flash_Writer_SCIF_RZG2LC_HUMMINGBOARD_DDR4_512MB_1PCS.mot
...
```

For the RZ/V2N, key output artifacts include `bl2_bp_spi-rzv2n-sr-som.bin`, `fip-rzv2n-sr-som.bin`, and `Flash_Writer_SCIF_RZV2N_SR_SOM_8GB_LPDDR4X.mot`.

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

## U-Boot Environment Storage

**RZ/G2L | G2LC | G2UL | V2L:** By default, U-Boot stores its environment in SD/eMMC.

**RZ/V2N:** By default, U-Boot stores its environment in **SPI flash** at offset `0x001E0000` with a sector size of `0x20000` (`CONFIG_ENV_IS_IN_SPI_FLASH=y`).

For systems booting from **eMMC**, the U-Boot configuration must be modified to store the environment on eMMC instead. Create a config fragment in your meta layer:

**File:** `meta-rzv2n/recipes-bsp/u-boot/u-boot-renesas/emmc-env.cfg`

    # Use eMMC for U-Boot environment instead of SPI flash
    # CONFIG_ENV_IS_IN_SPI_FLASH is not set
    CONFIG_ENV_IS_IN_MMC=y
    CONFIG_SYS_MMC_ENV_DEV=0
    CONFIG_SYS_MMC_ENV_PART=1

**File:** `meta-rzv2n/recipes-bsp/u-boot/u-boot-renesas_%.bbappend`

    FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
    SRC_URI:append = " file://emmc-env.cfg"

This will apply the eMMC environment configuration during the U-Boot build.

## Flashing

Write the SD card image using bmaptool or dd:

    bmaptool copy tmp/deploy/images/<machine>/core-image-full-cmdline-<machine>.rootfs.wic.gz /dev/sdX

Or:

    zcat tmp/deploy/images/<machine>/core-image-full-cmdline-<machine>.rootfs.wic.gz | dd of=/dev/sdX bs=1M iflag=fullblock oflag=direct status=progress

For firmware flashing (BL2, FIP, Flash Writer), refer to the SolidRun documentation:
- [RZ/G2L, G2LC, G2UL, V2L Documentation](https://solidrun.atlassian.net/wiki/spaces/developer/pages/286654475/)
- [RZ/V2N SoM Documentation](https://solidrun.atlassian.net/wiki/spaces/developer/pages/661307393/)

## Device Tree Overlays **(RZ/V2N Only)**

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

### Build configs

It is possible to change some build configs as below:

- GPLv3: choose to disallow GPLv3 packages:

  All recipes that has GPLv3 license will be downgrade to older version that has alternative license (done by meta-gplv2).
  In this setting customer can ignore the risk of strict license GPLv3:
  
      INCOMPATIBLE_LICENSE = "GPLv3 GPLv3+"

## Known Issues

### QT layer disables crypto optimisations **(RZ/G2L | G2LC | G2UL | V2L)**

After enabling `meta-rz-qt6` layer, yocto no longer builds with arm crypto instructions:

```
# expected:
TUNE_FEATURES        = "aarch64 crypto cortexa55"
# actual:
TUNE_FEATURES        = "aarch64  cortexa55"
```

To re-enable them, **remove or comment** below lines from `meta-rz-qt6/conf/layer.conf`

    # Remove crypto feature because some boards lack cryptographic hardware support
    TUNE_FEATURES:remove = "crypto"

### Many `-native` recipes fail when host gcc is v15 or later

On systems with gcc v15 or later, a range of `*-native` tasks fail:

- unzip-native
- m4-native
- pkgconfig-native
- gmp-native
- libgpg-error-native
- ncurses-native
- gdbm-native
- libtirpc-native
- cmake-native
- llvm-native
- parted-native
- bash-native
- git-native
- e2fsprogs-native
- elfutils-native
- rust-llvm-native
- cairo-native
- ckermit-native
- flex-native

This requires a substantial number of patches applied to poky:

- https://github.com/yoctoproject/poky/commit/b63fff4544c7e2033d689c686de9ab7aeef6a253
- https://github.com/yoctoproject/poky/commit/9bea9b739490da27646baf21777c76e15b801422
- https://github.com/yoctoproject/poky/commit/7de652686657eea29974a24cf3a1a698a08edd08
- https://github.com/yoctoproject/poky/commit/f06f09415b53db0b5c209da4a40f1dfc0541a157
- https://github.com/yoctoproject/poky/commit/0fdc4f72f599c79a37baa15e909c6379556d87a2
- https://github.com/yoctoproject/poky/commit/8ade657e16a69c3bdff731d92b644184e7519010
- https://github.com/yoctoproject/poky/commit/2a0bd475e827952b6d97348693ed8a1faac957ec
- https://github.com/yoctoproject/poky/commit/e2e54e0354ed375a18bcc0758b7edb395b9a68bd
- https://github.com/yoctoproject/poky/commit/6b639e19757b7321347eeb811c470a00b0735851
- https://github.com/yoctoproject/poky/commit/c345127b52d21944543882f86b8ddd43e188e87c
- https://github.com/yoctoproject/poky/commit/f19d608f5822eb7d76a15315b801651445ce2926
- https://github.com/yoctoproject/poky/commit/f1647fba72042f1c131716f367eea03faddf6ba3
- https://github.com/yoctoproject/poky/commit/fb9746b787d6914272fee8f43f39017b4fba532d
- https://github.com/yoctoproject/poky/commit/93c7e114572fa7b607fe1165ce70c7f2fdf26265
- https://github.com/yoctoproject/poky/commit/38b5ba89e600455018f902edaa4ecfec6c4d68c7
- https://github.com/yoctoproject/poky/commit/19dd05ccc99e250364138c116324af942249a8a8
- https://github.com/yoctoproject/poky/commit/38a5779745ec3a75cb573c802139b7fcb853f21d
- https://github.com/yoctoproject/poky/commit/cb17b874de640dfe135401c324c9e74c103e8ce5
- https://github.com/yoctoproject/poky/commit/765333686d4c1921d8d4727ce3e439e294236492
- https://github.com/yoctoproject/poky/commit/dcfcbb21c229110aa667ded8df7539f0c6bb6877
- https://github.com/yoctoproject/poky/commit/2a7d38f814b5f4f043e4baf7d3a2d643b85f689f
- https://github.com/openembedded/meta-openembedded/commit/8e135096102ca2ce0ee64f42b88268b2ef5c10aa
- https://github.com/openembedded/meta-openembedded/commit/b57123a0900e3aa2682e58c582387ed9d09958cf

Apply patches individually:

```
pushd poky
git cherry-pick b63fff4544c7e2033d689c686de9ab7aeef6a253
git cherry-pick 9bea9b739490da27646baf21777c76e15b801422
git cherry-pick 7de652686657eea29974a24cf3a1a698a08edd08
git cherry-pick f06f09415b53db0b5c209da4a40f1dfc0541a157
git cherry-pick 0fdc4f72f599c79a37baa15e909c6379556d87a2
git cherry-pick 52ac1f33095106e4ee8df5b1e4fb3ce0a95984fa
git cherry-pick 8ade657e16a69c3bdff731d92b644184e7519010
git cherry-pick 2a0bd475e827952b6d97348693ed8a1faac957ec
git cherry-pick e2e54e0354ed375a18bcc0758b7edb395b9a68bd
git cherry-pick 6b639e19757b7321347eeb811c470a00b0735851
git cherry-pick c345127b52d21944543882f86b8ddd43e188e87c
git cherry-pick f19d608f5822eb7d76a15315b801651445ce2926
git cherry-pick f1647fba72042f1c131716f367eea03faddf6ba3
git cherry-pick fb9746b787d6914272fee8f43f39017b4fba532d
git cherry-pick 93c7e114572fa7b607fe1165ce70c7f2fdf26265
git cherry-pick 38b5ba89e600455018f902edaa4ecfec6c4d68c7
git cherry-pick 19dd05ccc99e250364138c116324af942249a8a8
git cherry-pick 38a5779745ec3a75cb573c802139b7fcb853f21d
git cherry-pick cb17b874de640dfe135401c324c9e74c103e8ce5
git cherry-pick 765333686d4c1921d8d4727ce3e439e294236492
git cherry-pick dcfcbb21c229110aa667ded8df7539f0c6bb6877
git cherry-pick 2a7d38f814b5f4f043e4baf7d3a2d643b85f689f
popd

pushd meta-openembedded
git cherry-pick 8e135096102ca2ce0ee64f42b88268b2ef5c10aa
git cherry-pick b57123a0900e3aa2682e58c582387ed9d09958cf
popd
```

Alternatively upgrade poky from pinned version 5.0.8 to 5.0.13

```
pushd poky
git reset --hard yocto-5.0.13
popd
```
