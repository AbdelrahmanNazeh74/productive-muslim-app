// ignore_for_file: avoid_print
// Converts the notification SVG sources into white PNG drawables for Android.
//
// Input  : assets/notifications/*.svg
// Output : android/app/src/main/res/drawable/<name>.png  (96 × 96 dp baseline)
//
// Run from the project root:
//   dart run tool/generate_notification_icons.dart
//
// Requires: image: ^4.1.0  in dev_dependencies (already in pubspec.yaml).
//
// The output PNGs are white-on-transparent (notification icon standard).
// Also written to four Android density buckets:
//   drawable-mdpi   48×48
//   drawable-hdpi   72×72
//   drawable-xhdpi  96×96  (baseline)
//   drawable-xxhdpi 144×144
//
// Note: each icon is drawn programmatically using image package primitives
// to match the SVG design in assets/notifications/. For pixel-perfect SVG
// rendering use Inkscape CLI:
//   inkscape assets/notifications/prayer_icon.svg --export-png=... -w 96 -h 96

import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

// ── Icon definitions ──────────────────────────────────────────────────────────

typedef _DrawFn = void Function(img.Image image, img.Color white);

const _icons = <String, _DrawFn>{
  'ic_notification_prayer': _drawPrayer,
  'ic_notification_quran': _drawQuran,
  'ic_notification_habit': _drawHabit,
  'ic_notification_fasting': _drawFasting,
  'ic_notification_general': _drawGeneral,
};

// Density buckets: name → pixel size
const _densities = <String, int>{
  'drawable-mdpi': 48,
  'drawable-hdpi': 72,
  'drawable-xhdpi': 96,
  'drawable-xxhdpi': 144,
};

// ── Entry point ───────────────────────────────────────────────────────────────

void main() async {
  print('Productive Muslim — Notification Icon Generator');
  print('================================================');

  const baseDir = 'android/app/src/main/res';

  for (final entry in _icons.entries) {
    final name = entry.key;
    final drawFn = entry.value;

    for (final density in _densities.entries) {
      final size = density.value;
      final outDir = '$baseDir/${density.key}';
      final outPath = '$outDir/$name.png';

      final image = img.Image(width: size, height: size, numChannels: 4);
      img.fill(image, color: img.ColorRgba8(0, 0, 0, 0)); // transparent bg

      final white = img.ColorRgba8(255, 255, 255, 255);
      drawFn(image, white);

      final file = File(outPath);
      await file.create(recursive: true);
      await file.writeAsBytes(img.encodePng(image));
      print('  ✓ $outPath  ($size×$size)');
    }
  }

  print('');
  print('Done. ${_icons.length * _densities.length} files written.');
  print('');
  print('Next: set android:icon="@drawable/ic_notification_prayer" (or other)');
  print('in AndroidManifest.xml <application> android:icon attribute, OR');
  print('reference per-channel in notification channels if desired.');
}

// ── Drawing helpers ───────────────────────────────────────────────────────────

int _si(img.Image i, double f) => (i.width * f).round();

/// Prayer icon: person in sujood silhouette.
void _drawPrayer(img.Image image, img.Color white) {
  // Head circle
  img.fillCircle(image,
      x: _si(image, 0.14), y: _si(image, 0.67), radius: _si(image, 0.09),
      color: white);
  // Back line: series of filled circles simulating a thick stroke
  _drawThickLine(image, white,
      _si(image, 0.24), _si(image, 0.67),
      _si(image, 0.71), _si(image, 0.42), _si(image, 0.07));
  // Upper leg: hip to knee
  _drawThickLine(image, white,
      _si(image, 0.71), _si(image, 0.42),
      _si(image, 0.75), _si(image, 0.65), _si(image, 0.07));
  // Lower leg
  _drawThickLine(image, white,
      _si(image, 0.75), _si(image, 0.65),
      _si(image, 0.85), _si(image, 0.82), _si(image, 0.07));
  // Mat line
  _drawThickLine(image, white,
      _si(image, 0.06), _si(image, 0.81),
      _si(image, 0.94), _si(image, 0.81), _si(image, 0.04));
}

/// Quran icon: open book outline with page lines.
void _drawQuran(img.Image image, img.Color white) {
  final thick = math.max(2, _si(image, 0.04));
  // Spine
  _drawThickLine(image, white,
      _si(image, 0.50), _si(image, 0.17),
      _si(image, 0.50), _si(image, 0.79), thick + 1);
  // Left page outline (4 lines)
  _drawThickLine(image, white, _si(image, 0.50), _si(image, 0.17),
      _si(image, 0.10), _si(image, 0.19), thick);
  _drawThickLine(image, white, _si(image, 0.10), _si(image, 0.19),
      _si(image, 0.10), _si(image, 0.77), thick);
  _drawThickLine(image, white, _si(image, 0.10), _si(image, 0.77),
      _si(image, 0.50), _si(image, 0.79), thick);
  // Right page outline (3 lines — shares spine)
  _drawThickLine(image, white, _si(image, 0.50), _si(image, 0.17),
      _si(image, 0.90), _si(image, 0.19), thick);
  _drawThickLine(image, white, _si(image, 0.90), _si(image, 0.19),
      _si(image, 0.90), _si(image, 0.77), thick);
  _drawThickLine(image, white, _si(image, 0.90), _si(image, 0.77),
      _si(image, 0.50), _si(image, 0.79), thick);
  // Text lines (left)
  final lw = math.max(1, _si(image, 0.02));
  for (final yFrac in [0.35, 0.45, 0.55, 0.64]) {
    _drawThickLine(image, img.ColorRgba8(255, 255, 255, 180),
        _si(image, 0.18), _si(image, yFrac),
        _si(image, 0.44), _si(image, yFrac), lw);
  }
  // Text lines (right)
  for (final yFrac in [0.35, 0.45, 0.55, 0.64]) {
    _drawThickLine(image, img.ColorRgba8(255, 255, 255, 180),
        _si(image, 0.56), _si(image, yFrac),
        _si(image, 0.82), _si(image, yFrac), lw);
  }
}

/// Habit icon: bold checkmark inside a circle.
void _drawHabit(img.Image image, img.Color white) {
  final thick = math.max(3, _si(image, 0.07));
  // Ring
  _drawCircleOutline(image, white, _si(image, 0.50), _si(image, 0.50),
      _si(image, 0.40), math.max(2, _si(image, 0.05)));
  // Check mark
  _drawThickLine(image, white, _si(image, 0.25), _si(image, 0.50),
      _si(image, 0.40), _si(image, 0.66), thick);
  _drawThickLine(image, white, _si(image, 0.40), _si(image, 0.66),
      _si(image, 0.75), _si(image, 0.32), thick);
}

/// Fasting icon: crescent moon + sun rays.
void _drawFasting(img.Image image, img.Color white) {
  final cr = _si(image, 0.36);  // outer crescent radius
  final cx = _si(image, 0.44);
  final cy = _si(image, 0.58);
  // Draw crescent via outer fill then inner carve
  img.fillCircle(image, x: cx, y: cy, radius: cr, color: white);
  img.fillCircle(image,
      x: cx + _si(image, 0.13), y: cy - _si(image, 0.08),
      radius: _si(image, 0.28),
      color: img.ColorRgba8(0, 0, 0, 0));
  // Sun
  final sr = _si(image, 0.08);
  final scx = _si(image, 0.79);
  final scy = _si(image, 0.21);
  img.fillCircle(image, x: scx, y: scy, radius: sr, color: white);
  // Rays (8)
  final rayLen = _si(image, 0.09);
  final gap = _si(image, 0.04);
  for (int i = 0; i < 8; i++) {
    final a = i * math.pi / 4;
    final rx1 = (scx + (sr + gap) * math.cos(a)).round();
    final ry1 = (scy + (sr + gap) * math.sin(a)).round();
    final rx2 = (scx + (sr + gap + rayLen) * math.cos(a)).round();
    final ry2 = (scy + (sr + gap + rayLen) * math.sin(a)).round();
    _drawThickLine(image, white, rx1, ry1, rx2, ry2,
        math.max(1, _si(image, 0.025)));
  }
}

/// General icon: clock face with crescent badge.
void _drawGeneral(img.Image image, img.Color white) {
  final thick = math.max(2, _si(image, 0.05));
  final cx = _si(image, 0.50);
  final cy = _si(image, 0.56);
  final r = _si(image, 0.36);
  // Clock ring
  _drawCircleOutline(image, white, cx, cy, r, thick);
  // 12 o'clock tick
  _drawThickLine(image, white, cx, cy - r, cx, cy - r + _si(image, 0.07),
      math.max(2, _si(image, 0.04)));
  // Hour hand (~10:10 style — up-left)
  _drawThickLine(image, white, cx, cy,
      cx - _si(image, 0.17), cy - _si(image, 0.18),
      math.max(2, _si(image, 0.045)));
  // Minute hand (right)
  _drawThickLine(image, white, cx, cy,
      cx + _si(image, 0.18), cy - _si(image, 0.05),
      math.max(2, _si(image, 0.03)));
  // Centre dot
  img.fillCircle(image, x: cx, y: cy, radius: _si(image, 0.04), color: white);
  // Small crescent badge top-right
  final bcx = _si(image, 0.79);
  final bcy = _si(image, 0.18);
  final bcr = _si(image, 0.14);
  img.fillCircle(image, x: bcx, y: bcy, radius: bcr, color: white);
  img.fillCircle(image,
      x: bcx + _si(image, 0.07), y: bcy - _si(image, 0.03),
      radius: _si(image, 0.11),
      color: img.ColorRgba8(0, 0, 0, 0));
}

// ── Primitive drawing helpers ─────────────────────────────────────────────────

/// Draws a thick line by stamping filled circles along the path (Bresenham).
void _drawThickLine(img.Image image, img.Color color,
    int x0, int y0, int x1, int y1, int thickness) {
  final r = (thickness / 2).ceil();
  int dx = (x1 - x0).abs();
  int dy = -(y1 - y0).abs();
  int sx = x0 < x1 ? 1 : -1;
  int sy = y0 < y1 ? 1 : -1;
  int err = dx + dy;
  int cx = x0;
  int cy = y0;
  while (true) {
    img.fillCircle(image, x: cx, y: cy, radius: r, color: color);
    if (cx == x1 && cy == y1) break;
    final e2 = 2 * err;
    if (e2 >= dy) {
      err += dy;
      cx += sx;
    }
    if (e2 <= dx) {
      err += dx;
      cy += sy;
    }
  }
}

/// Draws a circle outline by iterating angles.
void _drawCircleOutline(
    img.Image image, img.Color color, int cx, int cy, int r, int thickness) {
  final halfT = (thickness / 2).ceil();
  const steps = 360;
  for (int i = 0; i < steps; i++) {
    final a = i * 2 * math.pi / steps;
    final px = (cx + r * math.cos(a)).round();
    final py = (cy + r * math.sin(a)).round();
    img.fillCircle(image, x: px, y: py, radius: halfT, color: color);
  }
}
