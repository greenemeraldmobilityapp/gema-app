import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/order_model.dart';
import '../widgets/cart_tile.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMethod _selectedPayment = PaymentMethod.xendit;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartNotifierProvider);
    final cartItems = cartState.items;
    final subtotal = cartState.total;
    const shippingFee = 15000.0;
    const appFee = 2000.0;
    final total = subtotal + shippingFee + appFee;

    return Scaffold(
      appBar: const GlassAppBar(title: 'Checkout'),
      body: cartItems.isEmpty
          ? const EmptyState(
              icon: Symbols.shopping_cart,
              title: 'Keranjang Kosong',
              message: 'Tambahkan produk ke keranjang terlebih dahulu',
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          icon: Symbols.location_on,
                          title: 'Alamat Pengiriman',
                        ),
                        const SizedBox(height: 12),
                        _AddressCard(),
                        const SizedBox(height: 24),
                        _SectionHeader(
                          icon: Symbols.shopping_basket,
                          title: 'Ringkasan Pesanan',
                        ),
                        const SizedBox(height: 12),
                        ...cartItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CartTile(
                              id: item.id.toString(),
                              name: item.name,
                              price: item.price,
                              quantity: item.quantity,
                              imageUrl: item.imageUrl,
                              onIncrement: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .incrementQuantity(item.id);
                              },
                              onDecrement: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .decrementQuantity(item.id);
                              },
                              onRemove: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .removeFromCart(item.id);
                              },
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 24),
                        _SectionHeader(
                          icon: Symbols.payments,
                          title: 'Metode Pembayaran',
                        ),
                        const SizedBox(height: 12),
                        _PaymentMethodCard(
                          title: 'Cashless (Xendit)',
                          subtitle: 'Bank Transfer, E-Wallet, Kartu Kredit',
                          isSelected: _selectedPayment == PaymentMethod.xendit,
                          onTap: () {
                            setState(() {
                              _selectedPayment = PaymentMethod.xendit;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        _PaymentMethodCard(
                          title: 'Cash on Delivery (COD)',
                          subtitle: 'Bayar tunai saat barang diterima',
                          isSelected: _selectedPayment == PaymentMethod.cod,
                          onTap: () {
                            setState(() {
                              _selectedPayment = PaymentMethod.cod;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        _PricingCard(
                          subtotal: subtotal,
                          shippingFee: shippingFee,
                          appFee: appFee,
                          total: total,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Container(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTypography.titleMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(total),
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GradientButton(
                      label: 'Buat Pesanan',
                      icon: Symbols.eco,
                      onPressed: () => _handleCheckout(cartItems, total),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: cartItems.isNotEmpty
          ? _EcoTip()
          : null,
    );
  }

  Future<void> _handleCheckout(List<dynamic> items, double total) async {
    if (items.isEmpty) return;

    final orderNotifier = ref.read(orderNotifierProvider.notifier);
    final firstItem = items.first;

    final orderItems = items.map((item) => {
          'offering_id': item.offeringId,
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
          'subtotal': item.subtotal,
          'image_url': item.imageUrl,
        }).toList();

    const shippingFee = 15000.0;
    const appFee = 2000.0;

    final order = await orderNotifier.createOrder(
      storeId: firstItem.storeId,
      type: OrderType.marketplace,
      paymentMethod: _selectedPayment,
      totalItemPrice: items.fold<double>(
        0,
        (sum, item) => sum + item.subtotal,
      ),
      shippingFee: shippingFee,
      appFee: appFee,
      totalAmount: total,
      items: orderItems,
    );

    if (!mounted) return;

    if (order != null) {
      await ref.read(cartNotifierProvider.notifier).clearCart();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan berhasil dibuat!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        );
        context.go('/home');
      }
    } else {
      final error = ref.read(orderNotifierProvider).error;
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
          fill: 1,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.titleMd.copyWith(
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Symbols.home,
              color: AppColors.primary,
              size: 20,
              fill: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alamat Utama',
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Jl. Raya Jepara No. 123, Jepara, Jawa Tengah',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButtonWidget(
            label: 'Ubah',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariantLight,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLg.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariantLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double appFee;
  final double total;

  const _PricingCard({
    required this.subtotal,
    required this.shippingFee,
    required this.appFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          _PricingRow(
            label: 'Subtotal Produk',
            value: CurrencyFormatter.format(subtotal),
          ),
          const SizedBox(height: 8),
          _PricingRow(
            label: 'Biaya Pengiriman',
            value: CurrencyFormatter.format(shippingFee),
          ),
          const SizedBox(height: 8),
          _PricingRow(
            label: 'Biaya Layanan Platform',
            value: CurrencyFormatter.format(appFee),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 8),
          _PricingRow(
            label: 'Total',
            value: CurrencyFormatter.format(total),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PricingRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isTotal ? AppTypography.titleMd : AppTypography.bodyMd)
              .copyWith(
            color: isTotal ? AppColors.onSurface : AppColors.onSurfaceVariant,
            fontWeight: isTotal ? FontWeight.w700 : null,
          ),
        ),
        Text(
          value,
          style: (isTotal ? AppTypography.titleMd : AppTypography.bodyMdMedium)
              .copyWith(
            color: isTotal ? AppColors.primary : AppColors.onSurface,
            fontWeight: isTotal ? FontWeight.w800 : null,
          ),
        ),
      ],
    );
  }
}

class _EcoTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Symbols.eco,
            size: 18,
            color: AppColors.primary,
            fill: 1,
          ),
          const SizedBox(width: 8),
          Text(
            'Mendukung pengrajin lokal Jepara',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
