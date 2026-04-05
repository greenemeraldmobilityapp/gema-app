import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class BentoGrid extends StatelessWidget {
  const BentoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan',
          style: AppTypography.titleLg.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _BentoItem(
              icon: Symbols.storefront,
              label: 'Toko',
              color: AppColors.primary,
              onTap: () => context.push('/food-marketplace'),
            ),
            _BentoItem(
              icon: Symbols.shopping_bag,
              label: 'Produk',
              color: const Color(0xFF9C27B0),
              onTap: () => context.push('/food-marketplace'),
            ),
            _BentoItem(
              icon: Icons.location_on_rounded,
              label: 'Lacak',
              color: const Color(0xFF2196F3),
              onTap: () {},
            ),
            _BentoItem(
              icon: Symbols.chat,
              label: 'Chat',
              color: const Color(0xFFFF9800),
              onTap: () {},
            ),
            _BentoItem(
              icon: Icons.history_rounded,
              label: 'Riwayat',
              color: AppColors.onSurfaceVariant,
              onTap: () => context.push('/wallet'),
            ),
            _BentoItem(
              icon: Icons.help_outline_rounded,
              label: 'Bantuan',
              color: AppColors.onSurfaceVariant,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _BentoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BentoItem({
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
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
