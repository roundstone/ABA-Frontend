import '../../../core/network/api_error.dart';
import '../domain/customer_order.dart';
import 'orders_mock_data.dart';

class OrdersMockService {
  const OrdersMockService();

  Future<PaginatedOrdersResult> getOrders({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    OrderStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var orders = mockOrders.map((json) => CustomerOrder.fromJson(json)).toList();

    if (status != null) {
      orders = orders.where((o) => o.status == status).toList();
    }
    if (startDate != null && startDate.isNotEmpty) {
      final start = DateTime.tryParse(startDate);
      if (start != null) {
        final startDay = DateTime(start.year, start.month, start.day);
        orders = orders.where((o) => !o.date.isBefore(startDay)).toList();
      }
    }
    if (endDate != null && endDate.isNotEmpty) {
      final end = DateTime.tryParse(endDate);
      if (end != null) {
        final endDay = DateTime(end.year, end.month, end.day, 23, 59, 59);
        orders = orders.where((o) => !o.date.isAfter(endDay)).toList();
      }
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      orders = orders.where((o) {
        final matchId = o.id.toLowerCase().contains(q) ||
            o.orderNumber.toLowerCase().contains(q);
        final matchItem =
            o.items.any((i) => i.productName.toLowerCase().contains(q));
        return matchId || matchItem;
      }).toList();
    }

    final total = orders.length;
    final pages = (total / limit).ceil().clamp(1, 999);
    final start = (page - 1) * limit;
    final paged = start >= total
        ? <CustomerOrder>[]
        : orders.skip(start).take(limit).toList();

    return PaginatedOrdersResult(
      orders: paged,
      totalItems: total,
      totalPages: pages,
      currentPage: page,
      hasNext: page < pages,
    );
  }

  Future<CustomerOrder> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final orderJson = mockOrders.firstWhere(
      (j) => j['id']?.toString() == id || j['order_number']?.toString() == id,
      orElse: () => throw const ApiError(
        success: false,
        statusCode: 404,
        message: 'Order not found.',
      ),
    );
    return CustomerOrder.fromJson(orderJson);
  }

  Future<bool> verifyPayment(String reference) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final o in mockOrders) {
      final pList = o['payments'];
      if (pList is List) {
        for (final p in pList) {
          if (p is Map && p['reference'] == reference) {
            p['status'] = 'success';
            p['paid_at'] = DateTime.now().toIso8601String();
            o['status'] = 'pending';
            return true;
          }
        }
      }
    }
    return true;
  }

  Future<CustomerOrder> cancelOrder({
    required String orderId,
    required String cancellationReason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = mockOrders.indexWhere(
      (j) =>
          j['id']?.toString() == orderId ||
          j['order_number']?.toString() == orderId,
    );
    if (index >= 0) {
      final updated = Map<String, dynamic>.from(mockOrders[index]);
      updated['status'] = 'cancelled';
      updated['cancellation_reason'] = cancellationReason;
      mockOrders[index] = updated;
      return CustomerOrder.fromJson(updated);
    }
    throw const ApiError(
      success: false,
      statusCode: 404,
      message: 'Order not found.',
    );
  }
}
