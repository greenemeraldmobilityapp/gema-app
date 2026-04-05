class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final String? address;
  final double walletBalance;
  final bool isMerchant;
  final String? merchantId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.avatarUrl,
    this.address,
    this.walletBalance = 0.0,
    this.isMerchant = false,
    this.merchantId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      address: json['address'] as String?,
      walletBalance: (json['wallet_balance'] as num?)?.toDouble() ?? 0.0,
      isMerchant: json['is_merchant'] as bool? ?? false,
      merchantId: json['merchant_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'address': address,
      'wallet_balance': walletBalance,
      'is_merchant': isMerchant,
      'merchant_id': merchantId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? address,
    double? walletBalance,
    bool? isMerchant,
    String? merchantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      walletBalance: walletBalance ?? this.walletBalance,
      isMerchant: isMerchant ?? this.isMerchant,
      merchantId: merchantId ?? this.merchantId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName => fullName ?? email.split('@').first;

  String get initials {
    if (fullName == null || fullName!.isEmpty) {
      return email.substring(0, 1).toUpperCase();
    }
    final parts = fullName!.trim().split(' ');
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'.toUpperCase();
  }
}
