import 'package:flutter/material.dart';
import 'colors.dart';

class AppShadows {
  AppShadows._();

  static const BoxShadow sm = BoxShadow(
    color: AppColors.shadowEmeraldLight,
    blurRadius: 8,
    offset: Offset(0, 2),
    spreadRadius: 0,
  );

  static const BoxShadow md = BoxShadow(
    color: AppColors.shadowEmerald,
    blurRadius: 24,
    offset: Offset(0, 6),
    spreadRadius: 0,
  );

  static const BoxShadow lg = BoxShadow(
    color: AppColors.shadowEmerald,
    blurRadius: 32,
    offset: Offset(0, 8),
    spreadRadius: 0,
  );

  static const BoxShadow xl = BoxShadow(
    color: Color(0x24006D36),
    blurRadius: 40,
    offset: Offset(0, 12),
    spreadRadius: 0,
  );

  static const BoxShadow cardHover = BoxShadow(
    color: Color(0x1F006D36),
    blurRadius: 28,
    offset: Offset(0, 10),
    spreadRadius: 0,
  );

  static const BoxShadow floatingButton = BoxShadow(
    color: Color(0x3D006D36),
    blurRadius: 30,
    offset: Offset(0, 8),
    spreadRadius: 0,
  );

  static const BoxShadow appBar = BoxShadow(
    color: Color(0x0A006D36),
    blurRadius: 16,
    offset: Offset(0, 4),
    spreadRadius: 0,
  );

  static const BoxShadow innerGlow = BoxShadow(
    color: Color(0x1AFFFFFF),
    blurRadius: 12,
    offset: Offset(0, 2),
    spreadRadius: 0,
  );

  static List<BoxShadow> get cardShadow => [md];
  static List<BoxShadow> get elevatedShadow => [lg];
  static List<BoxShadow> get floatingShadow => [xl];
  static List<BoxShadow> get buttonShadow => [floatingButton];
}
