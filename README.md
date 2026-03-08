# Yocto BSP Layer for SolidRun Renesas SoC Products

This is the SolidRun Yocto BSP Layer for products based on Renesas RZ/G2L|G2LC|G2UL, RZ/V2L, and RZ/V2N SoCs.

## Table of Contents

- [Quick Start](#quick-start)
- [Hardware Compatibility](#hardware-compatibility)
- [Pre-built Binaries](#pre-built-binaries)
- [Feature Matrix](#feature-matrix)
- [Detailed Build Instructions](#detailed-build-instructions)
  - [Prerequisites](#prerequisites)
  - [Download Yocto Recipes](#download-yocto-recipes)
  - [Setup Build Directory](#setup-build-directory)
  - [Build Images](#build-images)
  - [Flashing](#flashing)
- [Advanced Configuration](#advanced-configuration)
  - [Optional Proprietary Packages](#optional-proprietary-packages)
  - [Enabling Optional Features](#enabling-optional-features)
  - [Device Tree Overlays (RZ/V2N)](#device-tree-overlays-rzv2n)
  - [U-Boot Environment Storage](#u-boot-environment-storage)
  - [Build Configuration Options](#build-configuration-options)
- [Known Issues & Troubleshooting](#known-issues--troubleshooting)
- [Contributing](#contributing)

---

## Quick Start

Get a minimal bootable image in 5 steps:

```bash
# 1. Install prerequisites (Ubuntu/Debian)
sudo apt-get install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint xterm python3-subunit mesa-common-dev zstd liblz4-tool

# 2. Install repo tool
mkdir -p ~/.local/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.local/bin/repo
chmod a+x ~/.local/bin/repo
export PATH=~/.local/bin:$PATH

# 3. Download Yocto recipes (requires ~150GB free space)
mkdir yocto-rz && cd yocto-rz
repo init -u https://github.com/SolidRun/meta-solidrun-arm-rzg2lc -b scarthgap_rzv2n_dev -m meta-solidrun-arm-rz.xml
repo sync

# 4. Setup build environment and add SolidRun layers
TEMPLATECONF=$PWD/meta-renesas/meta-rz-distro/conf/templates/vlp-v4-conf/ source poky/oe-init-build-env build
bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta
bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta-rzg2l
bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta-rzv2n

# 5. Build minimal image (choose your machine)
MACHINE=rzv2n-sr-som bitbake core-image-minimal
# Or for RZ/G2L: MACHINE=rzg2l-sr-som bitbake core-image-minimal
# Or for RZ/G2LC: MACHINE=rzg2lc-sr-som bitbake core-image-minimal
# Or for RZ/G2UL: MACHINE=rzg2ul-sr-som bitbake core-image-minimal
# Or for RZ/V2L: MACHINE=rzv2l-sr-som bitbake core-image-minimal
```

**Flash to SD card:**
```bash
bmaptool copy tmp/deploy/images/rzv2n-sr-som/core-image-minimal-rzv2n-sr-som.rootfs.wic.gz /dev/sdX
# bmaptool copy tmp/deploy/images/${machine_name}/core-image-minimal-${machine_name}.rootfs.wic.gz /dev/sdX
```

For firmware flashing and advanced features, see sections below.

---

## Hardware Compatibility

### Supported Hardware

| SoM | Carrier Boards | Machine Name |
|-----|----------------|--------------|
| [RZ/G2UL SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-g2ul-som/) | HummingBoard Ripple | `rzg2ul-sr-som` |
| [RZ/G2LC SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-g2lc-som/) | HummingBoard IIoT, Ripple | `rzg2lc-sr-som` |
| [RZ/G2L SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-g2l-som/) | HummingBoard IIoT, Pro, Ripple | `rzg2l-sr-som` |
| [RZ/V2L SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-v2l-som/) | HummingBoard IIoT, Pro, Ripple | `rzv2l-sr-som` |
| [RZ/V2N SoM](https://www.solid-run.com/embedded-industrial-iot/renesas-rz-family/rz-v2n-som/) | HummingBoard IIoT, SolidSense AIoT | `rzv2n-sr-som` |

> **Note:** RZ/V2L has partial support only — NPU not yet supported in this release.

---

## Pre-built Binaries

Pre-built images are available from our CI:
- **All platforms:** [images.solid-run.com/RZ/Yocto/vlp4/](https://images.solid-run.com/RZ/Yocto/vlp4/)

---

## Feature Matrix

| Feature | RZ/G2UL | RZ/G2LC | RZ/G2L | RZ/V2L | RZ/V2N |
|---------|---------|---------|--------|--------|--------|
| **Core Images** | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Mali GPU (Graphics)** | — | ✓ | ✓ | ✓ | ✓ |
| **Video Codecs** | — | — | ✓ | ✓ | ✓ |
| **Qt6** | ✓ | ✓ | ✓ | ✓ | — |
| **Weston (Wayland)** | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Docker** | ✓ | ✓ | ✓ | ✓ | ✓ |
| **DRP-AI** | — | — | — | — | ✓ |
| **OpenCVA** | — | — | — | — | ✓ |
| **ROS2 Humble** | — | — | — | — | ✓ |

### Available Image Targets

**RZ/G2L | G2LC | G2UL | V2L:**
- `firmware-pack` - ATF + U-Boot
- `core-image-minimal` - Bare minimum bootable system
- `core-image-full-cmdline` - CLI with common utilities
- `core-image-weston` - Graphical desktop with Weston compositor
- `core-image-qt` - Graphical desktop with Qt6
- `solidrun-demo-image` - Full graphical demo with Qt examples and dev tools

**RZ/V2N:**
- `firmware-pack` - ATF + U-Boot
- `core-image-minimal` - Bare minimum bootable system
- `core-image-full-cmdline` - CLI with common utilities
- `core-image-weston` - Graphical desktop with Weston compositor
- `quickdraw-demo-image` - Weston image with Quick Draw AI demo (auto-starts after boot)

---

## Detailed Build Instructions

### Prerequisites

#### System Requirements
- **Disk space:** Minimum 150GB free
- **RAM:** 8GB minimum, 16GB recommended
- **OS:** Ubuntu 22.04 LTS or similar Linux distribution

#### Required Packages

Install build dependencies ([Yocto documentation](https://docs.yoctoproject.org/5.0.8/brief-yoctoprojectqs/index.html#build-host-packages)):

```bash
sudo apt-get install gawk wget git diffstat unzip texinfo gcc build-essential \
  chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
  iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint \
  xterm python3-subunit mesa-common-dev zstd liblz4-tool
```

#### Install repo tool

```bash
mkdir -p ~/.local/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.local/bin/repo
chmod a+x ~/.local/bin/repo
export PATH=~/.local/bin:$PATH
```

#### Alternative: Docker Environment

For a consistent build environment without installing dependencies:

```bash
# Docker
docker run --rm -it -v $PWD:/home/pokyuser crops/poky:ubuntu-22.04

# Podman
podman run --userns=keep-id:uid=1000,gid=1000 --pids-limit=16384 --rm -it \
  -v $PWD:/home/pokyuser crops/poky:ubuntu-22.04
```

### Download Yocto Recipes

Create a new working directory and download the build recipes:

```bash
mkdir yocto-rz && cd yocto-rz
repo init -u https://github.com/SolidRun/meta-solidrun-arm-rzg2lc -b scarthgap_rzv2n_dev -m meta-solidrun-arm-rz.xml
repo sync
```

**Dependencies:** This layer depends on [meta-renesas](https://github.com/renesas-rz/meta-renesas):
- **RZ/G2L, RZ/G2LC, RZ/G2UL, RZ/V2L:** [BSP-4.0.0](https://github.com/renesas-rz/meta-renesas/tree/BSP-4.0.0)
- **RZ/V2N:** [RZV2N-BSP-2.0.1](https://github.com/renesas-rz/meta-renesas/tree/RZV2N-BSP-2.0.1)

#### Yocto Workspace Directory Structure

After `repo sync` completes, your workspace will look like this:

```
yocto-rz/                           # Top-level workspace directory
├── build/                          # Build directory (created later with oe-init-build-env)
│   ├── conf/
│   │   ├── bblayers.conf          # Layer configuration
│   │   └── local.conf             # Build settings (MACHINE, parallel make, etc.)
│   └── tmp/
│       └── deploy/
│           └── images/
│               └── <machine>/      # Build outputs (SD images, firmware, etc.)
├── meta-openembedded/             # OpenEmbedded layers (networking, python, etc.)
│   ├── meta-filesystems/
│   ├── meta-networking/
│   ├── meta-oe/
│   ├── meta-python/
│   └── ...
├── meta-renesas/                  # Renesas BSP layers
│   ├── meta-rz-common/
│   ├── meta-rz-distro/
│   ├── meta-rzg2l/
│   ├── meta-rzg2ul/
│   ├── meta-rzv2h/
│   ├── meta-rzv2l/
│   └── meta-rzv2n/
├── meta-solidrun-arm-rzg2lc/      # SolidRun BSP layers (this repository)
│   ├── meta/                      # Common SolidRun recipes
│   ├── meta-rzg2l/                # RZ/G2L-specific recipes
│   └── meta-rzv2n/                # RZ/V2N-specific recipes
├── meta-virtualization/           # Docker support (optional)
├── poky/                          # Yocto Project reference build system
│   ├── bitbake/
│   ├── meta/
│   ├── meta-poky/
│   ├── meta-selftest/
│   ├── meta-skeleton/
│   └── oe-init-build-env          # Build environment setup script
├── meta-rz-features/              # Renesas proprietary packages (optional, added manually)
│   ├── meta-rz-graphics/          # Mali GPU drivers
│   ├── meta-rz-codecs/            # Video codec libraries
│   ├── meta-rz-drpai/             # DRP-AI support (RZ/V2N)
│   └── meta-rz-opencva/           # OpenCV accelerator (RZ/V2N)
├── meta-qt6/                      # Qt6 framework (optional, added manually)
├── meta-rz-qt6/                   # Renesas Qt6 integration (optional)
├── meta-ros/                      # ROS2 support (optional, for RZ/V2N)
│   ├── meta-ros-common/
│   ├── meta-ros2/
│   └── meta-ros2-humble/
└── meta-rzv2-ros-humble/          # Renesas ROS2 integration (optional, for RZ/V2N)
```

**Key Directories:**
- **Top-level** (`yocto-rz/`): All meta layers and poky
- **build/**: Compiled artifacts, generated after running `source poky/oe-init-build-env build`
- **meta-*** directories**: Yocto layers containing recipes, configuration, and patches
- **Proprietary layers** (marked "optional"): Manually downloaded from Renesas (see [Optional Proprietary Packages](#optional-proprietary-packages))

### Setup Build Directory

Initialize the build environment:

```bash
TEMPLATECONF=$PWD/meta-renesas/meta-rz-distro/conf/templates/vlp-v4-conf/ source poky/oe-init-build-env build
```

Add SolidRun meta layers to `conf/bblayers.conf`:

```bash
bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta
bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta-rzg2l
bitbake-layers add-layer ../meta-solidrun-arm-rzg2lc/meta-rzv2n
```

**Returning later?** Use this instead:
```bash
source poky/oe-init-build-env build
```

You can now review and modify configuration files:
- `conf/bblayers.conf` - Layer configuration
- `conf/local.conf` - Build settings (parallel builds, download mirrors, etc.)

### Build Images

Build your target image:

```bash
# RZ/V2N
MACHINE=rzv2n-sr-som bitbake core-image-full-cmdline

# RZ/G2LC
MACHINE=rzg2lc-sr-som bitbake core-image-full-cmdline

# RZ/G2L
MACHINE=rzg2l-sr-som bitbake core-image-full-cmdline

# RZ/V2L
MACHINE=rzv2l-sr-som bitbake core-image-full-cmdline

# RZ/G2UL
MACHINE=rzg2ul-sr-som bitbake core-image-full-cmdline
```

Build artifacts will be in `tmp/deploy/images/<machine>/`:

**Example output:**
```
tmp/deploy/images/rzv2n-sr-som/
├── bl2_bp_spi-rzv2n-sr-som.bin                    # Boot loader (BL2)
├── fip-rzv2n-sr-som.bin                           # Firmware Image Package (TF-A + U-Boot)
├── Flash_Writer_SCIF_RZV2N_SR_SOM_8GB_LPDDR4X.mot # Flash Writer tool
├── core-image-full-cmdline-rzv2n-sr-som.rootfs.wic.gz  # SD card image
└── core-image-full-cmdline-rzv2n-sr-som.rootfs.wic.bmap # Block map for fast flashing
```

### Flashing

#### Flash SD Card Image

Using bmaptool (recommended - faster):
```bash
bmaptool copy tmp/deploy/images/<machine>/core-image-full-cmdline-<machine>.rootfs.wic.gz /dev/sdX
```

Or using dd:
```bash
zcat tmp/deploy/images/<machine>/core-image-full-cmdline-<machine>.rootfs.wic.gz | \
  dd of=/dev/sdX bs=1M iflag=fullblock oflag=direct status=progress
```

#### Flash Firmware (BL2, FIP, Flash Writer)

For detailed firmware flashing instructions, refer to SolidRun documentation:
- **RZ/G2L, G2LC, G2UL, V2L:** [Documentation](https://solidrun.atlassian.net/wiki/spaces/developer/pages/286654475/)
- **RZ/V2N:** [SoM Documentation](https://solidrun.atlassian.net/wiki/spaces/developer/pages/661307393/)

---

## Advanced Configuration

### Optional Proprietary Packages

Renesas provides proprietary drivers for enhanced functionality. These are **optional** — images can be built without them.

#### RZ/G2L | G2LC | G2UL | V2L Packages

Download from [Renesas RZ MPU Verified Linux Package](https://www.renesas.com/en/software-tool/rz-mpu-verified-linux-package-61-cip#download):

**1. Graphics Library (Mali GPU) - V4.1.2.6**

File: `RTK0EF0045Z14001ZJ-4.1.2.6_EN.zip`

```bash
unzip -j RTK0EF0045Z14001ZJ-4.1.2.6_EN.zip \
  RTK0EF0045Z14001ZJ-4.1.2.6_EN/meta-rz-features_graphics_4.1.2.6.tar.gz
tar -xvf meta-rz-features_graphics_4.1.2.6.tar.gz
```

Creates: `meta-rz-features/meta-rz-graphics`

**2. Video Codec Library - V4.1.3.1**

File: `RTK0EF0045Z16001ZJ_v4.1.3.1_EN.zip`

```bash
unzip -j RTK0EF0045Z16001ZJ_v4.1.3.1_EN.zip \
  RTK0EF0045Z16001ZJ_v4.1.3.1_EN/meta-rz-features_codec_v4.1.3.1.tar.gz
tar -xvf meta-rz-features_codec_v4.1.3.1.tar.gz
```

Creates: `meta-rz-features/meta-rz-codecs`

**3. Qt6 Framework - V4.0.0.2**

File: `RTK0EF0224Z00002ZJ_v4.0.0.2.zip`

> **Requires:** Graphics library and Codecs (for G2L/V2L only)

```bash
unzip -j RTK0EF0224Z00002ZJ_v4.0.0.2.zip \
  RTK0EF0224Z00002ZJ_v4.0.0.2/rzg_bsp_qt6.8.3_v4.0.0.2.tar.gz
tar -xvf rzg_bsp_qt6.8.3_v4.0.0.2.tar.gz
```

Creates: `meta-qt6` and `meta-rz-qt6`

#### RZ/V2N Packages

Download from [RZ/V2N AI SDK v6.00](https://renesas-rz.github.io/rzv_ai_sdk/6.00/howto_build_aisdk_v2n.html):

**RZ/V2N AI SDK Source Code**

File: `RTK0EF0189F06000SJ_linux-src.zip`

> **⚠️ Important:** Extract to `/tmp/` first to avoid overwriting existing layers like `meta-renesas`, `poky`, or `meta-openembedded` in your workspace.

```bash
# Step 1: Extract the zip to get the tarball
unzip RTK0EF0189F06000SJ_linux-src.zip
# This creates: rzv2n_ai-sdk_yocto_recipe_v6.00.tar.gz

# Step 2: Extract tarball to /tmp/ to avoid polluting workspace
cd /tmp
tar -xzf /path/to/rzv2n_ai-sdk_yocto_recipe_v6.00.tar.gz

# Step 3: Copy ONLY meta-rz-features directory to your workspace
cp -r /tmp/meta-rz-features <your-yocto-workspace>/

# Example:
# cp -r /tmp/meta-rz-features /home/root/work/renesas/rzv2n/yocto-rz/

# Step 4: Clean up temporary files
rm -rf /tmp/meta-arm /tmp/meta-openembedded /tmp/meta-renesas /tmp/poky \
       /tmp/patch /tmp/oss_pkg_rzv_v6.00.7z /tmp/meta-rz-features

# Step 5: Return to workspace
cd <your-yocto-workspace>
```

This provides:
- `meta-rz-graphics` - Mali GPU library
- `meta-rz-codecs` - Video codec and DRP library
- `meta-rz-drpai` - DRP-AI accelerator support
- `meta-rz-opencva` - OpenCV accelerator

### Enabling Optional Features

All commands below should be run from the `build/` directory.

#### Graphics (Mali GPU)

```bash
bitbake-layers add-layer ../meta-rz-features/meta-rz-graphics
```

Enables hardware-accelerated graphics rendering.

#### Video Codecs

```bash
bitbake-layers add-layer ../meta-rz-features/meta-rz-codecs
```

Enables hardware video encoding/decoding.

#### Qt6 Framework *(RZ/G2L | G2LC | G2UL | V2L only)*

> **Prerequisites:** Graphics layer + Codecs layer (G2L/V2L only)

```bash
bitbake-layers add-layer ../meta-qt6
bitbake-layers add-layer ../meta-rz-qt6
```

Then build Qt images:
```bash
MACHINE=rzg2lc-sr-som bitbake core-image-qt
# or
MACHINE=rzg2lc-sr-som bitbake solidrun-demo-image
```

#### Docker *(All Platforms)*

> **Note:** These layers may be required as dependencies for DRP-AI and other features on RZ/V2N.

```bash
bitbake-layers add-layer ../meta-openembedded/meta-networking
bitbake-layers add-layer ../meta-openembedded/meta-filesystems
bitbake-layers add-layer ../meta-virtualization
```

Enables Docker container support.

#### DRP-AI *(RZ/V2N only)*

```bash
bitbake-layers add-layer ../meta-rz-features/meta-rz-drpai
```

Enables AI acceleration hardware.

#### OpenCVA *(RZ/V2N only)*

```bash
bitbake-layers add-layer ../meta-rz-features/meta-rz-opencva
```

Enables OpenCV hardware acceleration.

#### ROS2 Humble *(RZ/V2N only)*

> **Prerequisites:** Graphics layer (meta-rz-graphics)

**1. Clone required repositories** (from top-level directory, not `build/`):

```bash
cd ..  # Go to top-level Yocto directory
git clone -b scarthgap https://github.com/ros/meta-ros.git
git clone https://github.com/renesas-rz/rzv2n_ros2.git
cp -r rzv2n_ros2/meta-rz-features-ros/meta-rzv2-ros-humble .
```

**2. Enable ROS2 configuration** in `build/conf/local.conf`:

```bash
echo "include conf/ros2.inc" >> conf/local.conf
```

The `ros2.inc` file (from `meta-rzv2n/conf/ros2.inc`) configures:
- ROS2 package list
- Mali GPU provider preferences
- Build fixes for missing dependencies
- Network access for package downloads (`BB_NO_NETWORK = "0"`)

**3. Add ROS2 layers:**

```bash
cd build  # Return to build directory
bitbake-layers add-layer ../meta-ros/meta-ros-common
bitbake-layers add-layer ../meta-ros/meta-ros2
bitbake-layers add-layer ../meta-ros/meta-ros2-humble
bitbake-layers add-layer ../meta-rzv2-ros-humble
```

**4. (Optional) Handle librealsense2 warning:**

If not using Intel RealSense camera, add to `conf/local.conf`:
```bash
BB_DANGLINGAPPENDS_WARNONLY = "1"
```

**5. Build image with ROS2:**

```bash
MACHINE=rzv2n-sr-som bitbake core-image-weston
```

**Testing ROS2:**

After booting, verify with talker/listener demo:

**Terminal 1:**
```bash
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_cpp talker
```

**Terminal 2:**
```bash
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_py listener
```

Useful commands:
```bash
ros2 topic list          # List active topics
ros2 node list           # List active nodes
ros2 topic echo /chatter # Monitor topic messages
```

### Graphics and Weston Configuration

The `core-image-weston` target includes Weston compositor with DRM backend:

- **With Mali GPU:** Uses GL renderer (hardware-accelerated)
- **Without Mali GPU:** Uses pixman software renderer

For software rendering, add to `/etc/xdg/weston/weston.ini` on target:

```ini
[core]
backend=drm
use-pixman=true
```

**Verify GPU acceleration:**
```bash
dmesg | grep -i mali     # Should show "Probed as mali0"
lsmod | grep mali        # Should show mali_kbase loaded
weston-simple-egl        # Should report ~60 FPS
```

### Device Tree Overlays (RZ/V2N)

Optional hardware can be enabled via device tree overlays. After flashing the SD card, mount the boot partition and edit `/boot/extlinux/extlinux.conf`:

```
label linux
  kernel ../Image
  devicetree ../renesas/r9a09g056n48-hummingboard-iiot.dtb
  fdtoverlays ../renesas/rzv2n-hummingboard-iiot-panel-dsi-WJ70N3TYJHMNG0.dtbo ../renesas/rzv2n-hummingboard-iiot-csi-camera-imx678.dtbo
  append root=/dev/mmcblk0p2 rootwait
```

**Available overlays:**
- `rzv2n-hummingboard-iiot-panel-dsi-WJ70N3TYJHMNG0.dtbo` - Winstar 7" DSI display panel
- `rzv2n-hummingboard-iiot-csi-camera-imx678.dtbo` - Sony IMX678 MIPI-CSI camera

Include only the overlays for your connected hardware.

### U-Boot Environment Storage

**RZ/G2L | G2LC | G2UL | V2L:**
U-Boot stores environment in SD/eMMC by default.

**RZ/V2N:**
U-Boot stores environment in **SPI flash** by default at offset `0x001E0000` (`CONFIG_ENV_IS_IN_SPI_FLASH=y`).

**For eMMC boot on RZ/V2N**, create a config fragment:

**File:** `meta-rzv2n/recipes-bsp/u-boot/u-boot-renesas/emmc-env.cfg`
```
# Use eMMC for U-Boot environment instead of SPI flash
# CONFIG_ENV_IS_IN_SPI_FLASH is not set
CONFIG_ENV_IS_IN_MMC=y
CONFIG_SYS_MMC_ENV_DEV=0
CONFIG_SYS_MMC_ENV_PART=1
```

**File:** `meta-rzv2n/recipes-bsp/u-boot/u-boot-renesas_%.bbappend`
```
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://emmc-env.cfg"
```

### Build Configuration Options

#### Disable GPLv3 Packages

To exclude GPLv3-licensed packages, add to `conf/local.conf`:

```bash
INCOMPATIBLE_LICENSE = "GPLv3 GPLv3+"
```

Affected recipes will downgrade to older versions with alternative licenses (via meta-gplv2).

---

## Known Issues & Troubleshooting

### QT Layer Disables Crypto Optimizations *(RZ/G2L | G2LC | G2UL | V2L)*

**Symptom:** After enabling `meta-rz-qt6`, ARM crypto instructions are disabled.

```bash
# Expected:
TUNE_FEATURES = "aarch64 crypto cortexa55"
# Actual:
TUNE_FEATURES = "aarch64  cortexa55"
```

**Fix:** Remove or comment out in `meta-rz-qt6/conf/layer.conf`:

```bash
# Remove crypto feature because some boards lack cryptographic hardware support
TUNE_FEATURES:remove = "crypto"
```

### Build Failures with GCC 15+ on Host System

**Symptom:** Multiple `*-native` recipes fail (unzip-native, m4-native, pkgconfig-native, cmake-native, etc.)

**Root Cause:** GCC 15 compatibility issues in Yocto 5.0.8

**Solution 1 - Apply patches** (22 commits to poky, 2 to meta-openembedded):

See the detailed patch list in the original README or upgrade to Yocto 5.0.13.

**Solution 2 - Upgrade Yocto** (recommended):

```bash
cd poky
git reset --hard yocto-5.0.13
cd ..
```

### Weston Won't Start

**Check:**
1. Is the graphics layer enabled? `bitbake-layers show-layers | grep rz-graphics`
2. Is Mali GPU detected? `dmesg | grep -i mali`
3. Try software rendering (see [Graphics and Weston Configuration](#graphics-and-weston-configuration))

### Build Takes Too Long / Out of Disk Space

**Speed up builds** - edit `conf/local.conf`:
```bash
BB_NUMBER_THREADS ?= "${@oe.utils.cpu_count()}"
PARALLEL_MAKE ?= "-j ${@oe.utils.cpu_count()}"
```

**Check disk space:**
```bash
df -h .
# Need minimum 150GB free
```

**Clean old builds:**
```bash
bitbake -c cleansstate <image-name>
```

---

## Contributing

To contribute to this layer, please email patches to **support@solid-run.com**.

Send `.patch` files as email attachments.

---

## Additional Resources

- [SolidRun RZ Documentation](https://solidrun.atlassian.net/wiki/spaces/developer/pages/286654475/)
- [Renesas RZ/G Linux Documentation](https://renesas-rz.github.io/)
- [Yocto Project Documentation](https://docs.yoctoproject.org/)
