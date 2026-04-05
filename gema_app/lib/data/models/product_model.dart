class ProductModel {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final double rating;
  final int ratingCount;
  final int soldCount;
  final bool isAvailable;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrls = const [],
    this.rating = 0.0,
    this.ratingCount = 0,
    this.soldCount = 0,
    this.isAvailable = true,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final images = json['image_urls'];
    return ProductModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
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
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image_urls': imageUrls,
      'rating': rating,
      'rating_count': ratingCount,
      'sold_count': soldCount,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';
}
