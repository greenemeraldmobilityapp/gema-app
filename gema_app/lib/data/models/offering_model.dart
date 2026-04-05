class CartItemModel {
  final String id;
  final String offeringId;
  final String storeId;
  final String storeName;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final OfferingType type;

  const CartItemModel({
    required this.id,
    required this.offeringId,
    required this.storeId,
    required this.storeName,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
    required this.type,
  });

  double get subtotal => price * quantity;

  CartItemModel copyWith({
    String? id,
    String? offeringId,
    String? storeId,
    String? storeName,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    OfferingType? type,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      offeringId: offeringId ?? this.offeringId,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
    );
  }
}

class OfferingModel {
  final String id;
  final String storeId;
  final String? providerId;
  final OfferingType type;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final double rating;
  final int ratingCount;
  final int soldCount;
  final bool isAvailable;
  final bool isNegotiable;
  final DateTime createdAt;

  const OfferingModel({
    required this.id,
    required this.storeId,
    this.providerId,
    required this.type,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrls = const [],
    this.rating = 0.0,
    this.ratingCount = 0,
    this.soldCount = 0,
    this.isAvailable = true,
    this.isNegotiable = false,
    required this.createdAt,
  });

  factory OfferingModel.fromJson(Map<String, dynamic> json) {
    final images = json['image_urls'];
    return OfferingModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      providerId: json['provider_id'] as String?,
      type: OfferingType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => OfferingType.product,
      ),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrls: images != null
          ? List<String>.from(images as List)
          : [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] as int? ?? 0,
      soldCount: json['sold_count'] as int? ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      isNegotiable: json['is_negotiable'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'provider_id': providerId,
      'type': type.name,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image_urls': imageUrls,
      'rating': rating,
      'rating_count': ratingCount,
      'sold_count': soldCount,
      'is_available': isAvailable,
      'is_negotiable': isNegotiable,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';
  String get typeLabel => type == OfferingType.product ? 'Produk' : 'Jasa';
}

enum OfferingType { product, service }
