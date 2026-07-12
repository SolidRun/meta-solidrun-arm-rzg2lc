#!/usr/bin/env python3
# RZ/V2N CRU packed RAW12 -> BMP. Unpacks MIPI-packed RAW12 (2 pixels / 3 bytes)
# and demosaics to RGB. Works for any Bayer order via --bayer.
#
# IMX678 is RGGB (default); Renesas' IMX415 reference is BGGR (--bayer bggr).
# A packed 3840x2160 frame is exactly 3840*2160*3/2 = 12441600 bytes; with the
# CRU packed-bytesperline kernel fix, bpl auto-detects as filesize/height.
import argparse
import numpy as np
from PIL import Image


def unpack_raw12_2pix3bytes(packed_u8: np.ndarray) -> np.ndarray:
    """CSI-2 RAW12 packing: byte0=P0[11:4], byte1=P1[11:4], byte2=(P1[3:0]<<4)|P0[3:0]."""
    trip = packed_u8.reshape(-1, 3).astype(np.uint16)
    b0, b1, b2 = trip[:, 0], trip[:, 1], trip[:, 2]
    p0 = (b0 << 4) | (b2 & 0x0F)
    p1 = (b1 << 4) | (b2 >> 4)
    out = np.empty(p0.size * 2, dtype=np.uint16)
    out[0::2] = p0
    out[1::2] = p1
    return out


def demosaic_bilinear(bayer12: np.ndarray, order: str) -> np.ndarray:
    """Bilinear demosaic for an arbitrary 2x2 Bayer order -> RGB uint8.
    order is one of rggb, bggr, grbg, gbrg (top-left..bottom-right)."""
    b = bayer12.astype(np.float32)
    R = np.zeros_like(b)
    G = np.zeros_like(b)
    B = np.zeros_like(b)
    # positions of the 4 mosaic cells: (row%2, col%2)
    cells = {(0, 0): order[0], (0, 1): order[1], (1, 0): order[2], (1, 1): order[3]}
    chan = {"r": R, "g": G, "b": B}
    for (ry, cx), c in cells.items():
        chan[c][ry::2, cx::2] = b[ry::2, cx::2]

    def interp_hv(c):
        p = np.pad(c, ((1, 1), (1, 1)), mode="edge")
        return (p[0:-2, 1:-1] + p[2:, 1:-1] + p[1:-1, 0:-2] + p[1:-1, 2:]) / 4.0

    for _ in range(2):
        R = np.where(R == 0, interp_hv(R), R)
        G = np.where(G == 0, interp_hv(G), G)
        B = np.where(B == 0, interp_hv(B), B)
    rgb = np.stack([R, G, B], axis=-1)
    return np.clip(rgb * 255.0 / 4095.0, 0, 255).astype(np.uint8)


def main():
    ap = argparse.ArgumentParser(description="Debayer RZ/V2N packed RAW12 (2px/3B) -> BMP.")
    ap.add_argument("infile")
    ap.add_argument("--width", type=int, default=3840)
    ap.add_argument("--height", type=int, default=2160)
    ap.add_argument("--bayer", choices=["rggb", "bggr", "grbg", "gbrg"], default="rggb",
                    help="Bayer order (IMX678=rggb, IMX415=bggr).")
    ap.add_argument("--bpl", type=int, default=0, help="Bytes/line (0 = auto = filesize/height).")
    ap.add_argument("--offset", type=int, default=0)
    ap.add_argument("--outfile", default="out.bmp")
    args = ap.parse_args()

    with open(args.infile, "rb") as f:
        f.seek(0, 2)
        fsize = f.tell()
        f.seek(0)
        raw = np.frombuffer(f.read(), dtype=np.uint8)

    if args.bpl == 0:
        if fsize % args.height != 0:
            raise ValueError(f"Auto-BPL failed: {fsize} not divisible by height {args.height}; "
                             "pass --bpl (CRU pads bpl to a 128-byte multiple).")
        args.bpl = fsize // args.height
    if fsize < args.offset + args.bpl * args.height:
        raise ValueError(f"File too small: {fsize} < {args.offset + args.bpl*args.height}.")

    print(f"width={args.width} height={args.height} bayer={args.bayer} bpl={args.bpl} filesize={fsize}")
    buf = raw[args.offset:args.offset + args.bpl * args.height].reshape(args.height, args.bpl)
    payload_bpl = args.width * 3 // 2
    if payload_bpl > args.bpl:
        raise ValueError(f"payload_bpl {payload_bpl} > bpl {args.bpl}: wrong width/bpl.")

    bayer = np.zeros((args.height, args.width), dtype=np.uint16)
    for y in range(args.height):
        line = buf[y, :payload_bpl]
        line = line[: (line.size // 3) * 3]
        bayer[y, :] = unpack_raw12_2pix3bytes(line)[:args.width]

    Image.fromarray(demosaic_bilinear(bayer, args.bayer), mode="RGB").save(args.outfile, format="BMP")
    print(f"Wrote {args.outfile}")


if __name__ == "__main__":
    main()
