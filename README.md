# Yocto BSP Layer for SolidRun Renesas SoC based Products

This is the SolidRun Yocto BSP Layer for products based on Renesas SoCs.

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

## Binaries

Binaries are generated automatically by our CI infrastructure to [images.solid-run.com](https://images.solid-run.com/RZ/Yocto/vlp4/).

## Patches

To contribute to this layer you should email patches to support@solid-run.com. Please send .patch files as email attachments.

## Dependencies

This layer depends on and inherits from [meta-renesas BSP-4.0.0](https://github.com/renesas-rz/meta-renesas/tree/BSP-4.0.0).

## Build Instructions

### Host Dependencies

Install the [repo](https://gerrit.googlesource.com/git-repo/) command, as well as the "Build Host Packages" per [Yocto Documentation](https://docs.yoctoproject.org/5.0.8/brief-yoctoprojectqs/index.html#build-host-packages).

Alternatively it is possible to use docker for a consistent build environment meeting all requirements:

    docker run --rm -it -v $PWD:/home/pokyuser crops/poky:ubuntu-22.04

For Podman:

    docker run --userns=keep-id:uid=1000,gid=1000 --pids-limit=16384 --rm -it -v $PWD:/home/pokyuser crops/poky:ubuntu-22.04

### Download Yocto Recipes

Start in a new empty directory with plenty of free disk space - at least 150GB. Then download the build recipes:

    repo init -u https://github.com/SolidRun/meta-solidrun-arm-rzg2lc -b scarthgap -m meta-solidrun-arm-rz.xml
    repo sync

#### Optional Proprietary Graphics & Multimedia Packages

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

#### Optional QT Framework

Renesas offers QT support for RZ SoCs [here](https://www.renesas.com/en/software-tool/rz-mpu-qt-package):

Qt6 packages V4.0.0.2 for RZ/G Verified Linux Package V4.0.1 (`RTK0EF0224Z00002ZJ_v4.0.0.2.zip`)

    unzip -j RTK0EF0224Z00002ZJ_v4.0.0.2.zip RTK0EF0224Z00002ZJ_v4.0.0.2/rzg_bsp_qt6.8.3_v4.0.0.2.tar.gz
    tar -xvf rzg_bsp_qt6.8.3_v4.0.0.2.tar.gz

This shall create in the working directory new paths `meta-qt6` and `meta-rz-qt6`.

Note that RZ QT depoends on Proprietary Graphics Layer (RZ/G2LC & RZ/G2L & RZ/V2L) and Proprietary Codecs (RZ/G2L & RZ/V2L only).

### Setup Build Directory

Initialise a new build directory from Renesas configuration templates:

    TEMPLATECONF=$PWD/meta-renesas/meta-rz-distro/conf/templates/rz-conf/ source poky/oe-init-build-env build

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

#### Proprietary Graphics

Inside build directory, run:

    bitbake-layers add-layer ../meta-rz-features/meta-rz-graphics

#### Proprietary Codecs

Inside build directory, run:

    bitbake-layers add-layer ../meta-rz-features/meta-rz-codecs

#### QT

First enable proprietary graphics, and for G2L only, codecs. Then:
Inside build directory, run:

    bitbake-layers add-layer ../meta-qt6
    bitbake-layers add-layer ../meta-rz-qt6

#### Docker

Inside build directory, run:

    bitbake-layers add-layer ../meta-openembedded/meta-networking
    bitbake-layers add-layer ../meta-openembedded/meta-filesystems
    bitbake-layers add-layer ../meta-virtualization

### Supported Machines

- `rzg2lc-sr-som`: RZ/G2LC SoM on Hummingboard IIoT & Ripple
- `rzg2l-sr-som`: RZ/G2L SoM on Hummingboard IIoT & Pro & Ripple
- `rzv2l-sr-som`: RZ/V2L SoM on Hummingboard IIoT & Pro & Ripple

The instructions below use `rzg2lc-sr-som`, substitute as needed.

### Supported Targets

- `firmware-pack`: atf + u-boot
- `core-image-minimal`
- `core-image-full-cmdline`: cli image
- `core-image-qt`: graphical image with QT
- `core-image-weston`: graphical image
- `solidrun-demo-image`: graphical image with QT examples and development tools

The instructions below use `core-image-full-cmdline`, substitute as needed.

### Build

With the build directory set up, any desirable yocto target may be built:

    MACHINE=rzg2lc-sr-som bitbake core-image-full-cmdline

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

### Build configs

It is possible to change some build configs as below:

- GPLv3: choose to disallow GPLv3 packages:

  All recipes that has GPLv3 license will be downgrade to older version that has alternative license (done by meta-gplv2).
  In this setting customer can ignore the risk of strict license GPLv3:
  
      INCOMPATIBLE_LICENSE = "GPLv3 GPLv3+"

## Known Issues

## QT layer disables crypto optimisations:

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

## Many `-native` recipes fail when host gcc is v15 or later

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
