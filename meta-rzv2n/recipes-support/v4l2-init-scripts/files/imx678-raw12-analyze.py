#!/usr/bin/env python3
"""
Analyze an IMX678/RZ-V2N CRU raw capture to quantify the "RAW12 truncated to
~55% per line" issue (Renesas ticket MPU-4592).

It slices the frame into `height` lines of `assumed_bpp*width` bytes (the stride
the driver programmed) and reports, per line, the column where real data ends
(last non-near-zero sample). If the CRU actually wrote MIPI-packed RAW12
(1.5 B/px) into a 2 B/px stride, valid data ends at ~0.75*width; other stride
mismatches shift that point. A consistent fill ratio well below 1.0 across all
lines == per-line truncation (horizontal), not a bottom-cropped frame.

Usage:
  imx678-raw12-analyze.py FRAME.raw WIDTH HEIGHT [--assumed-bpp 2] [--frames N]

No numpy dependency (stdlib only), so it also runs on a minimal target.
"""
import sys
import argparse


def analyze_frame(buf, width, height, bpp):
    stride = width * bpp
    if len(buf) < stride * height:
        print(f"  WARNING: frame is {len(buf)} bytes, "
              f"expected >= {stride*height} for {width}x{height}x{bpp}")
    # threshold: treat samples <=2 (of 0..255 on the high byte) as "empty"
    fills = []
    sample_lines = list(range(0, height, max(1, height // 16)))  # ~16 probes
    for y in sample_lines:
        base = y * stride
        line = buf[base:base + stride]
        if not line:
            break
        last = 0
        # scan from the end for first non-empty byte
        for i in range(len(line) - 1, -1, -1):
            if line[i] > 2:
                last = i + 1
                break
        col = last / bpp
        fills.append((y, last, col, col / width if width else 0))
    return stride, fills


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("frame")
    ap.add_argument("width", type=int)
    ap.add_argument("height", type=int)
    ap.add_argument("--assumed-bpp", type=int, default=2,
                    help="bytes/pixel the driver used for stride (RG12=2, RGGB=1)")
    ap.add_argument("--frames", type=int, default=1)
    args = ap.parse_args()

    with open(args.frame, "rb") as f:
        data = f.read()

    frame_sz = args.width * args.height * args.assumed_bpp
    nframes = max(1, len(data) // frame_sz) if frame_sz else 1
    print(f"file={args.frame} size={len(data)} "
          f"assumed {args.width}x{args.height}x{args.assumed_bpp} "
          f"=> {frame_sz} B/frame, {nframes} frame(s)")

    buf = data[:frame_sz]
    stride, fills = analyze_frame(buf, args.width, args.height, args.assumed_bpp)
    print(f"stride={stride} B/line ({args.assumed_bpp} B/px)")
    print(f"{'line':>6} {'last_byte':>10} {'~last_col':>10} {'fill%':>7}")
    ratios = []
    for y, last, col, ratio in fills:
        ratios.append(ratio)
        print(f"{y:>6} {last:>10} {col:>10.0f} {ratio*100:>6.1f}%")

    if ratios:
        avg = sum(ratios) / len(ratios)
        print(f"\naverage per-line fill: {avg*100:.1f}% of width")
        # interpret
        packed_ratio = 1.5 / args.assumed_bpp  # e.g. 0.75 if stride assumed 2 B/px
        print(f"expected fill if CRU wrote MIPI-packed 1.5 B/px into "
              f"{args.assumed_bpp} B/px stride: {packed_ratio*100:.0f}%")
        if avg < 0.9:
            print("=> PER-LINE TRUNCATION confirmed (data ends well before line end).")
            if abs(avg - packed_ratio) < 0.08:
                print("   Consistent with packed-vs-stride mismatch: set "
                      "bytesperline = width*3/2 (packed) OR make CRU unpack to "
                      "12-in-16.")
            else:
                print(f"   Fill {avg*100:.0f}% != packed {packed_ratio*100:.0f}%; "
                      "check CSI-2 word count / ICnMC.INF datatype and AMnIS "
                      "8-bit stride overflow (bytesperline/128 must be <=255).")
        else:
            print("=> lines look full; truncation may be vertical (missing rows) "
                  "or already fixed.")


if __name__ == "__main__":
    main()
