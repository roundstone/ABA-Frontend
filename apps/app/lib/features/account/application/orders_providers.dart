import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/orders_api.dart';
import '../domain/customer_order.dart';

final ordersApiProvider = Provider<OrdersApi>((ref) {
  return OrdersApi();
});

final orderFilterProvider = StateProvider<OrderStatus?>((ref) => null);
final orderSearchQueryProvider = StateProvider<String>((ref) => '');

final customerOrdersProvider = FutureProvider<List<CustomerOrder>>((ref) async {
  final api = ref.watch(ordersApiProvider);
  final filter = ref.watch(orderFilterProvider);
  final query = ref.watch(orderSearchQueryProvider);
  return api.getOrders(status: filter, query: query);
});

final customerOrderByIdProvider = FutureProvider.family<CustomerOrder, String>((ref, id) async {
  final api = ref.watch(ordersApiProvider);
  return api.getOrderById(id);
});
