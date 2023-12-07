# meta-solidrun

This is a Yocto build layer(version:dunfell) that provides support for SolidRun's RZ/G2LC based platforms.

Currently the following boards and MPUs are supported:

- Board: RZG2LC HummingBoard RZ/G2LC Kit / MPU: R9A77G044C (RZ/G2LC)
- Board: RZG2L HummingBoard RZ/G2L Kit / MPU: R9A77G044L (RZ/G2L)
- Board: RZV2L HummingBoard RZ/V2L Kit / MPU: R9A07G054L (RZ/V2L)

## Patches

To contribute to this layer you should email patches to support@solid-run.com. Please send .patch files as email attachments.

## Dependencies

This layer depends on:

    URI: git://git.yoctoproject.org/poky
    layers: meta, meta-poky, meta-yocto-bsp
    branch: dunfell
    revision: b8f1972b8482860d649641ad34ec8a17ef1dd983

    URI: git://git.openembedded.org/meta-openembedded
    layers: meta-oe, meta-python, meta-multimedia
    branch: dunfell
    revision: 9135c7ea7350d5d241f4afc3b28087122ebe2d19

    URI: http://git.yoctoproject.org/cgit.cgi/meta-gplv2/
    layers: meta-gplv2
    branch: dunfell
    revision: 60b251c25ba87e946a0ca4cdc8d17b1cb09292ac

    URI: https://github.com/renesas-rz/meta-renesas.git
    layers: meta-renesas
    branch: dunfell/rz
    revision: 5377babf0f79b1a6a434503c5d083e5b047da47d
    BSP: 3.0.5 patch 1

    (Optional: core-image-qt)
    URI: https://github.com/meta-qt5/meta-qt5.git
    layers: meta-qt5
    revision: c1b0c9f546289b1592d7a895640de103723a0305

    (Optional: Docker)
    URI: https://git.yoctoproject.org/git/meta-virtualization
    layers: meta-virtualization
    branch: dunfell
    revision: 35c723774ee06b3c1831f00a2cbf25cbeae132e1

## Build Instructions

Assume that $WORK is the current working directory.
The following instructions require a Poky installation (or equivalent).

**Below git configuration is required:**
```bash
    $ git config --global user.email "you@example.com"
    $ git config --global user.name "Your Name"
```

**Download the Yocto Project Layers (require repo app):**
```bash
repo init -u https://github.com/SolidRun/meta-solidrun-arm-rzg2lc.git -b dunfell -m meta-solidrun-arm-rzg2lc.xml
repo sync
```

**Download proprietary graphics drivers and/or multimedia codecs from** [Renesas](https://www.renesas.com/us/en/products/microcontrollers-microprocessors/rz-mpus/rzg-linux-platform/rzg-marketplace/verified-linux-package/rzg-verified-linux-package):
- RZ MPU Graphics Library for RZ/G2{L,LC,UL} and RZ/V2L v1.1.0
- RZ MPU Video Codec Library for RZ/G2L and RZ/V2L v1.1.0
(Graphic drivers are required for Wayland, Codecs optional)

After downloading the proprietary packages, please decompress - then put meta-rz-features folder at $WORK.

**Optionally a Docker environment can be used for the build:**
```bash
docker pull crops/poky:ubuntu-20.04
docker run --rm -it -v ${PWD}:/work crops/poky:ubuntu-20.04 --workdir=/work
```

**Initialize a build using the 'oe-init-build-env' script in Poky. e.g.:**
```bash
TEMPLATECONF=$PWD/meta-solidrun-arm-rzg2lc/docs/template/conf/rzg2lc-solidrun source poky/oe-init-build-env build
```

**Review / Edit default configuration files:**
- `conf/bblayers.conf`
- `conf/local.conf`

**Build a target using bitbake:**
```bash
MACHINE=<board> bitbake <target>
# e.g
MACHINE=rzg2lc-hummingboard bitbake core-image-bsp core-image-weston core-image-qt
```
**Valid boards:**
| Renesas MPU    | board |
| -------- | ------- |
| RZ/G2LC | rzg2lc-hummingboard |
| RZ/G2L | rzg2l-hummingboard |
| RZ/V2L | rzv2l-hummingboard |


**Valid targets:**
- firmware-pack: atf + u-boot
- core-image-bsp: cli image
- core-image-weston: graphical image
- core-image-qt: graphical image including qt

After completing the images for the target machine will be available in the output
directory _'tmp/deploy/images/\<supported board name\>'_.

**Images generated:**
* Image (generic Linux Kernel binary image file)
* DTB for target machine
* core-image-\<target\>-\<machine name\>.tar.bz2 (rootfs tar+bzip2)
* core-image-\<target\>-\<machine name\>.ext4  (rootfs ext4 format)
* core-image-\<target\>-\<machine name\>.wic  (bootable sdcard image)

## Build configs

**It is possible to change some build configs as below:**
* GPLv3: choose to not allow, or allow, GPLv3 packages
  * **Non-GPLv3 (default):** not allow GPLv3 license. All recipes that has GPLv3 license will be downgrade to older version that has alternative license (done by meta-gplv2). In this setting customer can ignore the risk of strict license GPLv3
    `INCOMPATIBLE_LICENSE = "GPLv3 GPLv3+"`
  * Allow-GPLv3: allow GPLv3 license. If user is fine with strict copy-left license GPLv3, can use this setting to get newer software version.
    `#INCOMPATIBLE_LICENSE = "GPLv3 GPLv3+"`
* CIP Core: choose the version of CIP Core to build with. CIP Core are software packages that are maintained for long term by CIP community. You can select by changing "CIP_MODE".
  * **Buster (default):** use as many packages from CIP Core Buster as possible.
    `CIP_MODE = "Buster"`
  * Bullseye: use as many packages from CIP Core Bullseye.
    `CIP_MODE = "Bullseye"`
  * None CIP Core: not use CIP Core at all, use all default version from Yocto 3.1 Dunfell
    `CIP_MODE = "None" or unset CIP_MODE`

* QT Demo: choose QT5 Demonstration to build with core-image-qt. QT5 Demos are some applications to demonstrate QT5 framework.
  * Unset QT_DEMO (default): all QT5 Demos are not built with core-image-qt.
    `#QT_DEMO = "1"`
  * Allow QT_DEMO: all QT5 Demos are built and included in core-image-qt.
    `QT_DEMO = "1"`
* Realtime Linux: choose realtime characteristic of Linux kernel to build with. You can enable this feature by setting the value "1" to IS_RT_BSP variable in local.conf:
  `IS_RT_BSP = "1"`
 
