import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/remote/supabase_service.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepository(),
);

class OrderState {
  final List<OrderModel> orders;
  final OrderModel? selectedOrder;
  final bool isLoading;
  final String? error;
  final bool isCreating;

  const OrderState({
    this.orders = const [],
    this.selectedOrder,
    this.isLoading = false,
    this.error,
    this.isCreating = false,
  });

  OrderState copyWith({
    List<OrderModel>? orders,
    OrderModel? selectedOrder,
    bool? isLoading,
    String? error,
    bool? isCreating,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isCreating: isCreating ?? this.isCreating,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _repository;

  OrderNotifier(this._repository) : super(const OrderState());

  Future<void> loadOrders() async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final orders = await _repository.getOrders(buyerId: userId);
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<OrderModel?> createOrder({
    required String storeId,
    required OrderType type,
    required PaymentMethod paymentMethod,
    required double totalItemPrice,
    required double shippingFee,
    required double appFee,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
    String? destAddress,
    double? destLat,
    double? destLng,
  }) async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) return null;

    state = state.copyWith(isCreating: true, error: null);
    try {
      final order = await _repository.createOrder(
        buyerId: userId,
        storeId: storeId,
        type: type,
        paymentMethod: paymentMethod,
        totalItemPrice: totalItemPrice,
        shippingFee: shippingFee,
        appFee: appFee,
        totalAmount: totalAmount,
        destAddress: destAddress,
        destLat: destLat,
        destLng: destLng,
      );

      await _repository.addOrderItems(orderId: order.id, items: items);

      state = state.copyWith(isCreating: false);
      return order;
    } catch (e) {
      state = state.copyWith(isCreating: false, error: e.toString());
      return null;
    }
  }

  Future<void> loadOrderById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final order = await _repository.getOrderById(id);
      state = state.copyWith(selectedOrder: order, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      await _repository.updateOrderStatus(orderId: orderId, status: status);
      await loadOrderById(orderId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadOrders();
  }
}

final orderNotifierProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(ref.watch(orderRepositoryProvider)),
);
