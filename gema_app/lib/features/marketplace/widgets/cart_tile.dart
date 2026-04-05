import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatters.dart';

class CartTile extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  const CartTile({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72,
              height: 72,
              child: imageUrl != null
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.surfaceContainer,
                      child: const Icon(Symbols.image, size: 28),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyMdMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(price),
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Symbols.delete,
                  size: 18,
                  color: AppColors.onSurfaceVariantLight,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _QuantityButton(
                    icon: Symbols.remove,
                    onTap: onDecrement,
                  ),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '$quantity',
                      textAlign: TextAlign.center,
                      style: AppTypography.labelLg.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  _QuantityButton(
                    icon: Symbols.add,
                    onTap: onIncrement,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.onSurface,
          fill: 1,
        ),
      ),
    );
  }
}
