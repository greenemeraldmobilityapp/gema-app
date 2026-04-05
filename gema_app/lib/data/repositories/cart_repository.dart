import '../local/isar_collections.dart';
import '../models/offering_model.dart';

class CartRepository {
  final IsarService _isarService;
  int _nextId = 1;

  CartRepository(this._isarService);

  Future<List<CartItem>> getAll() async {
    return await _isarService.getCartItems();
  }

  Future<void> addToCart({
    required String offeringId,
    required String storeId,
    required String name,
    required double price,
    required OfferingType type,
    String? imageUrl,
  }) async {
    final existing = (await _isarService.getCartItems())
        .where((i) => i.offeringId == offeringId)
        .toList();

    if (existing.isNotEmpty) {
      existing.first.quantity += 1;
    } else {
      await _isarService.addToCart(CartItem(
        id: _nextId++,
        offeringId: offeringId,
        storeId: storeId,
        name: name,
        price: price,
        quantity: 1,
        imageUrl: imageUrl,
        type: type,
      ));
    }
  }

  Future<void> updateQuantity(int id, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(id);
      return;
    }
    await _isarService.updateQuantity(id, quantity);
  }

  Future<void> incrementQuantity(int id) async {
    final items = await _isarService.getCartItems();
    final item = items.firstWhere((i) => i.id == id);
    await _isarService.updateQuantity(id, item.quantity + 1);
  }

  Future<void> decrementQuantity(int id) async {
    final items = await _isarService.getCartItems();
    final item = items.firstWhere((i) => i.id == id);
    if (item.quantity <= 1) {
      await removeFromCart(id);
    } else {
      await _isarService.updateQuantity(id, item.quantity - 1);
    }
  }

  Future<void> removeFromCart(int id) async {
    await _isarService.removeFromCart(id);
  }

  Future<void> clearCart() async {
    await _isarService.clearCart();
  }

  Future<void> clearCartByStore(String storeId) async {
    final items = await _isarService.getCartItems();
    for (final item in items.where((i) => i.storeId == storeId)) {
      await _isarService.removeFromCart(item.id);
    }
  }

  Future<double> getTotal() async {
    final items = await getAll();
    return items.fold<double>(0, (sum, item) => sum + item.subtotal);
  }

  Future<int> getItemCount() async {
    final items = await getAll();
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  Future<bool> isEmpty() async {
    final items = await getAll();
    return items.isEmpty;
  }

  Future<bool> hasItemsFromStore(String storeId) async {
    final items = await getAll();
    return items.any((i) => i.storeId == storeId);
  }

  Future<String?> getCartStoreId() async {
    final items = await getAll();
    if (items.isEmpty) return null;
    return items.first.storeId;
  }
}
