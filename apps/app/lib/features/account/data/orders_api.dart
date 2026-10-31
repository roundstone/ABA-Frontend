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
          final startOfDay = DateTime(start.year, start.month, start.day);
          orders = orders.where((o) => !o.date.isBefore(startOfDay)).toList();
        }
      }
      if (endDate != null && endDate.isNotEmpty) {
        final end = DateTime.tryParse(endDate);
        if (end != null) {
          final endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59);
          orders = orders.where((o) => !o.date.isAfter(endOfDay)).toList();
        }
      }
      if (search != null && search.trim().isNotEmpty) {
        final lowerQuery = search.trim().toLowerCase();
        orders = orders.where((o) {
          final matchesId = o.id.toLowerCase().contains(lowerQuery) ||
              o.orderNumber.toLowerCase().contains(lowerQuery);
          final matchesItems = o.items.any(
            (item) => item.productName.toLowerCase().contains(lowerQuery),
          );
          return matchesId || matchesItems;
        }).toList();
      }

      final totalItems = orders.length;
      final totalPages = (totalItems / limit).ceil().clamp(1, 999);
      final startIndex = (page - 1) * limit;
      final pagedOrders = startIndex >= totalItems
          ? <CustomerOrder>[]
          : orders.sublist(
              startIndex,
              min(startIndex + limit, totalItems),
            );

      return PaginatedOrdersResult(
        orders: pagedOrders,
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: page,
        hasNext: page < totalPages,
      );
    }

    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.trim().isNotEmpty)
          'search': search.trim(),
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
        if (rawData['data'] is List) {
          itemsList = rawData['data'] as List;
        }
        if (rawData['meta'] is Map) {
          meta = rawData['meta'] as Map<String, dynamic>;
        }
      } else if (rawData is List) {
        itemsList = rawData;
      }

      var orders = itemsList
          .whereType<Map<String, dynamic>>()
          .map((json) => CustomerOrder.fromJson(json))
          .toList();

      if (status != null) {
        orders = orders.where((o) => o.status == status).toList();
      }
      if (startDate != null && startDate.isNotEmpty) {
        final start = DateTime.tryParse(startDate);
        if (start != null) {
          final startOfDay = DateTime(start.year, start.month, start.day);
          orders = orders.where((o) => !o.date.isBefore(startOfDay)).toList();
        }
      }
      if (endDate != null && endDate.isNotEmpty) {
        final end = DateTime.tryParse(endDate);
        if (end != null) {
          final endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59);
          orders = orders.where((o) => !o.date.isAfter(endOfDay)).toList();
        }
      }

      final totalPages = (meta?['totalPages'] as num?)?.toInt() ?? 1;
      final totalItems = (meta?['totalItems'] as num?)?.toInt() ?? orders.length;
      final currentPage = (meta?['currentPage'] as num?)?.toInt() ?? page;
      final hasNext =
          meta?['nextPageUrl'] != null || currentPage < totalPages;

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
        (json) =>
            json['id']?.toString() == id ||
            json['order_number']?.toString() == id,
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
      final body = response.data;
      final rawData = body is Map ? body['data'] : null;

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
      AppLogger.e('OrdersApi.getOrderById unexpected error', error: e, stackTrace: stack);
      throw ApiError(
        success: false,
        statusCode: 500,
        message: ApiError.toUserFriendlyMessage(e),
      );
    }
  }
}
