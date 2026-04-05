import '../models/order_model.dart';
import '../remote/supabase_service.dart';

class OrderRepository {
  Future<OrderModel> createOrder({
    required String buyerId,
    required String storeId,
    required OrderType type,
    required PaymentMethod paymentMethod,
    required double totalItemPrice,
    required double shippingFee,
    required double appFee,
    required double totalAmount,
    String? destAddress,
    double? destLat,
    double? destLng,
    DateTime? scheduledAt,
  }) async {
    final response = await SupabaseService.client
        .from('orders')
        .insert({
          'buyer_id': buyerId,
          'store_id': storeId,
          'type': type.name,
          'status': OrderStatus.pending.name,
          'payment_method': paymentMethod.name,
          'total_item_price': totalItemPrice,
          'shipping_fee': shippingFee,
          'app_fee': appFee,
          'total_amount': totalAmount,
          'dest_address': destAddress,
          'dest_lat': destLat,
          'dest_lng': destLng,
          'scheduled_at': scheduledAt?.toIso8601String(),
        })
        .select()
        .single();

    return OrderModel.fromJson(response);
  }

  Future<void> addOrderItems({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    if (items.isEmpty) return;

    await SupabaseService.client
        .from('order_items')
        .insert(items.map((item) => {
              'order_id': orderId,
              'offering_id': item['offering_id'],
              'name': item['name'],
              'quantity': item['quantity'],
              'price': item['price'],
              'subtotal': item['subtotal'],
              'image_url': item['image_url'],
            }).toList());
  }

  Future<List<OrderModel>> getOrders({
    String? buyerId,
    OrderStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = SupabaseService.client
        .from('orders')
        .select('*, order_items(*)')
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    if (buyerId != null) {
      query = query.eq('buyer_id', buyerId);
    }
    if (status != null) {
      query = query.eq('status', status.name);
    }

    final response = await query;
    return (response as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }

  Future<OrderModel?> getOrderById(String id) async {
    final response = await SupabaseService.client
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', id)
        .single()
        .maybeSingle();

    if (response == null) return null;
    return OrderModel.fromJson(response);
  }

  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final response = await SupabaseService.client
        .from('orders')
        .update({'status': status.name, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', orderId)
        .select()
        .single();

    return OrderModel.fromJson(response);
  }

  Future<void> assignDriver({
    required String orderId,
    required String driverId,
    String? driverName,
    String? driverPhone,
  }) async {
    await SupabaseService.client
        .from('orders')
        .update({
          'driver_id': driverId,
          'driver_name': driverName,
          'driver_phone': driverPhone,
          'status': OrderStatus.driver_found.name,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId);
  }

  Stream<OrderModel?> streamOrder(String orderId) {
    return SupabaseService.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId)
        .map((data) {
          if (data.isEmpty) return null;
          return OrderModel.fromJson(data.first);
        });
  }
}
