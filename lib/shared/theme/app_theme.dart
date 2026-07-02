import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── COLOR TOKENS ───────────────────────────────────────────────────────────
// Palette: Deep night-sky navy + warm gold + soft sage green
// Inspired by Islamic geometric art — deep, contemplative, not garish

class AppColors {
  AppColors._();

  // Primary — Deep Teal (night sky, tranquility)
  static const Color primary = Color(0xFF1B4F72);
  static const Color primaryLight = Color(0xFF2E86C1);
  static const Color primaryDark = Color(0xFF0D2B3E);

  // Accent — Warm Gold (mosque domes, spiritual warmth)
  static const Color gold = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8C96A);
  static const Color goldDark = Color(0xFF9A7B2F);

  // Surface — Soft off-whites with warmth
  static const Color background = Color(0xFFF8F6F1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0EDE6);

  // Semantic
  static const Color success = Color(0xFF2D7D46);
  static const Color error = Color(0xFFB83232);
  static const Color warning = Color(0xFFD4851A);

  // Prayer colors — each prayer has its own identity
  static const Color fajr = Color(0xFF4A235A);    // Deep purple — pre-dawn
  static const Color dhuhr = Color(0xFF1A5276);   // Mid-blue — midday
  static const Color asr = Color(0xFF7E5109);     // Amber — afternoon
  static const Color maghrib = Color(0xFF922B21); // Deep red — sunset
  static const Color isha = Color(0xFF1B2631);    // Near-black — night

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF5D6D7E);
  static const Color textHint = Color(0xFFAEB6BF);
  static const Color textOnDark = Color(0xFFFAFAFA);

  // Step indicator
  static const Color stepActive = gold;
  static const Color stepInactive = Color(0xFFD5D8DC);
  static const Color stepCompleted = success;
}

// ─── TYPOGRAPHY ──────────────────────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  // Display — Playfair Display for Arabic-adjacent elegance
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  // Body — Inter for clarity and legibility
  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      );

  // Arabic numerals / data
  static TextStyle get dataLarge => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: -1,
      );
}

// ─── THEME ───────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineMedium,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnDark,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontSize: 16,
            color: AppColors.textOnDark,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTextStyles.labelLarge.copyWith(fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: AppTextStyles.bodyMedium,
        labelStyle: AppTextStyles.bodyMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        labelStyle: AppTextStyles.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  static ThemeData get dark {
    const darkSurface = Color(0xFF1C1C2E);
    const darkBg = Color(0xFF12121F);
    const darkCard = Color(0xFF252538);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.gold,
        surface: darkSurface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: darkBg,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineMedium
            .copyWith(color: AppColors.textOnDark),
        iconTheme: const IconThemeData(color: AppColors.textOnDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.textOnDark,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        hintStyle: AppTextStyles.bodyMedium
            .copyWith(color: Colors.white38),
        labelStyle: AppTextStyles.bodyMedium
            .copyWith(color: Colors.white54),
      ),
      cardColor: darkCard,
    );
  }
}

// ─── SPACING & RADII ─────────────────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 24.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
}

class AppRadius {
  AppRadius._();

  static const double sm = 8.0;
  static const double md = 14.0;
  static const double lg = 20.0;
  static const double xl = 28.0;
  static const double full = 999.0;
}
