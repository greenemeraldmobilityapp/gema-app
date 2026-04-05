import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksi Cepat',
          style: AppTypography.titleLg.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickActionItem(
              icon: Symbols.restaurant,
              label: 'Makanan',
              color: AppColors.primary,
              onTap: () => context.push('/food-marketplace'),
            ),
            _QuickActionItem(
              icon: Symbols.local_shipping,
              label: 'Kurir',
              color: const Color(0xFF2196F3),
              onTap: () {},
            ),
            _QuickActionItem(
              icon: Symbols.cleaning_services,
              label: 'Jasa',
              color: const Color(0xFFFF9800),
              onTap: () => context.push('/service'),
            ),
            _QuickActionItem(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Bayar',
              color: AppColors.primary,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
              fill: 0,
              weight: 300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
