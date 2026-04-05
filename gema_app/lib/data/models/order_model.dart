import 'offering_model.dart';

class OrderModel {
  final String id;
  final String buyerId;
  final String? driverId;
  final String storeId;
  final OrderType type;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final List<OrderItemModel> items;
  final double totalItemPrice;
  final double shippingFee;
  final double appFee;
  final double totalAmount;
  final String? destAddress;
  final double? destLat;
  final double? destLng;
  final DateTime? scheduledAt;
  final String? driverName;
  final String? driverPhone;
  final String? cancelledBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.buyerId,
    this.driverId,
    required this.storeId,
    required this.type,
    required this.status,
    required this.paymentMethod,
    this.items = const [],
    required this.totalItemPrice,
    this.shippingFee = 0.0,
    this.appFee = 0.0,
    required this.totalAmount,
    this.destAddress,
    this.destLat,
    this.destLng,
    this.scheduledAt,
    this.driverName,
    this.driverPhone,
    this.cancelledBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['order_items'];
    return OrderModel(
      id: json['id'] as String,
      buyerId: json['buyer_id'] as String,
      driverId: json['driver_id'] as String?,
      storeId: json['store_id'] as String,
      type: OrderType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => OrderType.marketplace,
      ),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['payment_method'],
        orElse: () => PaymentMethod.xendit,
      ),
      items: itemsJson != null
          ? (itemsJson as List)
              .map((item) => OrderItemModel.fromJson(item))
              .toList()
          : [],
      totalItemPrice: (json['total_item_price'] as num).toDouble(),
      shippingFee: (json['shipping_fee'] as num?)?.toDouble() ?? 0.0,
      appFee: (json['app_fee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      destAddress: json['dest_address'] as String?,
      destLat: (json['dest_lat'] as num?)?.toDouble(),
      destLng: (json['dest_lng'] as num?)?.toDouble(),
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'] as String)
          : null,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      cancelledBy: json['cancelled_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'driver_id': driverId,
      'store_id': storeId,
      'type': type.name,
      'status': status.name,
      'payment_method': paymentMethod.name,
      'total_item_price': totalItemPrice,
      'shipping_fee': shippingFee,
      'app_fee': appFee,
      'total_amount': totalAmount,
      'dest_address': destAddress,
      'dest_lat': destLat,
      'dest_lng': destLng,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'cancelled_by': cancelledBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Menunggu Driver';
      case OrderStatus.searching_driver:
        return 'Mencari Driver';
      case OrderStatus.driver_found:
        return 'Driver Ditemukan';
      case OrderStatus.driver_to_merchant:
        return 'Driver Menuju Toko';
      case OrderStatus.picked_up:
        return 'Barang Diambil';
      case OrderStatus.driver_to_customer:
        return 'Menuju Lokasi Anda';
      case OrderStatus.delivered:
        return 'Terkirim';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  String get typeLabel {
    switch (type) {
      case OrderType.food:
        return 'Makanan';
      case OrderType.marketplace:
        return 'Marketplace';
      case OrderType.send:
        return 'Kurir';
      case OrderType.service:
        return 'Jasa';
    }
  }
}

class OrderItemModel {
  final String id;
  final String orderId;
  final String offeringId;
  final String name;
  final int quantity;
  final double price;
  final double subtotal;
  final String? imageUrl;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.offeringId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      offeringId: json['offering_id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'offering_id': offeringId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
      'image_url': imageUrl,
    };
  }
}

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
