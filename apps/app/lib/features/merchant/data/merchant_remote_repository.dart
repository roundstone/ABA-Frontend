import 'package:dio/dio.dart';
import '../domain/merchant_dashboard_entities.dart';
import '../domain/merchant_order_entities.dart';
import '../domain/merchant_product_entities.dart';
import '../domain/merchant_repository.dart';

class MerchantRemoteRepository implements MerchantRepository {
  MerchantRemoteRepository({required this.dio});

  final Dio dio;

  @override
  Future<MerchantDashboardMetrics> getDashboardMetrics(String merchantId) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/api/v1/merchants/$merchantId/dashboard',
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    final trendList = (data['salesTrend'] as List<dynamic>?) ?? [];

    return MerchantDashboardMetrics(
      todaySales: (data['todaySales'] as num?)?.toDouble() ?? 0.0,
      todayOrdersCount: (data['todayOrdersCount'] as num?)?.toInt() ?? 0,
      totalRevenue: (data['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      lowStockCount: (data['lowStockCount'] as num?)?.toInt() ?? 0,
      activeProductsCount: (data['activeProductsCount'] as num?)?.toInt() ?? 0,
      pendingOrdersCount: (data['pendingOrdersCount'] as num?)?.toInt() ?? 0,
      commissionEarned: (data['commissionEarned'] as num?)?.toDouble() ?? 0.0,
      salesTrend: trendList.map((item) {
        final map = item as Map<String, dynamic>;
        return SalesTrendPoint(
          day: map['day'] as String? ?? '',
          amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList(),
      salesGrowthPercentage:
          (data['salesGrowthPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  Future<List<MerchantProduct>> getProducts(
    String merchantId, {
    String? query,
    String? category,
    String? stockFilter,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/api/v1/merchants/$merchantId/products',
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        if (category != null && category != 'All') 'category': category,
        if (stockFilter != null && stockFilter != 'All') 'stock': stockFilter,
      },
    );

    final list = (response.data?['data'] as List<dynamic>?) ?? [];
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return MerchantProduct(
        id: map['id'] as String,
        name: map['name'] as String,
        sku: map['sku'] as String,
        category: map['category'] as String,
        price: (map['price'] as num).toDouble(),
        costPrice: (map['costPrice'] as num?)?.toDouble() ?? 0.0,
        stock: (map['stock'] as num).toInt(),
        lowStockThreshold: (map['lowStockThreshold'] as num?)?.toInt() ?? 5,
        imageUrl: map['imageUrl'] as String? ?? '',
        description: map['description'] as String? ?? '',
        status: MerchantProductStatus.fromString(map['status'] as String?),
        isCommissionable: map['isCommissionable'] as bool? ?? true,
        soldCount: (map['soldCount'] as num?)?.toInt() ?? 0,
        updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<MerchantProduct> addProduct(
    String merchantId,
    MerchantProduct product,
  ) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/merchants/$merchantId/products',
      data: {
        'name': product.name,
        'sku': product.sku,
        'category': product.category,
        'price': product.price,
        'costPrice': product.costPrice,
        'stock': product.stock,
        'lowStockThreshold': product.lowStockThreshold,
        'imageUrl': product.imageUrl,
        'description': product.description,
        'status': product.status.name,
      },
    );
    final map = response.data?['data'] as Map<String, dynamic>;
    return product.copyWith(id: map['id'] as String? ?? product.id);
  }

  @override
  Future<MerchantProduct> updateProduct(
    String merchantId,
    MerchantProduct product,
  ) async {
    await dio.put<Map<String, dynamic>>(
      '/api/v1/merchants/$merchantId/products/${product.id}',
      data: {
        'name': product.name,
        'sku': product.sku,
        'category': product.category,
        'price': product.price,
        'costPrice': product.costPrice,
        'stock': product.stock,
        'lowStockThreshold': product.lowStockThreshold,
        'imageUrl': product.imageUrl,
        'description': product.description,
        'status': product.status.name,
      },
    );
    return product;
  }

  @override
  Future<void> adjustStock(
    String merchantId,
    String productId,
    int adjustment,
    String reason,
  ) async {
    await dio.patch<Map<String, dynamic>>(
      '/api/v1/merchants/$merchantId/products/$productId/stock',
      data: {'adjustment': adjustment, 'reason': reason},
    );
  }

  @override
  Future<List<MerchantOrder>> getOrders(
    String merchantId, {
    MerchantOrderStatus? status,
    String? query,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/api/v1/merchants/$merchantId/orders',
      queryParameters: {
        if (status != null) 'status': status.name,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );
    final list = (response.data?['data'] as List<dynamic>?) ?? [];
    return list.map((item) => _mapOrder(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<MerchantOrder> getOrderById(String merchantId, String orderId) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/api/v1/merchants/$merchantId/orders/$orderId',
    );
    return _mapOrder(response.data?['data'] as Map<String, dynamic>);
  }

  @override
  Future<MerchantOrder> updateOrderStatus(
    String merchantId,
    String orderId,
    MerchantOrderStatus newStatus,
  ) async {
    final response = await dio.patch<Map<String, dynamic>>(
      '/api/v1/merchants/$merchantId/orders/$orderId/status',
      data: {'status': newStatus.name},
    );
    final map = response.data?['data'] as Map<String, dynamic>? ?? {};
    final order = await getOrderById(merchantId, orderId);
    return order.copyWith(
      status: MerchantOrderStatus.fromString(map['status'] as String? ?? newStatus.name),
    );
  }

  @override
  Future<MerchantOrder> recordOrder(
    String merchantId,
    MerchantOrder order,
  ) async {
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
    return _mapOrder(map.isNotEmpty ? map : {'id': order.id, ...response.data ?? {}});
  }

  MerchantOrder _mapOrder(Map<String, dynamic> map) {
    final rawItems = (map['items'] as List<dynamic>?) ?? [];
    return MerchantOrder(
      id: map['id'] as String,
      customerName: map['customerName'] as String,
      customerPhone: map['customerPhone'] as String? ?? '',
      isWalkIn: map['isWalkIn'] as bool? ?? false,
      channel: map['channel'] == 'pos' ? OrderChannel.pos : OrderChannel.storefront,
      status: MerchantOrderStatus.fromString(map['status'] as String?),
      paymentStatus: MerchantPaymentStatus.fromString(map['paymentStatus'] as String?),
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
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      shippingAddress: map['shippingAddress'] as String?,
      notes: map['notes'] as String?,
    );
  }
}
