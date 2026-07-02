#!/usr/bin/env python3
"""
generate_icons.py — Productive Muslim app icon generator
=========================================================
Generates three PNG assets required by flutter_launcher_icons and
flutter_native_splash:

  assets/icons/app_icon.png            1024×1024  full icon (green bg + star + PM)
  assets/icons/app_icon_foreground.png 1024×1024  adaptive foreground (transparent bg)
  assets/icons/splash_logo.png          512×512   native splash centre logo

Prerequisites:
  pip install Pillow

Usage:
  cd <project-root>
  python scripts/generate_icons.py

After running:
  dart run flutter_launcher_icons
  dart run flutter_native_splash:create
"""

import math
import sys
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("❌  Pillow not found. Run:  pip install Pillow")
    sys.exit(1)

# ── Brand colours ─────────────────────────────────────────────────────────────
GREEN  = (27, 107, 58)      # #1B6B3A  Islamic green (primary)
GOLD   = (201, 168, 76)     # #C9A84C  accent gold
WHITE  = (255, 255, 255)
TRANSP = (0, 0, 0, 0)

OUT = Path("assets/icons")
OUT.mkdir(parents=True, exist_ok=True)

# ── Helper: draw 8-pointed star (octagram) ────────────────────────────────────

def octagram_points(cx: float, cy: float, R: float, r: float, offset: float = 0.0):
    """Return flat list of (x, y) tuples for an 8-pointed star.

    R = outer tip radius, r = inner concave radius, offset = rotation in radians.
    """
    pts = []
    for i in range(8):
        outer = offset + math.pi * i / 4
        inner = outer + math.pi / 8
        pts.append((cx + R * math.cos(outer), cy + R * math.sin(outer)))
        pts.append((cx + r * math.cos(inner), cy + r * math.sin(inner)))
    return pts


def draw_star(draw: ImageDraw.Draw, cx, cy, R, r, fill, width=0):
    pts = octagram_points(cx, cy, R, r, offset=-math.pi / 2)
    draw.polygon(pts, fill=fill)


def draw_pm_text(draw: ImageDraw.Draw, cx, cy, size, fill):
    """Draw a bold 'PM' monogram centred at (cx, cy) using basic geometry."""
    # Letter height / width ratios — hand-drawn with rectangles so no font needed
    lh = int(size * 0.32)    # letter height
    lw = int(size * 0.14)    # stroke width
    gap = int(size * 0.04)   # gap between P and M
    tw = lw * 2 + gap        # total width of "PM" pair (simplified)

    # ── P ────────────────────────────────────────────────────────────────────
    px = int(cx - tw // 2 - lw // 2)
    py = int(cy - lh // 2)
    # Vertical bar
    draw.rectangle([px, py, px + lw, py + lh], fill=fill)
    # Top horizontal
    draw.rectangle([px, py, px + lw * 2, py + lw], fill=fill)
    # Middle horizontal
    draw.rectangle([px, py + lh // 2, px + lw * 2, py + lh // 2 + lw], fill=fill)
    # Right bar of bowl (top half only)
    draw.rectangle([px + lw, py, px + lw * 2, py + lh // 2 + lw], fill=fill)

    # ── M ────────────────────────────────────────────────────────────────────
    mx = px + lw * 2 + gap + lw
    my = py
    mw = lw * 2 + lw  # M is a bit wider
    # Left bar
    draw.rectangle([mx, my, mx + lw, my + lh], fill=fill)
    # Right bar
    draw.rectangle([mx + mw - lw, my, mx + mw, my + lh], fill=fill)
    # Left diagonal (approximated with rectangle)
    mid_x = mx + mw // 2
    mid_y = my + lh // 2
    draw.polygon([
        (mx, my), (mx + lw, my),
        (mid_x + lw // 2, mid_y),
        (mid_x - lw // 2, mid_y),
    ], fill=fill)
    draw.polygon([
        (mx + mw - lw, my), (mx + mw, my),
        (mid_x + lw // 2, mid_y),
        (mid_x - lw // 2, mid_y),
    ], fill=fill)


# ── 1. Full app icon (1024×1024) ──────────────────────────────────────────────

def make_icon(path: Path, size: int = 1024):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    cx, cy = size / 2, size / 2
    r_bg = size // 2

    # Round background
    draw.ellipse([0, 0, size - 1, size - 1], fill=GREEN + (255,))

    # Thin gold ring (decorative)
    ring_w = max(2, size // 80)
    draw.ellipse(
        [size * 0.08, size * 0.08, size * 0.92, size * 0.92],
        outline=GOLD + (180,), width=ring_w,
    )

    # 8-pointed star — white, large
    R_outer = size * 0.34
    R_inner = size * 0.21
    draw_star(draw, cx, cy - size * 0.04, R_outer, R_inner, WHITE + (255,))

    # Small gold inner star
    draw_star(draw, cx, cy - size * 0.04, R_outer * 0.35, R_inner * 0.35, GOLD + (230,))

    # "PM" monogram below the star
    draw_pm_text(draw, cx, cy + size * 0.32, size, WHITE + (255,))

    # Save as RGB (no alpha) since iOS doesn't allow transparent icons
    final = Image.new("RGB", (size, size), GREEN)
    final.paste(img, mask=img.split()[3])
    final.save(path, "PNG", optimize=True)
    print(f"✅  {path}  ({size}×{size})")


# ── 2. Adaptive foreground (1024×1024, transparent background) ───────────────

def make_foreground(path: Path, size: int = 1024):
    img = Image.new("RGBA", (size, size), TRANSP)
    draw = ImageDraw.Draw(img)

    cx, cy = size / 2, size / 2

    # Star in safe zone (≤66% of icon size for Android adaptive icons)
    R_outer = size * 0.28
    R_inner = size * 0.17
    draw_star(draw, cx, cy - size * 0.03, R_outer, R_inner, WHITE + (255,))
    draw_star(draw, cx, cy - size * 0.03, R_outer * 0.35, R_inner * 0.35, GOLD + (230,))

    draw_pm_text(draw, cx, cy + size * 0.27, size * 0.85, WHITE + (255,))

    img.save(path, "PNG", optimize=True)
    print(f"✅  {path}  ({size}×{size}, transparent)")


# ── 3. Splash logo (512×512, transparent background) ─────────────────────────

def make_splash_logo(path: Path, size: int = 512):
    img = Image.new("RGBA", (size, size), TRANSP)
    draw = ImageDraw.Draw(img)

    cx, cy = size / 2, size / 2
    R_outer = size * 0.36
    R_inner = size * 0.22
    draw_star(draw, cx, cy, R_outer, R_inner, WHITE + (255,))
    draw_star(draw, cx, cy, R_outer * 0.35, R_inner * 0.35, GOLD + (230,))

    img.save(path, "PNG", optimize=True)
    print(f"✅  {path}  ({size}×{size}, transparent)")


# ── Main ──────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    print("🎨  Generating Productive Muslim icons …\n")
    make_icon(OUT / "app_icon.png")
    make_foreground(OUT / "app_icon_foreground.png")
    make_splash_logo(OUT / "splash_logo.png")
    print("""
Done! Next steps:
  1. flutter pub get
  2. dart run flutter_launcher_icons
  3. dart run flutter_native_splash:create
  4. flutter run   (verify icons on device / emulator)
""")
