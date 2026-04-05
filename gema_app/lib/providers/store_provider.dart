import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/store_model.dart';
import '../../data/repositories/store_repository.dart';

final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) => StoreRepository(),
);

class StoreState {
  final List<StoreModel> stores;
  final StoreModel? selectedStore;
  final bool isLoading;
  final String? error;
  final List<String> categories;
  final String? selectedCategory;

  const StoreState({
    this.stores = const [],
    this.selectedStore,
    this.isLoading = false,
    this.error,
    this.categories = const [],
    this.selectedCategory,
  });

  StoreState copyWith({
    List<StoreModel>? stores,
    StoreModel? selectedStore,
    bool? isLoading,
    String? error,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return StoreState(
      stores: stores ?? this.stores,
      selectedStore: selectedStore ?? this.selectedStore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class StoreNotifier extends StateNotifier<StoreState> {
  final StoreRepository _repository;

  StoreNotifier(this._repository) : super(const StoreState()) {
    loadCategories();
  }

  Future<void> loadStores({bool refresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stores = await _repository.getStores(
        category: state.selectedCategory,
      );
      state = state.copyWith(stores: stores, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadStoreById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final store = await _repository.getStoreById(id);
      state = state.copyWith(
        selectedStore: store,
        isLoading: false,
        error: store == null ? 'Store not found' : null,
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
    loadStores();
  }

  Future<void> refresh() async {
    await loadStores(refresh: true);
  }
}

final storeNotifierProvider = StateNotifierProvider<StoreNotifier, StoreState>(
  (ref) => StoreNotifier(ref.watch(storeRepositoryProvider)),
);

final featuredStoresProvider = FutureProvider<List<StoreModel>>((ref) async {
  return ref.watch(storeRepositoryProvider).getFeaturedStores();
});
