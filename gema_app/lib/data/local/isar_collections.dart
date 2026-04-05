enum OfferingType { product, service }
enum OrderType { food, marketplace, send, service }
enum OrderStatus {
  pending,
  searching_driver,
  driver_found,
  driver_to_merchant,
  picked_up,
  driver_to_customer,
  delivered,
  cancelled,
}
enum PaymentMethod { xendit, cod }

class CartItem {
  final int id;
  final String offeringId;
  final String storeId;
  final String name;
  final double price;
  int quantity;
  final String? imageUrl;
  final OfferingType type;

  CartItem({
    required this.id,
    required this.offeringId,
    required this.storeId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
    required this.type,
  });

  double get subtotal => price * quantity;
}

class IsarService {
  IsarService._();

  static final List<CartItem> _cartItems = [];

  static Future<void> initialize() async {
    // In-memory initialization
    // Full Isar setup requires build_runner code generation
  }

  static Future<List<CartItem>> getCartItems() async {
    return List.unmodifiable(_cartItems);
  }

  static Future<void> addToCart(CartItem item) async {
    final existingIndex = _cartItems.indexWhere(
      (i) => i.offeringId == item.offeringId,
    );
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
  }

  static Future<void> updateQuantity(int id, int quantity) async {
    if (quantity <= 0) {
      _cartItems.removeWhere((i) => i.id == id);
    } else {
      final item = _cartItems.firstWhere((i) => i.id == id);
      item.quantity = quantity;
    }
  }

  static Future<void> removeFromCart(int id) async {
    _cartItems.removeWhere((i) => i.id == id);
  }

  static Future<void> clearCart() async {
    _cartItems.clear();
  }

  static Future<void> clearAll() async {
    _cartItems.clear();
  }
}
