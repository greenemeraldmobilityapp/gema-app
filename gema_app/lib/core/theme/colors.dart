import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF006D36);
  static const Color primaryContainer = Color(0xFF50C878);
  static const Color secondaryContainer = Color(0xFF97F3B5);
  static const Color tertiaryContainer = Color(0xFFD8AD00);

  static const Color surface = Color(0xFFF5FBF1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEDF4E8);
  static const Color surfaceContainer = Color(0xFFE3EAE0);
  static const Color surfaceContainerHigh = Color(0xFFD8E0D3);
  static const Color surfaceContainerHighest = Color(0xFFCDD6C8);

  static const Color onSurface = Color(0xFF171D17);
  static const Color onSurfaceVariant = Color(0xFF3E4A3F);
  static const Color onSurfaceVariantLight = Color(0xFF6B7A6D);

  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF00391A);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF006D36);
  static const Color successContainer = Color(0xFF97F3B5);

  static const Color warning = Color(0xFFD8AD00);
  static const Color warningContainer = Color(0xFFFFF3C4);

  static const Color info = Color(0xFF0061A4);
  static const Color infoContainer = Color(0xFFD1E4FF);

  static const Color glassBackground = Color(0xCCF5FBF1);
  static const Color glassBorder = Color(0x33FFFFFF);

  static const Color shadowEmerald = Color(0x1A006D36);
  static const Color shadowEmeraldLight = Color(0x0F006D36);

  static const Color divider = Color(0x1A006D36);

  static const Color gradientStart = Color(0xFF006D36);
  static const Color gradientEnd = Color(0xFF50C878);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientHorizontal = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF004D26), gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
