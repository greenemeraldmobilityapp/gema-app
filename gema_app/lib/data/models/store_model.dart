class StoreModel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String? avatarUrl;
  final String? bannerUrl;
  final String category;
  final double rating;
  final int ratingCount;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool isOpen;
  final DateTime createdAt;

  const StoreModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    this.avatarUrl,
    this.bannerUrl,
    required this.category,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.address,
    this.latitude,
    this.longitude,
    this.isOpen = true,
    required this.createdAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      category: json['category'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] as int? ?? 0,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isOpen: json['is_open'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'description': description,
      'avatar_url': avatarUrl,
      'banner_url': bannerUrl,
      'category': category,
      'rating': rating,
      'rating_count': ratingCount,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'is_open': isOpen,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
