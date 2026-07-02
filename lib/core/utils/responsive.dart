import 'package:flutter/material.dart';

// ─── SCREEN SIZE ENUM ────────────────────────────────────────────────────────
/// Categorises the current screen into four buckets that drive layout decisions.
enum ScreenSize {
  /// < 360 dp  — small Android phones, iPhone SE in landscape
  small,

  /// 360–599 dp — most phones in portrait
  medium,

  /// 600–767 dp — large phones, small tablets in portrait
  large,

  /// ≥ 768 dp — tablets (iPad, Android tablets)
  tablet,
}

// ─── RESPONSIVE ──────────────────────────────────────────────────────────────
/// Static helpers for screen-size–aware layout decisions.
/// All methods read from [MediaQuery] so they automatically respond to
/// orientation changes, window resizes, and split-screen.
class Responsive {
  Responsive._();

  static const double _smallBreak  = 360.0;
  static const double _mediumBreak = 600.0;
  static const double _tabletBreak = 768.0;

  // ── Queries ──────────────────────────────────────────────────────────────

  static ScreenSize screenSizeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < _smallBreak)  return ScreenSize.small;
    if (width < _mediumBreak) return ScreenSize.medium;
    if (width < _tabletBreak) return ScreenSize.large;
    return ScreenSize.tablet;
  }

  static bool isPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < _tabletBreak;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _tabletBreak;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < _smallBreak;

  // ── Adaptive value helpers ───────────────────────────────────────────────

  /// Returns the value matching the current [ScreenSize].
  /// Falls back: tablet → large → medium when narrower overrides are absent.
  static T resolve<T>(
    BuildContext context, {
    required T small,
    required T medium,
    T? large,
    T? tablet,
  }) {
    switch (screenSizeOf(context)) {
      case ScreenSize.small:  return small;
      case ScreenSize.medium: return medium;
      case ScreenSize.large:  return large  ?? medium;
      case ScreenSize.tablet: return tablet ?? large ?? medium;
    }
  }

  static double value(
    BuildContext context, {
    required double small,
    required double medium,
    double? large,
    double? tablet,
  }) =>
      resolve<double>(context,
          small: small, medium: medium, large: large, tablet: tablet);

  // ── Common adaptive constants ────────────────────────────────────────────

  /// Horizontal screen padding (left + right inset for page content).
  static double screenHPadding(BuildContext context) =>
      value(context, small: 16, medium: 20, large: 24, tablet: 32);

  static EdgeInsets screenPadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: screenHPadding(context));

  /// Inner padding for cards.
  static double cardPadding(BuildContext context) =>
      value(context, small: 14, medium: 16, large: 20, tablet: 24);

  /// Horizontal padding per bottom-nav item — shrinks when items are many.
  static double navItemHPadding(BuildContext context, int itemCount) {
    final w = MediaQuery.sizeOf(context).width;
    // Available width per item minus icon(24)+label(~36) = ~60px minimum
    final available = (w / itemCount) - 60;
    return available.clamp(4.0, 16.0);
  }

  /// Maximum content width for single-column tablet layouts.
  static double maxContentWidth(BuildContext context) =>
      isTablet(context) ? 720 : double.infinity;
}

// ─── BUILD-CONTEXT EXTENSION ─────────────────────────────────────────────────
extension ResponsiveContext on BuildContext {
  bool   get isTablet    => Responsive.isTablet(this);
  bool   get isPhone     => Responsive.isPhone(this);
  bool   get isLandscape => Responsive.isLandscape(this);
  bool   get isSmallPhone => Responsive.isSmallPhone(this);
  ScreenSize get screenSize => Responsive.screenSizeOf(this);
  double get screenWidth  => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenHPadding => Responsive.screenHPadding(this);
  EdgeInsets get screenPadding => Responsive.screenPadding(this);

  /// Inline adaptive value — shorthand for one-off values.
  double adaptive({
    required double small,
    required double medium,
    double? large,
    double? tablet,
  }) =>
      Responsive.value(this,
          small: small, medium: medium, large: large, tablet: tablet);
}

// ─── RESPONSIVE BUILDER ──────────────────────────────────────────────────────
/// Rebuilds whenever orientation or window size changes.
/// Exposes [ScreenSize] and landscape flag to the [builder].
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ScreenSize screenSize,
    bool isLandscape,
  ) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      Responsive.screenSizeOf(context),
      Responsive.isLandscape(context),
    );
  }
}

// ─── ADAPTIVE SPACING ────────────────────────────────────────────────────────
/// Provides spacing values that scale with screen size.
/// Usage:
///   final sp = AdaptiveSpacing.of(context);
///   SizedBox(height: sp.lg)
class AdaptiveSpacing {
  const AdaptiveSpacing.of(this._context);
  final BuildContext _context;

  double get xs => Responsive.value(_context, small: 4,  medium: 4,  large: 4);
  double get sm => Responsive.value(_context, small: 6,  medium: 8,  large: 8);
  double get md => Responsive.value(_context, small: 12, medium: 16, large: 16);
  double get lg => Responsive.value(_context, small: 18, medium: 24, large: 24);
  double get xl => Responsive.value(_context, small: 24, medium: 32, large: 32);
  double get xxl => Responsive.value(_context, small: 32, medium: 48, large: 48);

  double get screenH => Responsive.screenHPadding(_context);
  EdgeInsets get screen => Responsive.screenPadding(_context);
}
