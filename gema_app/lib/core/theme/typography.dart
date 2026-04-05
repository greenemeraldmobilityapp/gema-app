import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static const double _displayLg = 48;
  static const double _displayMd = 36;
  static const double _headlineLg = 32;
  static const double _headlineMd = 24;
  static const double _headlineSm = 20;
  static const double _titleLg = 18;
  static const double _titleMd = 16;
  static const double _titleSm = 14;
  static const double _bodyLg = 16;
  static const double _bodyMd = 14;
  static const double _bodySm = 12;
  static const double _labelLg = 14;
  static const double _labelMd = 12;
  static const double _labelSm = 10;

  static const double _defaultHeight = 1.3;
  static const double _bodyHeight = 1.5;
  static const double _tightHeight = 1.15;

  static TextStyle displayLg = GoogleFonts.manrope(
    fontSize: _displayLg,
    fontWeight: FontWeight.w900,
    height: _tightHeight,
    letterSpacing: -1.0,
  );

  static TextStyle displayMd = GoogleFonts.manrope(
    fontSize: _displayMd,
    fontWeight: FontWeight.w800,
    height: _tightHeight,
    letterSpacing: -0.5,
  );

  static TextStyle headlineLg = GoogleFonts.manrope(
    fontSize: _headlineLg,
    fontWeight: FontWeight.w800,
    height: _tightHeight,
    letterSpacing: -0.5,
  );

  static TextStyle headlineMd = GoogleFonts.manrope(
    fontSize: _headlineMd,
    fontWeight: FontWeight.w700,
    height: _tightHeight,
    letterSpacing: -0.25,
  );

  static TextStyle headlineSm = GoogleFonts.manrope(
    fontSize: _headlineSm,
    fontWeight: FontWeight.w700,
    height: _defaultHeight,
  );

  static TextStyle titleLg = GoogleFonts.manrope(
    fontSize: _titleLg,
    fontWeight: FontWeight.w600,
    height: _defaultHeight,
  );

  static TextStyle titleMd = GoogleFonts.manrope(
    fontSize: _titleMd,
    fontWeight: FontWeight.w600,
    height: _defaultHeight,
  );

  static TextStyle titleSm = GoogleFonts.manrope(
    fontSize: _titleSm,
    fontWeight: FontWeight.w600,
    height: _defaultHeight,
  );

  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: _bodyLg,
    fontWeight: FontWeight.w400,
    height: _bodyHeight,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: _bodyMd,
    fontWeight: FontWeight.w400,
    height: _bodyHeight,
  );

  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: _bodySm,
    fontWeight: FontWeight.w400,
    height: _bodyHeight,
  );

  static TextStyle bodyMdMedium = GoogleFonts.inter(
    fontSize: _bodyMd,
    fontWeight: FontWeight.w500,
    height: _bodyHeight,
  );

  static TextStyle bodySmMedium = GoogleFonts.inter(
    fontSize: _bodySm,
    fontWeight: FontWeight.w500,
    height: _bodyHeight,
  );

  static TextStyle labelLg = GoogleFonts.inter(
    fontSize: _labelLg,
    fontWeight: FontWeight.w600,
    height: _defaultHeight,
    letterSpacing: 0.1,
  );

  static TextStyle labelMd = GoogleFonts.inter(
    fontSize: _labelMd,
    fontWeight: FontWeight.w600,
    height: _defaultHeight,
    letterSpacing: 0.15,
  );

  static TextStyle labelSm = GoogleFonts.inter(
    fontSize: _labelSm,
    fontWeight: FontWeight.w600,
    height: _defaultHeight,
    letterSpacing: 0.2,
  );

  static TextStyle buttonLg = GoogleFonts.manrope(
    fontSize: _titleMd,
    fontWeight: FontWeight.w700,
    height: _defaultHeight,
    letterSpacing: 0.1,
  );

  static TextStyle buttonMd = GoogleFonts.manrope(
    fontSize: _titleSm,
    fontWeight: FontWeight.w700,
    height: _defaultHeight,
    letterSpacing: 0.1,
  );

  static TextStyle buttonSm = GoogleFonts.manrope(
    fontSize: _labelLg,
    fontWeight: FontWeight.w600,
    height: _defaultHeight,
    letterSpacing: 0.1,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: _labelSm,
    fontWeight: FontWeight.w500,
    height: _defaultHeight,
    letterSpacing: 0.2,
  );

  static TextStyle overline = GoogleFonts.inter(
    fontSize: _labelSm,
    fontWeight: FontWeight.w600,
    height: _defaultHeight,
    letterSpacing: 0.5,
  );
}
