import 'package:dio/dio.dart';
import '../domain/merchant_order_entities.dart';
import 'merchant_mock_repository.dart';

/// Remote service handling merchant order operations for [MerchantRemoteRepository].
class MerchantOrdersRemoteService {
  MerchantOrdersRemoteService(this.dio, this._mock);

  final Dio dio;
  final MerchantMockRepository _mock;

  Future<List<MerchantOrder>> getOrders(
    String merchantId, {
    MerchantOrderStatus? status,
    String? query,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/api/v1/merchants/$merchantId/orders',
        queryParameters: {
          if (status != null) 'status': status.name,
          if (query != null && query.isNotEmpty) 'q': query,
        },
      );
      final list = (response.data?['data'] as List<dynamic>?) ?? [];
      return list
          .map((item) => _mapOrder(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _mock.getOrders(merchantId, status: status, query: query);
    }
  }

  Future<MerchantOrder> getOrderById(String merchantId, String orderId) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/api/v1/merchants/$merchantId/orders/$orderId',
      );
      return _mapOrder(response.data?['data'] as Map<String, dynamic>);
    } catch (_) {
      return _mock.getOrderById(merchantId, orderId);
    }
  }

  Future<MerchantOrder> updateOrderStatus(
    String merchantId,
    String orderId,
    MerchantOrderStatus newStatus,
  ) async {
    try {
      final response = await dio.patch<Map<String, dynamic>>(
        '/api/v1/merchants/$merchantId/orders/$orderId/status',
        data: {'status': newStatus.name},
      );
      final map = response.data?['data'] as Map<String, dynamic>? ?? {};
      final order = await getOrderById(merchantId, orderId);
      return order.copyWith(
        status: MerchantOrderStatus.fromString(
          map['status'] as String? ?? newStatus.name,
        ),
      );
    } catch (_) {
      return _mock.updateOrderStatus(merchantId, orderId, newStatus);
    }
  }

  Future<MerchantOrder> recordOrder(
    String merchantId,
    MerchantOrder order,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/api/v1/merchants/$merchantId/orders',
        data: {
          'id': order.id,
          'customerName': order.customerName,
          'customerPhone': order.customerPhone,
          'isWalkIn': order.isWalkIn,
          'channel': order.channel.name,
          'status': order.status.name,
          'paymentStatus': order.paymentStatus.name,
          'paymentMethod': order.paymentMethod,
          'total': order.total,
          'subtotal': order.subtotal,
          'deliveryFee': order.deliveryFee,
          'discount': order.discount,
          'notes': order.notes,
          'items': order.items
              .map((it) => {
                    'id': it.id,
                    'productId': it.productId,
                    'productName': it.productName,
                    'sku': it.sku,
                    'price': it.price,
                    'quantity': it.quantity,
                  })
              .toList(),
        },
      );
      final map = (response.data?['data'] as Map<String, dynamic>?) ?? {};
      return _mapOrder(
        map.isNotEmpty ? map : {'id': order.id, ...response.data ?? {}},
      );
    } catch (_) {
      return _mock.recordOrder(merchantId, order);
    }
  }

  static MerchantOrder _mapOrder(Map<String, dynamic> map) {
    final rawItems = (map['items'] as List<dynamic>?) ?? [];
    return MerchantOrder(
      id: map['id'] as String,
      customerName: map['customerName'] as String,
      customerPhone: map['customerPhone'] as String? ?? '',
      isWalkIn: map['isWalkIn'] as bool? ?? false,
      channel:
          map['channel'] == 'pos' ? OrderChannel.pos : OrderChannel.storefront,
      status: MerchantOrderStatus.fromString(map['status'] as String?),
      paymentStatus:
          MerchantPaymentStatus.fromString(map['paymentStatus'] as String?),
      paymentMethod: map['paymentMethod'] as String? ?? 'Cash',
      items: rawItems.map((ri) {
        final m = ri as Map<String, dynamic>;
        return MerchantOrderItem(
          id: m['id'] as String,
          productId: m['productId'] as String,
          productName: m['productName'] as String,
          sku: m['sku'] as String? ?? '',
          price: (m['price'] as num).toDouble(),
          quantity: (m['quantity'] as num).toInt(),
          imageUrl: m['imageUrl'] as String? ?? '',
        );
      }).toList(),
      subtotal: (map['subtotal'] as num).toDouble(),
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num).toDouble(),
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      shippingAddress: map['shippingAddress'] as String?,
      notes: map['notes'] as String?,
    );
  }
}

