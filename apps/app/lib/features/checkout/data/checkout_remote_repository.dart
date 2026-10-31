import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/checkout_entities.dart';
import '../domain/checkout_repository.dart';
import 'checkout_mock_repository.dart';
import 'checkout_remote_helpers.dart';

class CheckoutRemoteRepository implements CheckoutRepository {
  CheckoutRemoteRepository(this._dio, [CheckoutMockRepository? mock])
      : _mock = mock ?? CheckoutMockRepository();

  final Dio _dio;
  final CheckoutMockRepository _mock;

  @override
  Future<List<CheckoutAddress>> getSavedAddresses() async {
    try {
      final response = await _dio.get(ApiEndpoints.deliveryAddresses.base);
      final list = ApiResponse.unwrapList(response.data);
      return list.whereType<Map>().map((item) {
        final json = Map<String, dynamic>.from(item);
        return CheckoutAddress(
          id: (json['id'] ?? '').toString(),
          label: json['name'] as String? ??
              json['label'] as String? ??
              'Address',
          fullName: json['fullName'] as String? ?? '',
          street: json['street'] as String? ?? '',
          city: json['city'] as String? ?? '',
          state: json['state'] as String? ?? '',
          zipCode: (json['zip'] ?? json['zipCode'] ?? '').toString(),
          phone: (json['phone'] ?? '').toString(),
          isDefault: json['is_default'] == true || json['isDefault'] == true,
        );
      }).toList();
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w('CheckoutRemoteRepository.getSavedAddresses fallback: $e');
        return _mock.getSavedAddresses();
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.getSavedAddresses();
      rethrow;
    }
  }

  @override
  Future<List<DeliveryMethod>> getDeliveryMethods() async {
    try {
      final response = await _dio.get('/checkout/delivery-methods');
      final data = response.data['data'] as List<dynamic>?;
      if (data != null && data.isNotEmpty) {
        return data.map((json) {
          return DeliveryMethod(
            id: json['id'] as String,
            name: json['name'] as String,
            duration: json['duration'] as String,
            cost: (json['cost'] as num).toDouble(),
          );
        }).toList();
      }
    } catch (e) {
      AppLogger.w('CheckoutRemoteRepository.getDeliveryMethods: $e');
    }
    return _mock.getDeliveryMethods();
  }

  @override
  Future<List<ReferralCandidate>> searchReferrals(String query) async {
    try {
      final response = await _dio.get(
        '/referrals/lookup',
        queryParameters: {'query': query},
      );
      final data = response.data['data'] as List<dynamic>?;
      if (data != null) {
        return data.map((json) {
          return ReferralCandidate(
            id: json['id'] as String,
            name: json['name'] as String,
            moniker: json['moniker'] as String,
            code: json['code'] as String,
            imageUrl: json['imageUrl'] as String? ?? '',
          );
        }).toList();
      }
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.searchReferrals(query);
    }
    return const [];
  }

  @override
  Future<bool> verifyPaystackPayment(String reference) async {
    try {
      Response<dynamic> response;
      try {
        response =
            await _dio.get(ApiEndpoints.payments.paystackVerify(reference));
      } catch (_) {
        response =
            await _dio.post(ApiEndpoints.payments.paystackVerify(reference));
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
        AppLogger.w('CheckoutRemoteRepository.verifyPaystack fallback: $e');
        return _mock.verifyPaystackPayment(reference);
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.verifyPaystackPayment(reference);
      rethrow;
    }
  }

  @override
  Future<CheckoutOrderResult> placeOrder({
    required Cart cart,
    required CheckoutCustomerInfo customerInfo,
    required CheckoutAddress address,
    required DeliveryMethod deliveryMethod,
    required CheckoutPaymentType paymentType,
    ReferralCandidate? referral,
    String? paymentReference,
  }) async {
    final methodStr = paymentType == CheckoutPaymentType.paystack
        ? 'paystack'
        : paymentType.name;
    final payload = {
      'paymentReference': paymentReference,
      'payment_reference': paymentReference,
      'paymentMethod': methodStr,
      'payment_method': methodStr,
      'deliveryMethodId': deliveryMethod.id,
      'referralCode': referral?.code,
      'customer': {
        'firstName': customerInfo.firstName,
        'lastName': customerInfo.lastName,
        'email': customerInfo.email,
        'phone': customerInfo.phone,
      },
      'address': {
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'zipCode': address.zipCode,
        'phone': address.phone,
      },
      'items': cart.items.map((i) => {
        'productId': i.product.id,
        'productVariantId': i.effectiveVariantId,
        'quantity': i.quantity,
        'price': i.itemTotal,
        'color': i.selectedColor,
        'size': i.selectedSize,
      }).toList(),
    };

    try {
      Response<dynamic> response;
      try {
        response = await _dio.post(ApiEndpoints.orders.base, data: payload);
      } catch (_) {
        response = await _dio.post('/checkout/process', data: payload);
      }

      final unwrapped = ApiResponse.unwrapMap(response.data);
      return CheckoutRemoteHelpers.parseOrderResult(
        unwrapped: unwrapped,
        cart: cart,
        address: address,
        paymentType: paymentType,
      );
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w('CheckoutRemoteRepository.placeOrder fallback: $e');
        return _mock.placeOrder(
          cart: cart,
          customerInfo: customerInfo,
          address: address,
          deliveryMethod: deliveryMethod,
          paymentType: paymentType,
          referral: referral,
          paymentReference: paymentReference,
        );
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return _mock.placeOrder(
          cart: cart,
          customerInfo: customerInfo,
          address: address,
          deliveryMethod: deliveryMethod,
          paymentType: paymentType,
          referral: referral,
          paymentReference: paymentReference,
        );
      }
      rethrow;
    }
  }
}
