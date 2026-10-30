import 'package:dio/dio.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../account/domain/customer_order.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/checkout_entities.dart';
import '../domain/checkout_repository.dart';
import 'checkout_mock_repository.dart';

class CheckoutRemoteRepository implements CheckoutRepository {
  CheckoutRemoteRepository(this._dio, [CheckoutMockRepository? mock])
      : _mock = mock ?? CheckoutMockRepository();

  final Dio _dio;
  final CheckoutMockRepository _mock;

  @override
  Future<List<CheckoutAddress>> getSavedAddresses() async {
    try {
      final response = await _dio.get('/customer/addresses');
      final data = response.data['data'] as List<dynamic>?;
      if (data != null && data.isNotEmpty) {
        return data.map((json) {
          return CheckoutAddress(
            id: json['id'] as String,
            label: json['label'] as String? ?? 'Address',
            fullName: json['fullName'] as String? ?? 'Customer',
            street: json['street'] as String? ?? '',
            city: json['city'] as String? ?? '',
            state: json['state'] as String? ?? '',
            zipCode: json['zipCode'] as String? ?? '',
            phone: json['phone'] as String? ?? '',
            isDefault: json['isDefault'] as bool? ?? false,
          );
        }).toList();
      }
    } catch (e) {
      AppLogger.w('CheckoutRemoteRepository.getSavedAddresses failed: $e, using mock');
    }
    return _mock.getSavedAddresses();
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
      AppLogger.w('CheckoutRemoteRepository.getDeliveryMethods failed: $e, using mock');
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
      AppLogger.w('CheckoutRemoteRepository.searchReferrals failed: $e, using mock');
    }
    return _mock.searchReferrals(query);
  }

  @override
  Future<bool> verifyPaystackPayment(String reference) async {
    try {
      Response<dynamic> response;
      try {
        response = await _dio.get(ApiEndpoints.payments.paystackVerify(reference));
      } catch (_) {
        response = await _dio.post(ApiEndpoints.payments.paystackVerify(reference));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map) {
          final status = data['status'] ?? data['data']?['status'];
          return status == 'success' || status == true || data['success'] == true;
        }
        return true;
      }
    } catch (e) {
      AppLogger.w('CheckoutRemoteRepository.verifyPaystackPayment failed: $e, using mock');
    }
    return _mock.verifyPaystackPayment(reference);
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
    final methodStr = paymentType == CheckoutPaymentType.paystack ? 'paystack' : paymentType.name;
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
        response = await _dio.post(ApiEndpoints.orders.mobileApp, data: payload);
      } catch (_) {
        response = await _dio.post('/checkout/process', data: payload);
      }

      final unwrapped = ApiResponse.unwrapMap(response.data);
      final orderJson = unwrapped['order'] is Map<String, dynamic>
          ? unwrapped['order'] as Map<String, dynamic>
          : unwrapped;

      final ordId = unwrapped['orderId']?.toString() ??
          orderJson['id']?.toString() ??
          orderJson['order_number']?.toString() ??
          'ORD-${DateTime.now().millisecondsSinceEpoch % 100000}';

      final safeDate = DateTime.tryParse(orderJson['date']?.toString() ??
              orderJson['createdAt']?.toString() ??
              orderJson['created_at']?.toString() ??
              '') ??
          DateTime.now();

      final safeStatus = OrderStatus.fromString(
        orderJson['status']?.toString() ?? 'pending',
      );

      final safeTotal = (orderJson['total'] as num?)?.toInt() ??
          (orderJson['total_amount'] as num?)?.toInt() ??
          (orderJson['totalAmount'] as num?)?.toInt() ??
          cart.total.toInt();

      final safeOrder = CustomerOrder(
        id: ordId,
        date: safeDate,
        status: safeStatus,
        total: safeTotal,
        paymentMethod: paymentType.name,
        shippingAddress: ShippingAddress(
          fullName: address.fullName,
          street: address.street,
          city: address.city,
          zipCode: address.zipCode,
          phone: address.phone,
        ),
        items: cart.items
            .map((i) => OrderItem(
                  id: i.effectiveId,
                  productId: i.product.id,
                  productName: i.product.name,
                  price: i.product.price.toInt(),
                  quantity: i.quantity,
                ))
            .toList(),
      );

      return CheckoutOrderResult(
        orderId: ordId,
        status: safeStatus.label,
        totalAmount: safeTotal.toDouble(),
        createdAt: safeDate,
        order: safeOrder,
      );
    } catch (e) {
      AppLogger.w('CheckoutRemoteRepository.placeOrder failed: $e, falling back to mock');
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
  }
}
