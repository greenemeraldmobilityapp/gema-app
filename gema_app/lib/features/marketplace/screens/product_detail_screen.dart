import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../data/models/offering_model.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productNotifierProvider.notifier).loadProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);
    final product = productState.selectedProduct;

    return Scaffold(
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      _HeroImage(
                        imageUrls: product.imageUrls,
                        currentIndex: _currentImageIndex,
                        onIndexChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      Positioned(
                        top: 48,
                        left: 16,
                        child: Row(
                          children: [
                            _FloatingIconButton(
                              icon: Symbols.arrow_back,
                              onTap: () => context.pop(),
                            ),
                            const SizedBox(width: 8),
                            _FloatingIconButton(
                              icon: Symbols.share,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 48,
                        right: 16,
                        child: _FloatingIconButton(
                          icon: Symbols.favorite,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                'Authentic Jepara',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.onPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Symbols.star,
                              size: 16,
                              color: AppColors.tertiaryContainer,
                              fill: 1,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating.toStringAsFixed(1)} (${product.ratingCount} ulasan)',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.name,
                          style: AppTypography.headlineMd.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.format(product.price),
                          style: AppTypography.displayMd.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _StoreInfoCard(
                          storeId: product.storeId,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              left: BorderSide(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            product.description,
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Spesifikasi',
                          style: AppTypography.titleLg.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SpecsGrid(product: product),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: product != null
          ? _BottomActionBar(
              product: product,
              onAddToCart: () => _addToCart(product),
              onChatSeller: () {},
            )
          : null,
    );
  }

  void _addToCart(dynamic product) {
    ref.read(cartNotifierProvider.notifier).addToCart(
          offeringId: product.id,
          storeId: product.storeId,
          name: product.name,
          price: product.price,
          type: OfferingType.product,
          imageUrl: product.primaryImage,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final List<String> imageUrls;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const _HeroImage({
    required this.imageUrls,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: PageView.builder(
            onPageChanged: onIndexChanged,
            itemCount: imageUrls.isNotEmpty ? imageUrls.length : 1,
            itemBuilder: (context, index) {
              if (imageUrls.isEmpty) {
                return Container(
                  color: AppColors.surfaceContainer,
                  child: const Center(
                    child: Icon(Symbols.image, size: 64),
                  ),
                );
              }
              return Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceContainer,
                  child: const Center(
                    child: Icon(Symbols.image, size: 64),
                  ),
                ),
              );
            },
          ),
        ),
        if (imageUrls.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: imageUrls.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == currentIndex;
                return GestureDetector(
                  onTap: () => onIndexChanged(index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _StoreInfoCard extends StatelessWidget {
  final String storeId;

  const _StoreInfoCard({required this.storeId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/store/$storeId'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(
                  Symbols.storefront,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lihat Toko',
                    style: AppTypography.titleSm.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    'Klik untuk melihat produk lainnya',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariantLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Symbols.chevron_right,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecsGrid extends StatelessWidget {
  final dynamic product;

  const _SpecsGrid({required this.product});

  @override
  Widget build(BuildContext context) {
    final specs = [
      {'label': 'Kategori', 'value': product.category},
      {'label': 'Rating', 'value': '${product.rating.toStringAsFixed(1)} / 5.0'},
      {'label': 'Terjual', 'value': '${product.soldCount} unit'},
      {'label': 'Ketersediaan', 'value': product.isAvailable ? 'Tersedia' : 'Habis'},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: specs.map((spec) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                spec['label']!,
                style: AppTypography.caption.copyWith(
                  color: AppColors.onSurfaceVariantLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                spec['value']!,
                style: AppTypography.labelLg.copyWith(
                  color: AppColors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingIconButton({
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

class _BottomActionBar extends StatelessWidget {
  final dynamic product;
  final VoidCallback onAddToCart;
  final VoidCallback onChatSeller;

  const _BottomActionBar({
    required this.product,
    required this.onAddToCart,
    required this.onChatSeller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CurrencyFormatter.format(product.price),
                    style: AppTypography.titleMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: onChatSeller,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Icon(
                Symbols.chat,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GradientButton(
                label: 'Tambah ke Keranjang',
                icon: Symbols.shopping_cart,
                isFullWidth: false,
                height: 50,
                onPressed: onAddToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
