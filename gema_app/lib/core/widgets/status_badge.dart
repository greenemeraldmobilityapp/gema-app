import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

enum BadgeType { success, warning, error, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final bool isPill;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.neutral,
    this.isPill = true,
  });

  Color get _backgroundColor {
    switch (type) {
      case BadgeType.success:
        return AppColors.successContainer;
      case BadgeType.warning:
        return AppColors.warningContainer;
      case BadgeType.error:
        return AppColors.errorContainer;
      case BadgeType.info:
        return AppColors.infoContainer;
      case BadgeType.neutral:
        return AppColors.surfaceContainer;
    }
  }

  Color get _textColor {
    switch (type) {
      case BadgeType.success:
        return AppColors.success;
      case BadgeType.warning:
        return AppColors.warning;
      case BadgeType.error:
        return AppColors.error;
      case BadgeType.info:
        return AppColors.info;
      case BadgeType.neutral:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: isPill
            ? BorderRadius.circular(9999)
            : BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class IconBadge extends StatelessWidget {
  final IconData icon;
  final int? count;
  final Color? backgroundColor;

  const IconBadge({
    super.key,
    required this.icon,
    this.count,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, size: 24, color: AppColors.onSurface),
        if (count != null && count! > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count! > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
