import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/widgets/widgets.dart';
import '../../../providers/store_provider.dart';
import '../../../providers/product_provider.dart';
import '../widgets/product_card.dart';

class StoreDetailScreen extends ConsumerStatefulWidget {
  final String storeId;

  const StoreDetailScreen({super.key, required this.storeId});

  @override
  ConsumerState<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends ConsumerState<StoreDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storeNotifierProvider.notifier).loadStoreById(widget.storeId);
      ref.read(productNotifierProvider.notifier).loadProducts(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeState = ref.watch(storeNotifierProvider);
    final store = storeState.selectedStore;
    final productState = ref.watch(productNotifierProvider);

    return Scaffold(
      body: store == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: store.bannerUrl != null
                            ? Image.network(
                                store.bannerUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.surfaceContainer,
                                ),
                              )
                            : Container(
                                color: AppColors.surfaceContainer,
                              ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.surface.withOpacity(0.9),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 48,
                        left: 16,
                        child: Row(
                          children: [
                            _BackButton(),
                            const Spacer(),
                            _FloatingActionCircle(
                              icon: Symbols.share,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -32),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppShadows.cardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Text(
                                      store.name.substring(0, 1).toUpperCase(),
                                      style: AppTypography.headlineMd.copyWith(
                                        color: AppColors.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              store.name,
                                              style: AppTypography.headlineSm
                                                  .copyWith(
                                                color: AppColors.onSurface,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Icon(
                                            Symbols.verified,
                                            size: 20,
                                            color: AppColors.primary,
                                            fill: 1,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Symbols.star,
                                            size: 16,
                                            color: AppColors.tertiaryContainer,
                                            fill: 1,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${store.rating.toStringAsFixed(1)} (${store.ratingCount}+ ulasan)',
                                            style: AppTypography.bodySm.copyWith(
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (store.address != null) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Symbols.location_on,
                                              size: 14,
                                              color: AppColors.onSurfaceVariantLight,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              store.address!,
                                              style: AppTypography.bodySm.copyWith(
                                                color: AppColors.onSurfaceVariantLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (store.category.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: store.category
                                    .split(',')
                                    .map((tag) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(9999),
                                          ),
                                          child: Text(
                                            tag.trim(),
                                            style: AppTypography.labelSm.copyWith(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Symbols.chat,
                                          size: 18,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Pesan',
                                          style: AppTypography.labelLg.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Symbols.favorite,
                                          size: 18,
                                          color: AppColors.primary,
                                          fill: 0,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Favorit',
                                          style: AppTypography.labelLg.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Produk Unggulan',
                          style: AppTypography.titleLg.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        TextButtonWidget(
                          label: 'Lihat Semua',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                if (productState.isLoading)
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: ShimmerGrid(
                        crossAxisCount: 2,
                        itemCount: 4,
                        aspectRatio: 0.85,
                        spacing: 12,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = productState.products[index];
                          return ProductCard(
                            id: product.id,
                            name: product.name,
                            price: product.price,
                            imageUrl: product.primaryImage,
                            rating: product.rating,
                            soldCount: product.soldCount,
                            onTap: () {
                              context.push('/product/${product.id}');
                            },
                          );
                        },
                        childCount: productState.products.length.clamp(0, 4),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pesan Custom Furniture?',
                                  style: AppTypography.headlineSm.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Konsultasikan kebutuhan furniture custom Anda dengan pengrajin ahli Jepara.',
                                  style: AppTypography.bodySm.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    'Konsultasi Sekarang',
                                    style: AppTypography.labelLg.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Symbols.construction,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Symbols.arrow_back,
          size: 20,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}

class _FloatingActionCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingActionCircle({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.onSurface,
          fill: 0,
        ),
      ),
    );
  }
}
