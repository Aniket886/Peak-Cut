"""Draws the PeakCut mark (same shapes as web/brand/favicon.svg) into launcher/peakcut.ico.
Run with:  python launcher/make_icon.py   (needs Pillow, which PeakCut already uses)"""
from pathlib import Path

from PIL import Image, ImageDraw

S = 220 * 4                      # drawn 4x larger, then shrunk, so the edges are smooth
BLUE, WHITE = (47, 128, 237, 255), (255, 255, 255, 255)


def p(x, y):
    return (x * 4, y * 4)


def mark():
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((0, 0, S - 1, S - 1), radius=56 * 4, fill=BLUE)
    tri = [p(36, 166), p(110, 50), p(184, 166)]
    d.polygon(tri, fill=WHITE)
    for a, b in zip(tri, tri[1:] + tri[:1]):          # the 8-wide rounded outline
        d.line([a, b], fill=WHITE, width=8 * 4)
    for x, y in tri:
        d.ellipse((x - 16, y - 16, x + 16, y + 16), fill=WHITE)
    d.line([p(132, 34), p(90, 186)], fill=BLUE, width=13 * 4)   # the cut
    # keep the cut inside the rounded square
    mask = Image.new("L", (S, S), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, S - 1, S - 1), radius=56 * 4, fill=255)
    img.putalpha(Image.composite(img.getchannel("A"), Image.new("L", (S, S), 0), mask))
    return img


if __name__ == "__main__":
    out = Path(__file__).with_name("peakcut.ico")
    big = mark().resize((256, 256), Image.LANCZOS)
    big.save(out, format="ICO", sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
    print("wrote", out)
