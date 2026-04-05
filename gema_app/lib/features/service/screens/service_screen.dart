import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/service_card.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final _searchController = TextEditingController();

  final List<ServiceCategory> _categories = [
    ServiceCategory(label: 'Tukang Ukir', icon: Symbols.brush, isActive: true),
    ServiceCategory(label: 'Servis AC', icon: Symbols.ac_unit),
    ServiceCategory(label: 'Jasa Angkut', icon: Symbols.local_shipping),
    ServiceCategory(label: 'Pipa & Ledeng', icon: Symbols.plumbing),
    ServiceCategory(label: 'Elektrik', icon: Symbols.bolt),
    ServiceCategory(label: 'Tangan Ahli', icon: Symbols.handshake),
  ];

  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'Mbah Karso Ukir',
      'description': 'Pengrajin ukir kayu tradisional dengan pengalaman 30 tahun. Spesialis motif klasik Jepara.',
      'category': 'Tukang Ukir',
      'rating': 4.9,
      'experience': '30 tahun pengalaman',
      'startingPrice': 150000,
      'imageUrl': null,
    },
    {
      'id': '2',
      'name': 'Berkah Mandiri AC',
      'description': 'Servis AC profesional bergaransi 1 bulan. Tersedia cuci AC, tambah freon, dan perbaikan.',
      'category': 'Servis AC',
      'rating': 4.7,
      'experience': 'Garansi 1 bulan',
      'startingPrice': 75000,
      'imageUrl': null,
    },
    {
      'id': '3',
      'name': 'Jaya Logistik Jepara',
      'description': 'Jasa angkut dan pindahan dengan armada lengkap. Siap 24 jam untuk area Jepara.',
      'category': 'Jasa Angkut',
      'rating': 4.8,
      'experience': 'Armada 24 jam',
      'startingPrice': 120000,
      'imageUrl': null,
    },
    {
      'id': '4',
      'name': 'Putra Setrum',
      'description': 'Instalasi dan perbaikan kelistrikan rumah. Harga per titik, material bisa disediakan.',
      'category': 'Elektrik',
      'rating': 4.6,
      'experience': 'Rp50rb/titik',
      'startingPrice': 50000,
      'imageUrl': null,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _categories[_selectedCategoryIndex];
    final filteredProviders = _providers.where((p) {
      if (_selectedCategoryIndex == 0) return true;
      return p['category'] == selectedCategory.label;
    }).toList();

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
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Layanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 40),
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
                    'Layanan Lokal Jepara',
                    style: AppTypography.displayMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Temukan pengrajin dan teknisi terpercaya di wilayah Anda',
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SearchInput(
                    controller: _searchController,
                    hintText: 'Cari layanan...',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = index == _selectedCategoryIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.secondaryContainer
                                  : AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  category.icon,
                                  size: 18,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                  fill: isSelected ? 1 : 0,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  category.label,
                                  style: AppTypography.labelMd.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
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
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          if (filteredProviders.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.only(top: 40),
              sliver: SliverToBoxAdapter(
                child: EmptyState(
                  icon: Symbols.construction,
                  title: 'Tidak Ada Layanan',
                  message: 'Belum ada penyedia layanan untuk kategori ini',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final provider = filteredProviders[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ServiceCard(
                        id: provider['id'],
                        name: provider['name'],
                        description: provider['description'],
                        category: provider['category'],
                        rating: provider['rating'],
                        experience: provider['experience'],
                        startingPrice: provider['startingPrice'],
                        imageUrl: provider['imageUrl'],
                        onBook: () {},
                      ),
                    );
                  },
                  childCount: filteredProviders.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
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
                            'Ingin Menjadi Mitra Kami?',
                            style: AppTypography.headlineSm.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Daftarkan keahlian Anda dan dapatkan pelanggan dari seluruh Jepara.',
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
                              'Daftar Sebagai Mitra',
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
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Symbols.handshake,
                        size: 32,
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

class ServiceCategory {
  final String label;
  final IconData icon;
  final bool isActive;

  const ServiceCategory({
    required this.label,
    required this.icon,
    this.isActive = false,
  });
}
