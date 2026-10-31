import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import '../domain/payment_gateway.dart';

/// Paystack implementation of [PaymentGatewayService].
/// Decoupled from checkout UI; calls ABA backend payment endpoints.
class PaystackGatewayService implements PaymentGatewayService {
  PaystackGatewayService(this._dio);

  final Dio _dio;

  @override
  PaymentGatewayType get type => PaymentGatewayType.paystack;

  @override
  Future<GatewayPaymentInitResult> initializePayment({
    required dynamic orderId,
    required double amount,
    required String email,
    Map<String, dynamic>? extra,
  }) async {
    final endpoint = ApiEndpoints.payments.paystackInitialize(orderId);
    final payload = {
      'amount': amount,
      'email': email,
      ...?extra,
    };

    try {
      final response = await _dio.post(endpoint, data: payload);
      final raw = response.data;
      if (raw is Map<String, dynamic>) {
        return GatewayPaymentInitResult.fromJson(raw);
      }
      final unwrapped = ApiResponse.unwrapMap(raw);
      return GatewayPaymentInitResult.fromJson(unwrapped);
    } on DioException catch (e) {
      AppLogger.e('PaystackGatewayService.initializePayment failed: $e');
      if (AppConfig.isMockMode) {
        return GatewayPaymentInitResult(
          authorizationUrl: 'https://checkout.paystack.com/mock-checkout-$orderId',
          reference: 'PSK-mock-${DateTime.now().millisecondsSinceEpoch}',
          orderId: orderId,
          amount: amount,
          status: 'pending',
        );
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return GatewayPaymentInitResult(
          authorizationUrl: 'https://checkout.paystack.com/mock-checkout-$orderId',
          reference: 'PSK-mock-${DateTime.now().millisecondsSinceEpoch}',
          orderId: orderId,
          amount: amount,
          status: 'pending',
        );
      }
      rethrow;
    }
  }

  @override
  Future<bool> verifyPayment(String reference) async {
    final endpoint = ApiEndpoints.payments.paystackVerify(reference);
    try {
      Response<dynamic> response;
      try {
        response = await _dio.get(endpoint);
      } catch (_) {
        response = await _dio.post(endpoint);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map) {
          final status = (data['data']?['status'] ?? data['status'])
              ?.toString()
              .toLowerCase();
          return status == 'successful' ||
              status == 'success' ||
              status == 'paid' ||
              status == 'true' ||
              data['success'] == true;
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w('PaystackGatewayService.verifyPayment fallback: $e');
        return true;
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return true;
      rethrow;
    }
  }
}

