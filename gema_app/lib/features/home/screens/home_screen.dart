import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/wallet_card.dart';
import '../widgets/bento_grid.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transactions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionNotifierProvider.notifier).loadTransactions(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      body: Column(
        children: [
          HomeHeader(
            userName: user?.displayName ?? 'Pengguna',
            onNotificationTap: () {},
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WalletCard(
                          balance: ref.watch(walletBalanceProvider),
                          onTap: () => context.push('/wallet'),
                        ),
                        const SizedBox(height: 24),
                        const QuickActions(),
                        const SizedBox(height: 24),
                        const BentoGrid(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Aktivitas Terbaru',
                              style: AppTypography.titleLg.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                            TextButtonWidget(
                              label: 'Lihat Semua',
                              onPressed: () => context.push('/wallet'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const RecentTransactions(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 2) {
            context.push('/profile');
          }
        },
        items: const [
          BottomNavItem(
            label: 'Beranda',
            icon: Symbols.home,
            activeIcon: Symbols.home,
          ),
          BottomNavItem(
            label: 'Aktivitas',
            icon: Symbols.receipt_long,
            activeIcon: Symbols.receipt_long,
          ),
          BottomNavItem(
            label: 'Profil',
            icon: Symbols.person,
            activeIcon: Symbols.person,
          ),
        ],
      ),
    );
  }
}
