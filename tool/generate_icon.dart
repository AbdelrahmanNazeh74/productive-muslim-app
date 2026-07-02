// ignore_for_file: avoid_print
// Generates app icon PNGs for flutter_launcher_icons.
//
// Produces two files:
//   assets/icon/icon.png            — 1024×1024, green background (full icon)
//   assets/icon/icon_foreground.png — 1024×1024, transparent background (adaptive foreground)
//
// Run from the project root:
//   dart run tool/generate_icon.dart
//
// Requires:  image: ^4.1.0  in dev_dependencies (already in pubspec.yaml).
//
// After this script completes:
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
//
// Design (matches assets/icon/icon.svg):
//   - 8-pointed star (rub el hizb): two overlapping squares rotated 45° apart
//   - Crescent moon integrated upper-right
//   - "PM" is NOT drawn here (image package bitmap fonts are too pixelated);
//     add it in a design tool or use scripts/generate_icons.py (Pillow-based).

import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

void main() async {
  print('Productive Muslim — Icon Generator');
  print('====================================');

  // Full icon: green background
  await _generateIcon(
    outPath: 'assets/icon/icon.png',
    transparent: false,
  );

  // Adaptive foreground: transparent background
  await _generateIcon(
    outPath: 'assets/icon/icon_foreground.png',
    transparent: true,
  );

  print('');
  print('Next steps:');
  print('  dart run flutter_launcher_icons');
  print('  dart run flutter_native_splash:create');
  print('');
  print('Note: "PM" wordmark is defined in assets/icon/icon.svg.');
  print('For production quality, add the text via scripts/generate_icons.py');
  print('(requires: pip install Pillow) or a vector design tool.');
}

Future<void> _generateIcon({
  required String outPath,
  required bool transparent,
}) async {
  const size = 1024;

  // Always 4-channel RGBA so transparency works correctly.
  final image = img.Image(width: size, height: size, numChannels: 4);

  final bg = transparent
      ? img.ColorRgba8(0, 0, 0, 0)
      : img.ColorRgba8(0x1B, 0x6B, 0x3A, 255);

  img.fill(image, color: bg);

  final white = img.ColorRgba8(255, 255, 255, 255);

  // ── 8-pointed star ─────────────────────────────────────────────────────────
  // Two overlapping rotated squares (half-diagonal d = 290px from star centre).
  // Together they form the classic Islamic rub el hizb / 8-pointed star.
  const cx = 512;
  const cy = 560; // shifted down slightly so crescent fits above
  const d = 290.0;

  for (final baseAngle in [math.pi / 4, 0.0]) {
    final verts = List.generate(4, (i) {
      final a = baseAngle + i * (math.pi / 2);
      return img.Point(
        (cx + d * math.cos(a)).round(),
        (cy + d * math.sin(a)).round(),
      );
    });
    img.fillPolygon(image, vertices: verts, color: white);
  }

  // ── Crescent moon (upper-centre-right area) ────────────────────────────────
  // Outer white circle, then carve a slightly-offset inner circle.
  const cCx = 640;
  const cCy = 210;
  const outerR = 96;
  const innerR = 76;
  const innerDx = 28; // inner circle offset right
  const innerDy = -14; // inner circle offset up  → crescent opens left

  img.fillCircle(image, x: cCx, y: cCy, radius: outerR, color: white);

  // Carve crescent: overwrite inner area with background colour.
  // For transparent mode this sets pixels to (0,0,0,0), effectively erasing.
  img.fillCircle(
    image,
    x: cCx + innerDx,
    y: cCy + innerDy,
    radius: innerR,
    color: transparent ? img.ColorRgba8(0, 0, 0, 0) : bg,
  );

  // ── Save ───────────────────────────────────────────────────────────────────
  final file = File(outPath);
  await file.create(recursive: true);
  await file.writeAsBytes(img.encodePng(image));
  print('✓ $outPath  ($size×$size)');
}
