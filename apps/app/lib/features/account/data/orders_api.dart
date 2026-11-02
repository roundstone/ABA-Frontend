import 'dart:math';
import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_error.dart';
import '../domain/customer_order.dart';
import 'orders_mock_data.dart';

class OrdersApi {
  final Dio? _dio;

  OrdersApi([this._dio]);

  Future<PaginatedOrdersResult> getOrders({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
    OrderStatus? status,
  }) async {
    if (AppConfig.isMockMode || _dio == null) {
      await Future.delayed(const Duration(milliseconds: 300));
      var orders =
          mockOrders.map((json) => CustomerOrder.fromJson(json)).toList();

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
          final matchItem = o.items.any((i) => i.productName.toLowerCase().contains(q));
          return matchId || matchItem;
        }).toList();
      }

      final total = orders.length;
      final pages = (total / limit).ceil().clamp(1, 999);
      final start = (page - 1) * limit;
      final paged = start >= total
          ? <CustomerOrder>[]
          : orders.sublist(start, min(start + limit, total));

      return PaginatedOrdersResult(
        orders: paged,
        totalItems: total,
        totalPages: pages,
        currentPage: page,
        hasNext: page < pages,
      );
    }

    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,
        if (endDate != null && endDate.isNotEmpty) 'endDate': endDate,
        if (orderBy != null && orderBy.isNotEmpty) 'orderBy': orderBy,
      };

      AppLogger.d('GET ${ApiEndpoints.orders.list} with $queryParams');
      final response = await _dio.get(
        ApiEndpoints.orders.list,
        queryParameters: queryParams,
      );

      final body = response.data;
      final rawData = body is Map ? body['data'] : null;

      List itemsList = [];
      Map<String, dynamic>? meta;
      if (rawData is Map) {
        if (rawData['data'] is List) itemsList = rawData['data'] as List;
        if (rawData['meta'] is Map) meta = rawData['meta'] as Map<String, dynamic>;
      } else if (rawData is List) {
        itemsList = rawData;
      }

      var orders = itemsList
          .whereType<Map<String, dynamic>>()
          .map((json) => CustomerOrder.fromJson(json))
          .toList();

      if (status != null) orders = orders.where((o) => o.status == status).toList();

      final totalPages = (meta?['totalPages'] as num?)?.toInt() ?? 1;
      final totalItems = (meta?['totalItems'] as num?)?.toInt() ?? orders.length;
      final currentPage = (meta?['currentPage'] as num?)?.toInt() ?? page;
      final hasNext = meta?['nextPageUrl'] != null || currentPage < totalPages;

      return PaginatedOrdersResult(
        orders: orders,
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: currentPage,
        hasNext: hasNext,
      );
    } on DioException catch (e, stack) {
      AppLogger.e('OrdersApi.getOrders failed', error: e, stackTrace: stack);
      throw ApiError.fromDio(e);
    } catch (e, stack) {
      AppLogger.e('OrdersApi.getOrders unexpected error', error: e, stackTrace: stack);
      throw ApiError(
        success: false,
        statusCode: 500,
        message: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  Future<CustomerOrder> getOrderById(String id) async {
    if (AppConfig.isMockMode || _dio == null) {
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

    try {
      final endpoint = ApiEndpoints.orders.byId(id);
      AppLogger.d('GET $endpoint');
      final response = await _dio.get(endpoint);
      final rawData = response.data is Map ? response.data['data'] : null;

      if (rawData is Map<String, dynamic>) {
        return CustomerOrder.fromJson(rawData);
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Invalid order data returned by server.',
      );
    } on DioException catch (e, stack) {
      AppLogger.e('OrdersApi.getOrderById failed', error: e, stackTrace: stack);
      throw ApiError.fromDio(e);
    } catch (e, stack) {
      AppLogger.e('OrdersApi.getOrderById error', error: e, stackTrace: stack);
      throw ApiError(
        success: false,
        statusCode: 500,
        message: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  Future<CustomerOrder> cancelOrder({
    required String orderId,
    required String cancellationReason,
  }) async {
    if (AppConfig.isMockMode || _dio == null) {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = mockOrders.indexWhere(
        (j) => j['id']?.toString() == orderId || j['order_number']?.toString() == orderId,
      );
      if (index >= 0) {
        final updated = Map<String, dynamic>.from(mockOrders[index]);
        updated['status'] = 'cancelled';
        updated['cancellation_reason'] = cancellationReason;
        mockOrders[index] = updated;
        return CustomerOrder.fromJson(updated);
      }
      throw const ApiError(success: false, statusCode: 404, message: 'Order not found.');
    }

    try {
      final endpoint = ApiEndpoints.orders.cancel;
      final payload = {
        'order_id': int.tryParse(orderId) ?? orderId,
        'orderId': int.tryParse(orderId) ?? orderId,
        'id': int.tryParse(orderId) ?? orderId,
        'cancellation_reason': cancellationReason,
        'reason': cancellationReason,
      };

      AppLogger.d('POST $endpoint with $payload');
      final response = await _dio.post(endpoint, data: payload);
      final rawData = response.data is Map ? response.data['data'] : null;
      if (rawData is Map<String, dynamic>) {
        return CustomerOrder.fromJson(rawData);
      }
      return getOrderById(orderId);
    } on DioException catch (e, stack) {
      AppLogger.e('OrdersApi.cancelOrder failed', error: e, stackTrace: stack);
      throw ApiError.fromDio(e);
    } catch (e, stack) {
      AppLogger.e('OrdersApi.cancelOrder error', error: e, stackTrace: stack);
      throw ApiError(
        success: false,
        statusCode: 500,
        message: ApiError.toUserFriendlyMessage(e),
      );
    }
  }
}
