import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../providers/transaction_provider.dart';

class RecentTransactions extends ConsumerWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionNotifierProvider);

    if (transactionState.isLoading) {
      return const ShimmerList(itemCount: 3, itemHeight: 64, spacing: 8);
    }

    if (transactionState.transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Text(
          'Belum ada transaksi',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariantLight,
          ),
        ),
      );
    }

    final recent = transactionState.transactions.take(5).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final tx = recent[index];
        return _TransactionTile(transaction: tx);
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final dynamic transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type.name == 'income';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isIncome
                      ? AppColors.success
                      : AppColors.primary)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Symbols.arrow_downward : Symbols.arrow_upward,
              color: isIncome ? AppColors.success : AppColors.primary,
              size: 22,
              fill: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.merchantName ?? transaction.categoryLabel,
                  style: AppTypography.bodyMdMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.formatRelative(transaction.createdAt),
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariantLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
            style: AppTypography.labelLg.copyWith(
              color: isIncome ? AppColors.success : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
