import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(),
);

class ProductState {
  final List<ProductModel> products;
  final ProductModel? selectedProduct;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasReachedMax;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;

  const ProductState({
    this.products = const [],
    this.selectedProduct,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasReachedMax = false,
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = '',
  });

  ProductState copyWith({
    List<ProductModel>? products,
    ProductModel? selectedProduct,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasReachedMax,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductState(
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repository;
  int _offset = 0;
  static const int _limit = 20;

  ProductNotifier(this._repository) : super(const ProductState()) {
    loadCategories();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _offset = 0;
      state = state.copyWith(isLoading: true, error: null, hasReachedMax: false);
    } else if (state.isLoadingMore || state.hasReachedMax) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      final products = await _repository.getProducts(
        category: state.selectedCategory,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
        limit: _limit,
        offset: _offset,
      );

      if (products.length < _limit) {
        state = state.copyWith(
          products: refresh ? products : [...state.products, ...products],
          isLoading: false,
          isLoadingMore: false,
          hasReachedMax: true,
          error: null,
        );
      } else {
        _offset += _limit;
        state = state.copyWith(
          products: refresh ? products : [...state.products, ...products],
          isLoading: false,
          isLoadingMore: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadProductById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final product = await _repository.getProductById(id);
      state = state.copyWith(
        selectedProduct: product,
        isLoading: false,
        error: product == null ? 'Product not found' : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadCategories() async {
    try {
      final categories = await _repository.getCategories();
      state = state.copyWith(categories: categories);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    loadProducts(refresh: true);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadProducts(refresh: true);
  }

  Future<void> refresh() async {
    await loadProducts(refresh: true);
  }

  Future<void> loadMore() async {
    await loadProducts(refresh: false);
  }
}

final productNotifierProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(ref.watch(productRepositoryProvider)),
);

final featuredProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(productRepositoryProvider).getFeaturedProducts();
});
