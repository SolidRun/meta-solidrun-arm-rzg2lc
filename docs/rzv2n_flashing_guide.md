# RZ/V2N SoM Firmware Flashing Guide

This guide covers all methods for programming the BL2 and FIP firmware on the SolidRun RZ/V2N SoM, for both SPI NOR flash and eMMC boot storage.

## Boot Mode Selection (DIP Switch S5)

Set the DIP switch S5 on the HummingBoard-iiot to select the boot source:

| Boot Mode | SW1 (MD0) | SW2 (MD1) | SW3 | SW4 | SW5 (3.3V) | SW6 (1.8V) |
|-----------|-----------|-----------|-----|-----|------------|------------|
| SPI NOR | OFF | ON | X | X | OFF | ON |
| eMMC | ON | OFF | X | X | OFF | ON |
| Serial Downloader | ON | ON | X | X | OFF | ON |

> **Note:** Serial Downloader mode (SCIF) is used with Method 1 below for initial programming or recovery.

## Build Artifacts

After a Yocto build, the firmware files are in `tmp/deploy/images/rzv2n-sr-som/`:

| File | Description |
|------|-------------|
| `bl2_bp_spi-rzv2n-sr-som.bin` / `.srec` | BL2 for SPI NOR boot |
| `bl2_bp_mmc-rzv2n-sr-som.bin` / `.srec` | BL2 for eMMC boot |
| `fip-rzv2n-sr-som.bin` / `.srec` | FIP (BL31 + U-Boot), same for both SPI and eMMC |
| `Flash_Writer_SCIF_RZV2N_SR_SOM_8GB_LPDDR4X.mot` | Flash Writer for serial download mode |

## Flash Layouts

### SPI NOR Flash (4 MB — ISSI IS25WP032)

| Region | Offset | Size | Description |
|--------|--------|------|-------------|
| BL2 | `0x000000` | 384 KB (`0x60000`) | TF-A BL2 + boot parameters |
| FIP | `0x060000` | 1536 KB (`0x180000`) | Firmware Image Package (BL31 + U-Boot) |
| env | `0x1E0000` | 128 KB (`0x20000`) | U-Boot environment |

### eMMC Boot Partition (mmcblk0boot0)

| Region | Sector | Byte Offset | Description |
|--------|--------|-------------|-------------|
| BL2 | `0x1` | `0x200` | TF-A BL2 + boot parameters |
| FIP | `0x300` | `0x60000` | Firmware Image Package (BL31 + U-Boot) |

---

## Method 1: Serial Flash Writer (SCIF Download Mode)

Use this method for initial board bring-up or recovery when U-Boot is not functional.

**Requirements:**
- Board set to SCIF download boot mode (boot mode switches)
- Serial connection to the board (default: `/dev/ttyUSB0`)
- Python 3 with `pyserial` and `tqdm`

The flash writer tool is available at:
https://github.com/SolidRun/rzg2_flash_writer/tree/rz_v2n/flash-tools

### SPI NOR

```bash
python3 flash_writer_tool.py --target spi \
    --fw Flash_Writer_SCIF_RZV2N_SR_SOM_8GB_LPDDR4X.mot \
    --bl2 bl2_bp_spi-rzv2n-sr-som.srec \
    --fip fip-rzv2n-sr-som.srec
```

### eMMC

```bash
python3 flash_writer_tool.py --target emmc \
    --fw Flash_Writer_SCIF_RZV2N_SR_SOM_8GB_LPDDR4X.mot \
    --bl2 bl2_bp_mmc-rzv2n-sr-som.bin \
    --fip fip-rzv2n-sr-som.bin
```

The eMMC target automatically configures the boot partition settings (BOOT_BUS_CONDITIONS and PARTITION_CONFIG) after programming.

> **Tip:** Use `--port /dev/ttyUSBx` to specify a different serial port, and `--speed 921600` (default) for faster transfer.

---

## Method 2: U-Boot CLI (via USB Drive)

Use this method when U-Boot is already running. Copy the `.bin` firmware files to a FAT-formatted USB drive.

### SPI NOR

```
usb start

# Flash BL2
fatload usb 0:1 0x48000000 bl2_bp_spi-rzv2n-sr-som.bin
sf probe
sf erase 0x0 0x60000
sf write 0x48000000 0x0 $filesize

# Flash FIP
fatload usb 0:1 0x48000000 fip-rzv2n-sr-som.bin
sf erase 0x60000 0x180000
sf write 0x48000000 0x60000 $filesize

# (Optional) Erase U-Boot environment to reset to defaults
sf erase 0x1E0000 0x20000

reset
```

### eMMC

```
usb start

# Switch to eMMC boot partition (boot0)
mmc dev 0 1

# Flash BL2
fatload usb 0:1 0x48000000 bl2_bp_mmc-rzv2n-sr-som.bin
setexpr blkcnt $filesize + 0x1ff
setexpr blkcnt $blkcnt / 0x200
mmc write 0x48000000 0x1 $blkcnt

# Flash FIP
fatload usb 0:1 0x48000000 fip-rzv2n-sr-som.bin
setexpr blkcnt $filesize + 0x1ff
setexpr blkcnt $blkcnt / 0x200
mmc write 0x48000000 0x300 $blkcnt

# Configure eMMC boot partition
mmc partconf 0 0 1 0

# Switch back to user data partition
mmc dev 0 0

reset
```

> **Note:** Plug the USB drive into the single USB Type-A port, not the dual-stacked USB port. If the USB drive is not detected on `usb start`, run `usb reset` and retry. The Cypress hub on HummingBoard may require a second scan to enumerate the device.

---

## Method 3: From Linux

Use this method to update firmware from a running Linux system.

### SPI NOR (via MTD)

Requires `CONFIG_MTD_PARTITIONED_MASTER=y` in the kernel configuration (enabled by default in the SolidRun kernel config). This exposes the full SPI flash as a master MTD device (`/dev/mtdblock0`), allowing writes at the correct offsets regardless of the device tree partition layout.

The `mtdblock` driver handles erase-before-write internally, so no separate `flash_erase` step is needed.

```bash
# Mount USB drive with firmware files
mount /dev/sda1 /mnt

# Flash BL2 at offset 0x0
dd if=/mnt/bl2_bp_spi-rzv2n-sr-som.bin of=/dev/mtdblock0

# Flash FIP at offset 0x60000
dd if=/mnt/fip-rzv2n-sr-som.bin of=/dev/mtdblock0 bs=4096 seek=96
```

To also reset the U-Boot environment to defaults:

```bash
# Erase U-Boot environment (requires mtd-utils)
flash_erase /dev/mtd0 0x1E0000 0x20000
```

> **Note:** The `seek=96` value is `0x60000 / 4096 = 96` blocks, positioning the FIP write at the correct flash offset on the master device.

### eMMC (via mmcblk0boot0)

The eMMC boot firmware is stored in the hardware boot partition (`mmcblk0boot0`), which is write-protected by default.

```bash
# Mount USB drive with firmware files
mount /dev/sda1 /mnt

# Unlock eMMC boot partition for writing
echo 0 > /sys/block/mmcblk0boot0/force_ro

# Flash BL2 at sector 1 (byte offset 0x200)
dd if=/mnt/bl2_bp_mmc-rzv2n-sr-som.bin of=/dev/mmcblk0boot0 bs=512 seek=1

# Flash FIP at sector 0x300 (byte offset 0x60000)
dd if=/mnt/fip-rzv2n-sr-som.bin of=/dev/mmcblk0boot0 bs=512 seek=768

# Re-lock eMMC boot partition
echo 1 > /sys/block/mmcblk0boot0/force_ro
```

> **Note:** `seek=768` is sector `0x300` in decimal. The eMMC boot partition must be unlocked before writing and should be re-locked afterwards to prevent accidental modification.

---

## Quick Reference

| What | SPI NOR Offset | eMMC boot0 Sector |
|------|---------------|-------------------|
| BL2 | `0x000000` | `0x1` |
| FIP | `0x060000` | `0x300` |
| env | `0x1E0000` | eMMC boot0 partition 1 (optional) |

### U-Boot Environment on eMMC

By default, U-Boot stores its environment on SPI NOR flash at offset `0x1E0000`. For eMMC-based systems, U-Boot can be built to store the environment on the eMMC boot partition instead. Add the following U-Boot config fragment:

```
# CONFIG_ENV_IS_IN_SPI_FLASH is not set
CONFIG_ENV_IS_IN_MMC=y
CONFIG_SYS_MMC_ENV_DEV=0
CONFIG_SYS_MMC_ENV_PART=1
```

See the [build instructions](rzv2n_README.md#u-boot-environment-storage) for the full Yocto recipe setup.
