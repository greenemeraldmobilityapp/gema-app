import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/isar_collections.dart';
import '../../data/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepository(IsarService.instance),
);

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  double get total => items.fold<double>(0, (sum, item) => sum + item.subtotal);
  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  String? get storeId => items.isNotEmpty ? items.first.storeId : null;
  bool get hasMultipleStores {
    if (items.isEmpty) return false;
    final firstStoreId = items.first.storeId;
    return items.any((item) => item.storeId != firstStoreId);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repository;

  CartNotifier(this._repository) : super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true);
    try {
      final items = await _repository.getAll();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addToCart({
    required String offeringId,
    required String storeId,
    required String name,
    required double price,
    required OfferingType type,
    String? imageUrl,
  }) async {
    try {
      await _repository.addToCart(
        offeringId: offeringId,
        storeId: storeId,
        name: name,
        price: price,
        type: type,
        imageUrl: imageUrl,
      );
      await _loadCart();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateQuantity(int id, int quantity) async {
    try {
      await _repository.updateQuantity(id, quantity);
      await _loadCart();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> incrementQuantity(int id) async {
    try {
      await _repository.incrementQuantity(id);
      await _loadCart();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> decrementQuantity(int id) async {
    try {
      await _repository.decrementQuantity(id);
      await _loadCart();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> removeFromCart(int id) async {
    try {
      await _repository.removeFromCart(id);
      await _loadCart();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> clearCart() async {
    try {
      await _repository.clearCart();
      await _loadCart();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> refresh() async {
    await _loadCart();
  }
}

final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(ref.watch(cartRepositoryProvider)),
);

final cartTotalProvider = Provider<double>(
  (ref) => ref.watch(cartNotifierProvider).total,
);

final cartItemCountProvider = Provider<int>(
  (ref) => ref.watch(cartNotifierProvider).itemCount,
);
