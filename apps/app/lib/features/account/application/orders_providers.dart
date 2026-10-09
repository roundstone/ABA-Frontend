import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/orders_api.dart';
import '../domain/customer_order.dart';

final ordersApiProvider = Provider<OrdersApi>((ref) {
  return OrdersApi();
});

final customerOrdersProvider = FutureProvider<List<CustomerOrder>>((ref) async {
  final api = ref.watch(ordersApiProvider);
  return api.getOrders();
});

final customerOrderByIdProvider = FutureProvider.family<CustomerOrder, String>((ref, id) async {
  final api = ref.watch(ordersApiProvider);
  return api.getOrderById(id);
});
