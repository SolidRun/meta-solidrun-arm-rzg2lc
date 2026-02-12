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

    repo init -u https://github.com/SolidRun/meta-solidrun-arm-rzg2lc -b scarthgap -m meta-solidrun-arm-rz.xml
    repo sync

### Optional Proprietary Packages

Renesas offers proprietary drivers for graphics, video codecs, and AI acceleration as part of the [RZ/V2N AI SDK](https://www.renesas.com/en/software-tool/rzv2n-ai-software-development-kit).

Download the RZ/V2N AI SDK source package (`RTK0EF0189F06000SJ_linux-src.zip`) and extract the meta-rz-features layers:

    unzip RTK0EF0189F06000SJ_linux-src.zip

This shall create in the working directory `meta-rz-features/` containing:

- `meta-rz-graphics` - Mali GPU library
- `meta-rz-codecs` - Video codec and DRP library
- `meta-rz-drpai` - DRP-AI accelerator support
- `meta-rz-opencva` - OpenCV accelerator
These packages are optional, yocto can be built without them.

## Setup Build Directory

Initialise a new build directory from Renesas configuration templates:

    TEMPLATECONF=$PWD/meta-renesas/meta-rz-distro/conf/templates/rz-conf/ source poky/oe-init-build-env build

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
