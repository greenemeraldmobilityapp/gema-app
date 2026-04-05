import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/store_card.dart';

class FoodMarketplaceScreen extends ConsumerStatefulWidget {
  const FoodMarketplaceScreen({super.key});

  @override
  ConsumerState<FoodMarketplaceScreen> createState() =>
      _FoodMarketplaceScreenState();
}

class _FoodMarketplaceScreenState extends ConsumerState<FoodMarketplaceScreen> {
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'Semua',
    'Kuliner',
    'Mebel',
    'Fashion',
    'Kerajinan',
  ];
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productNotifierProvider.notifier).loadProducts(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);
    final cartCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Symbols.arrow_back, size: 24),
                      onPressed: () => context.pop(),
                    ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Symbols.shopping_cart,
                                size: 24,
                              ),
                              onPressed: () {},
                            ),
                            if (cartCount > 0)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$cartCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jelajahi Produk Jepara',
                    style: AppTypography.displayMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SearchInput(
                    controller: _searchController,
                    hintText: 'Cari produk, makanan, kerajinan...',
                    onChanged: (value) {
                      ref
                          .read(productNotifierProvider.notifier)
                          .setSearchQuery(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                            ref
                                .read(productNotifierProvider.notifier)
                                .setCategory(
                                  category == 'Semua' ? null : category,
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppColors.primaryGradient
                                  : null,
                              color: isSelected
                                  ? null
                                  : AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              category,
                              style: AppTypography.labelLg.copyWith(
                                color: isSelected
                                    ? AppColors.onPrimary
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
          else if (productState.products.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.only(top: 40),
              sliver: SliverToBoxAdapter(
                child: EmptyState(
                  icon: Symbols.shopping_bag,
                  title: 'Belum Ada Produk',
                  message: 'Produk akan muncul di sini',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == productState.products.length) {
                      return const SizedBox.shrink();
                    }
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
                  childCount: productState.products.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: cartCount > 0
          ? GestureDetector(
              onTap: () => context.push('/checkout'),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Symbols.shopping_cart,
                        color: Colors.white,
                        size: 28,
                        fill: 1,
                      ),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$cartCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
