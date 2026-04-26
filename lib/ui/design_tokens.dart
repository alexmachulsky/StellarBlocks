import 'package:flutter/material.dart';

/// Cosmic night sky color palette for StellarBlocks.
///
/// All colors are static constants representing the visual theme.
/// Never hardcode hex colors outside this file.
class AppColors {
  // Deep space background
  static const Color background = Color(0xFF0A0E1A);

  // Card and tile surface
  static const Color surface = Color(0xFF141929);

  // Star highlight — warm gold for constellation illumination
  static const Color starGold = Color(0xFFF5C542);

  // Secondary accent — nebula purple
  static const Color nebulaPurple = Color(0xFF6B2FA0);

  // Pure black for void elements
  static const Color voidBlack = Color(0xFF000000);

  // Primary text
  static const Color textPrimary = Color(0xFFFFFFFF);

  // Secondary text — dimmed for less emphasis
  static const Color textSecondary = Color(0xFFB0B8D0);
}

/// Spacing scale for consistent layout rhythm.
///
/// Use these constants for padding, margins, and gaps throughout the UI.
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Text styles for consistent typography across the app.
///
/// These are static constants so they can reference AppColors and other constants.
class AppTextStyles {
  // Heading style — large, bold, with letter spacing for cosmic feel
  static const TextStyle heading = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );

  // Body text — standard reading size
  static const TextStyle body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16.0,
  );
}
