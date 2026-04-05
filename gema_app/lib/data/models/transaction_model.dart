enum TransactionType { income, expense }

enum TransactionStatus { pending, success, failed, refunded }

enum TransactionCategory {
  topup,
  transfer,
  payment,
  food,
  product,
  courier,
  service,
  refund,
}

class TransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final TransactionStatus status;
  final TransactionCategory category;
  final String? description;
  final String? merchantId;
  final String? merchantName;
  final String? merchantAvatarUrl;
  final String? referenceId;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.status,
    required this.category,
    this.description,
    this.merchantId,
    this.merchantName,
    this.merchantAvatarUrl,
    this.referenceId,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      amount: (json['amount'] as num).toDouble(),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TransactionCategory.payment,
      ),
      description: json['description'] as String?,
      merchantId: json['merchant_id'] as String?,
      merchantName: json['merchant_name'] as String?,
      merchantAvatarUrl: json['merchant_avatar_url'] as String?,
      referenceId: json['reference_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'amount': amount,
      'status': status.name,
      'category': category.name,
      'description': description,
      'merchant_id': merchantId,
      'merchant_name': merchantName,
      'merchant_avatar_url': merchantAvatarUrl,
      'reference_id': referenceId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get categoryLabel {
    switch (category) {
      case TransactionCategory.topup:
        return 'Top Up';
      case TransactionCategory.transfer:
        return 'Transfer';
      case TransactionCategory.payment:
        return 'Pembayaran';
      case TransactionCategory.food:
        return 'Makanan';
      case TransactionCategory.product:
        return 'Produk';
      case TransactionCategory.courier:
        return 'Kurir';
      case TransactionCategory.service:
        return 'Jasa';
      case TransactionCategory.refund:
        return 'Refund';
    }
  }

  String get statusLabel {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.success:
        return 'Berhasil';
      case TransactionStatus.failed:
        return 'Gagal';
      case TransactionStatus.refunded:
        return 'Dikembalikan';
    }
  }
}
