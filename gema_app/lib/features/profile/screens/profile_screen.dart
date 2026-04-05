import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      appBar: const GlassAppBar(title: 'Profil'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _ProfileHeader(user: user),
              const SizedBox(height: 24),
              _ProfileMenu(
                items: [
                  _MenuItem(
                    icon: Symbols.account_circle,
                    label: 'Edit Profil',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Dompet & Pembayaran',
                    onTap: () => context.push('/wallet'),
                  ),
                  _MenuItem(
                    icon: Symbols.location_on,
                    label: 'Alamat Tersimpan',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Symbols.security,
                    label: 'Keamanan',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Symbols.notifications,
                    label: 'Notifikasi',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Symbols.help,
                    label: 'Pusat Bantuan',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Symbols.info,
                    label: 'Tentang GEMA',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Keluar',
                isFullWidth: true,
                onPressed: () => _showLogoutDialog(context, ref),
              ),
              const SizedBox(height: 16),
              Text(
                'GEMA v1.0.0',
                style: AppTypography.caption.copyWith(
                  color: AppColors.onSurfaceVariantLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Keluar',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTypography.labelLg.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              'Keluar',
              style: AppTypography.labelLg.copyWith(
                color: AppColors.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              user?.initials ?? '?',
              style: AppTypography.displayMd.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.displayName ?? 'Pengguna',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              if (user?.phone != null) ...[
                const SizedBox(height: 2),
                Text(
                  user!.phone!,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariantLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final List<_MenuItem> items;

  const _ProfileMenu({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: items
            .asMap()
            .entries
            .map(
              (entry) => Column(
                children: [
                  _MenuItemTile(item: entry.value),
                  if (entry.key < items.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Divider(
                        color: AppColors.divider,
                        height: 1,
                      ),
                    ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _MenuItemTile extends StatelessWidget {
  final _MenuItem item;

  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        item.icon,
        size: 22,
        color: AppColors.onSurfaceVariant,
        fill: 0,
        weight: 300,
      ),
      title: Text(
        item.label,
        style: AppTypography.bodyMdMedium.copyWith(
          color: AppColors.onSurface,
        ),
      ),
      trailing: const Icon(
        Symbols.chevron_right,
        size: 20,
        color: AppColors.onSurfaceVariantLight,
      ),
      onTap: item.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
