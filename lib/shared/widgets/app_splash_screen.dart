import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/responsive.dart';
import '../theme/app_theme.dart';

/// Animated splash screen shown before the router resolves the first route.
///
/// Six-phase animation sequence:
///   Phase 1  0–600 ms   Islamic green background fades in
///   Phase 2  400–900 ms 8-pointed star draws itself (path animation)
///   Phase 3  700–1100ms "Productive Muslim" text slides up and fades in
///   Phase 4  900–1300ms Arabic subtitle "المسلم المنتج" fades in
///   Phase 5  1200–1600ms Tagline "Balance. Worship. Grow." fades in
///   Phase 6  ≥2500ms     Brief pause, then everything scales up + fades out
///             → navigates to [targetRoute]
///
/// Guarantees a minimum display time of 2.5 s via [Future.wait] even if
/// [appInitFuture] resolves instantly.  If [appInitFuture] throws, shows an
/// error state with a "Continue" button that navigates anyway.
///
/// Adapts to all screen sizes via [ResponsiveContext].
class AppSplashScreen extends StatefulWidget {
  final String targetRoute;

  /// Optional future that represents any async app-init work.
  /// Navigation is deferred until BOTH the minimum 2.5 s delay AND this
  /// future complete.  If null, only the minimum delay applies.
  final Future<void>? appInitFuture;

  const AppSplashScreen({
    super.key,
    required this.targetRoute,
    this.appInitFuture,
  });

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────────────────────

  late AnimationController _bgCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _exitCtrl;
  late AnimationController _patternCtrl;

  // ── Timers ───────────────────────────────────────────────────────────────────
  Timer? _contentTimer;
  Timer? _minDelayTimer;
  final Completer<void> _minDelayCompleter = Completer<void>();

  // ── Animations ───────────────────────────────────────────────────────────────

  late Animation<double> _bgFade;
  late Animation<double> _starDraw;
  late Animation<double> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _arabicFade;
  late Animation<double> _taglineFade;
  late Animation<double> _exitScale;
  late Animation<double> _exitFade;

  // ── State ────────────────────────────────────────────────────────────────────
  bool _hasError = false;

  static const _contentMs = 1200;
  static const _exitMs = 600;
  static const _minDisplayMs = 2500;

  @override
  void initState() {
    super.initState();

    // Background (0–600 ms)
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgCtrl, curve: Curves.easeIn),
    );

    // Content sequence
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _contentMs),
    );

    _starDraw = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.0, 0.42, curve: Curves.easeInOut),
      ),
    );
    _titleSlide = Tween<double>(begin: 22.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
      ),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.25, 0.67, curve: Curves.easeIn),
      ),
    );
    _arabicFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.50, 0.83, curve: Curves.easeIn),
      ),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.67, 1.0, curve: Curves.easeIn),
      ),
    );

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _exitMs),
    );
    _exitScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    _patternCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _bgCtrl.forward();
    _contentTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _contentCtrl.forward();
    });

    _scheduleExit();
  }

  /// Waits for the minimum display time and any app-init work, then
  /// plays the exit animation and navigates.  On error, shows a retry UI.
  Future<void> _scheduleExit() async {
    _minDelayTimer = Timer(
      const Duration(milliseconds: _minDisplayMs),
      () {
        if (!_minDelayCompleter.isCompleted) _minDelayCompleter.complete();
      },
    );
    try {
      if (widget.appInitFuture != null) {
        await Future.wait([_minDelayCompleter.future, widget.appInitFuture!]);
      } else {
        await _minDelayCompleter.future;
      }
      if (!mounted) return;
      await _exitCtrl.forward();
      if (mounted) context.go(widget.targetRoute);
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _contentTimer?.cancel();
    _minDelayTimer?.cancel();
    if (!_minDelayCompleter.isCompleted) _minDelayCompleter.complete();
    _bgCtrl.dispose();
    _contentCtrl.dispose();
    _exitCtrl.dispose();
    _patternCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return _buildErrorState(context);

    final isTablet = context.isTablet;
    final logoSize = isTablet ? 108.0 : 88.0;
    final titleSize = isTablet ? 34.0 : 28.0;
    final arabicSize = isTablet ? 26.0 : 21.0;
    final taglineSize = isTablet ? 14.0 : 12.0;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _bgCtrl, _contentCtrl, _exitCtrl, _patternCtrl,
      ]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          body: Opacity(
            opacity: _exitFade.value,
            child: Transform.scale(
              scale: _exitScale.value,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Phase 1: background fade-in
                  Opacity(
                    opacity: _bgFade.value,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(color: AppColors.primary),
                    ),
                  ),

                  // Background pattern (slow rotation, muted) — isolated in
                  // RepaintBoundary so the star animations don't repaint it.
                  Opacity(
                    opacity: _bgFade.value * 0.6,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _IslamicPatternPainter(
                          rotation: _patternCtrl.value * 2 * math.pi,
                        ),
                      ),
                    ),
                  ),

                  // Radial gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.85,
                        colors: [
                          Colors.transparent,
                          AppColors.primary.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),

                  // Phase 2–5: centre content
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Phase 2 — animated star icon
                        SizedBox(
                          width: logoSize,
                          height: logoSize,
                          child: RepaintBoundary(
                            child: CustomPaint(
                              painter: _StarDrawPainter(
                                progress: _starDraw.value,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 28.0 : 22.0),

                        // Phase 3 — "Productive Muslim"
                        Transform.translate(
                          offset: Offset(0, _titleSlide.value),
                          child: Opacity(
                            opacity: _titleFade.value,
                            child: Text(
                              'Productive Muslim',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Phase 4 — Arabic subtitle "المسلم المنتج"
                        Opacity(
                          opacity: _arabicFade.value,
                          child: Text(
                            'المسلم المنتج',
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.amiri(
                              fontSize: arabicSize,
                              fontWeight: FontWeight.w400,
                              color: AppColors.gold.withValues(alpha: 0.90),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Phase 5 — tagline
                        Opacity(
                          opacity: _taglineFade.value,
                          child: Text(
                            'Balance. Worship. Grow.',
                            style: GoogleFonts.inter(
                              fontSize: taglineSize,
                              fontWeight: FontWeight.w400,
                              color: AppColors.gold.withValues(alpha: 0.75),
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: Colors.white, size: 52),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The app will continue in offline mode',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (mounted) context.go(widget.targetRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated star draw painter ────────────────────────────────────────────────

/// Draws an 8-pointed star that "strokes itself in" as [progress] goes 0→1,
/// then fills completely at progress == 1.
class _StarDrawPainter extends CustomPainter {
  final double progress;

  const _StarDrawPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.46;
    final innerR = r * 0.50;

    final path = Path();
    for (int k = 0; k < 16; k++) {
      final angle = k * math.pi / 8 - math.pi / 2;
      final radius = k.isEven ? r : innerR;
      final pt = Offset(
        cx + radius * math.cos(angle),
        cy + radius * math.sin(angle),
      );
      if (k == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();

    final glowPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.18 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(cx, cy), r * 1.18, glowPaint);

    if (progress < 1.0) {
      final metrics = path.computeMetrics();
      final strokePaint = Paint()
        ..color = Colors.white.withValues(alpha: math.min(progress * 2, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      for (final metric in metrics) {
        final drawPath = metric.extractPath(0, metric.length * progress);
        canvas.drawPath(drawPath, strokePaint);
      }
    } else {
      final fillPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      final cCx = cx + r * 0.52;
      final cCy = cy - r * 0.55;
      final outerCR = r * 0.26;
      final innerCR = r * 0.20;

      final crescentPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(cCx, cCy), outerCR, crescentPaint);

      final carvePaint = Paint()..color = AppColors.primary;
      canvas.drawCircle(
        Offset(cCx + outerCR * 0.30, cCy - outerCR * 0.15),
        innerCR,
        carvePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarDrawPainter old) =>
      old.progress != progress;
}

// ── Islamic background pattern painter ───────────────────────────────────────

/// Tiling grid of muted gold octagrams that rotates very slowly.
class _IslamicPatternPainter extends CustomPainter {
  final double rotation;
  const _IslamicPatternPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const tileSize = 90.0;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rotation * 0.06);
    canvas.translate(-cx, -cy);

    final cols = (size.width / tileSize).ceil() + 2;
    final rows = (size.height / tileSize).ceil() + 2;

    for (int row = -1; row <= rows; row++) {
      for (int col = -1; col <= cols; col++) {
        final x = col * tileSize + (row.isOdd ? tileSize / 2 : 0.0);
        final y = row * tileSize * 0.866;
        _drawOctagram(canvas, Offset(x, y), tileSize * 0.35, paint);
      }
    }
    canvas.restore();
  }

  void _drawOctagram(Canvas canvas, Offset centre, double r, Paint paint) {
    for (int sq = 0; sq < 2; sq++) {
      final path = Path();
      final startAngle = sq * math.pi / 4;
      for (int i = 0; i < 4; i++) {
        final a = startAngle + i * math.pi / 2;
        final pt = Offset(
          centre.dx + r * math.cos(a),
          centre.dy + r * math.sin(a),
        );
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
    canvas.drawCircle(centre, r * 0.40, paint);
  }

  @override
  bool shouldRepaint(covariant _IslamicPatternPainter old) =>
      old.rotation != rotation;
}
