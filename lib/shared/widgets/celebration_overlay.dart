import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/app_theme.dart';

/// Full-screen celebration overlay shown when a personal-best streak is hit.
///
/// Usage:
/// ```dart
/// FullScreenCelebrationOverlay.show(context,
///     habitName: 'Fajr Prayer', streakCount: 30);
/// ```
///
/// The confetti is driven by `assets/animations/celebration.json` (Lottie).
/// If the asset file is missing at runtime, the overlay silently falls back to
/// the pure-Dart [_ConfettiPainter] implementation so the overlay never crashes.
class FullScreenCelebrationOverlay extends StatefulWidget {
  final String habitName;
  final int streakCount;
  final VoidCallback onDismiss;

  const FullScreenCelebrationOverlay({
    super.key,
    required this.habitName,
    required this.streakCount,
    required this.onDismiss,
  });

  static void show(
    BuildContext context, {
    required String habitName,
    required int streakCount,
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => FullScreenCelebrationOverlay(
        habitName: habitName,
        streakCount: streakCount,
        onDismiss: entry.remove,
      ),
    );
    Overlay.of(context).insert(entry);
  }

  @override
  State<FullScreenCelebrationOverlay> createState() =>
      _FullScreenCelebrationOverlayState();
}

class _FullScreenCelebrationOverlayState
    extends State<FullScreenCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _backdropCtrl;
  late Animation<double> _backdropOpacity;

  static const _totalDuration = Duration(milliseconds: 2500);

  @override
  void initState() {
    super.initState();
    _backdropCtrl = AnimationController(
      vsync: this,
      duration: _totalDuration,
    )..forward().then((_) {
        if (mounted) widget.onDismiss();
      });

    _backdropOpacity = Tween<double>(begin: 0.0, end: 0.72).animate(
      CurvedAnimation(
        parent: _backdropCtrl,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _backdropCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: AnimatedBuilder(
        animation: _backdropCtrl,
        builder: (_, __) => Material(
          color: Colors.black.withValues(alpha: _backdropOpacity.value),
          child: Stack(
            children: [
              // ── Lottie confetti (fills the screen) ─────────────────────────
              const _LottieConfetti(duration: _totalDuration),

              // ── Celebration card ────────────────────────────────────────────
              Center(
                child: _CelebrationCard(
                  habitName: widget.habitName,
                  streakCount: widget.streakCount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Lottie confetti layer with CustomPainter fallback ─────────────────────────

class _LottieConfetti extends StatelessWidget {
  final Duration duration;
  const _LottieConfetti({required this.duration});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Lottie.asset(
        'assets/animations/celebration.json',
        fit: BoxFit.cover,
        repeat: false,
        animate: true,
        // If the asset is missing or corrupt, Lottie throws; the ErrorBuilder
        // swaps in the pure-Dart fallback so the overlay still works.
        errorBuilder: (_, __, ___) => _FallbackConfetti(duration: duration),
      ),
    );
  }
}

// ── Pure-Dart fallback confetti (used when Lottie asset is unavailable) ───────

class _FallbackConfetti extends StatefulWidget {
  final Duration duration;
  const _FallbackConfetti({required this.duration});

  @override
  State<_FallbackConfetti> createState() => _FallbackConfettiState();
}

class _FallbackConfettiState extends State<_FallbackConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = _ConfettiParticle.generate(100);
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        size: MediaQuery.of(context).size,
        painter: _ConfettiPainter(
          particles: _particles,
          progress: _ctrl.value,
        ),
      ),
    );
  }
}

// ── Celebration card ──────────────────────────────────────────────────────────

class _CelebrationCard extends StatefulWidget {
  final String habitName;
  final int streakCount;
  const _CelebrationCard({required this.habitName, required this.streakCount});

  @override
  State<_CelebrationCard> createState() => _CelebrationCardState();
}

class _CelebrationCardState extends State<_CelebrationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _fade.value,
        child: Transform.scale(
          scale: _scale.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 36),
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.goldDark, AppColors.gold, Color(0xFFE8C96A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.55),
                  blurRadius: 48,
                  spreadRadius: 6,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 14),
                Text(
                  'New Personal Best!',
                  style: AppTextStyles.displayMedium
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.habitName,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.streakCount} day streak 🔥',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Tap anywhere to dismiss',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Fallback confetti particles ───────────────────────────────────────────────

class _ConfettiParticle {
  final double startX;
  final double startY;
  final double vx;
  final double vy;
  final Color color;
  final double size;
  final bool isCircle;
  final double rotStart;
  final double rotSpeed;

  const _ConfettiParticle({
    required this.startX,
    required this.startY,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.isCircle,
    required this.rotStart,
    required this.rotSpeed,
  });

  static const _colors = [
    Color(0xFFC9A84C),
    Color(0xFF1B6B3A),
    Color(0xFF2E86C1),
    Color(0xFF9B59B6),
    Color(0xFFE67E22),
    Colors.white,
    Color(0xFFE05D5D),
    Color(0xFF48C9B0),
  ];

  static List<_ConfettiParticle> generate(int count) {
    final rng = math.Random(42);
    return List.generate(count, (_) => _ConfettiParticle(
      startX: rng.nextDouble(),
      startY: -(0.04 + rng.nextDouble() * 0.20),
      vx: (rng.nextDouble() - 0.5) * 0.25,
      vy: 0.12 + rng.nextDouble() * 0.45,
      color: _colors[rng.nextInt(_colors.length)],
      size: 5.0 + rng.nextDouble() * 9.0,
      isCircle: rng.nextBool(),
      rotStart: rng.nextDouble() * math.pi * 2,
      rotSpeed: (rng.nextDouble() - 0.5) * math.pi * 8,
    ));
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  const _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const g = 0.55;
    final fade = progress > 0.75 ? 1.0 - ((progress - 0.75) / 0.25) : 1.0;
    final t = progress;

    for (final p in particles) {
      final px = (p.startX + p.vx * t) * size.width;
      final py = (p.startY + p.vy * t + 0.5 * g * t * t) * size.height;
      if (py > size.height + p.size) continue;
      if (px < -p.size || px > size.width + p.size) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: fade.clamp(0.0, 1.0));

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotStart + p.rotSpeed * t);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
