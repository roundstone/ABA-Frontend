import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_error.dart';
import '../domain/customer_order.dart';
import 'orders_mock_service.dart';

class OrdersApi {
  final Dio? _dio;
  final OrdersMockService _mock;

  OrdersApi([this._dio, OrdersMockService? mock])
      : _mock = mock ?? const OrdersMockService();

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
      return _mock.getOrders(
        page: page,
        limit: limit,
        search: search,
        startDate: startDate,
        endDate: endDate,
        status: status,
      );
    }

    try {
      final endpoint = ApiEndpoints.orders.list;
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (orderBy != null) 'orderBy': orderBy,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,
        if (endDate != null && endDate.isNotEmpty) 'endDate': endDate,
        if (status != null) 'status': status.apiValue,
      };

      AppLogger.d('GET $endpoint with params: $queryParams');
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      final rawData = response.data is Map ? response.data['data'] : null;

      List itemsList = [];
      Map<String, dynamic>? meta;
      if (rawData is Map) {
        if (rawData['data'] is List) itemsList = rawData['data'] as List;
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

      final totalPages = (meta?['totalPages'] as num?)?.toInt() ?? 1;
      final totalItems =
          (meta?['totalItems'] as num?)?.toInt() ?? orders.length;
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
      AppLogger.e('OrdersApi.getOrders unexpected error',
          error: e, stackTrace: stack);
      throw ApiError(
        success: false,
        statusCode: 500,
        message: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  Future<CustomerOrder> getOrderById(String id) async {
    if (AppConfig.isMockMode || _dio == null) {
      return _mock.getOrderById(id);
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
        statusCode: 404,
        message: 'Order not found in API response.',
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

  Future<bool> verifyPayment(String reference) async {
    if (AppConfig.isMockMode || _dio == null) {
      return _mock.verifyPayment(reference);
    }

    final endpoint = ApiEndpoints.payments.paystackVerify(reference);
    try {
      AppLogger.d('GET $endpoint (verify payment)');
      Response<dynamic> response;
      try {
        response = await _dio.get(endpoint);
      } catch (_) {
        response = await _dio.post(endpoint);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map) {
          final s = (data['data']?['status'] ?? data['status'])
              ?.toString()
              .toLowerCase();
          return s == 'successful' ||
              s == 'success' ||
              s == 'paid' ||
              s == 'true' ||
              data['success'] == true;
        }
        return true;
      }
      return false;
    } on DioException catch (e, stack) {
      AppLogger.e('OrdersApi.verifyPayment failed',
          error: e, stackTrace: stack);
      throw ApiError.fromDio(e);
    } catch (e, stack) {
      AppLogger.e('OrdersApi.verifyPayment error', error: e, stackTrace: stack);
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
      return _mock.cancelOrder(
        orderId: orderId,
        cancellationReason: cancellationReason,
      );
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
