import 'package:dio/dio.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/merchant_dashboard_entities.dart';
import '../domain/merchant_order_entities.dart';
import '../domain/merchant_product_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_mock_repository.dart';

class MerchantRemoteRepository implements MerchantRepository {
  MerchantRemoteRepository({required this.dio, MerchantMockRepository? mockFallback})
      : _mock = mockFallback ?? MerchantMockRepository();

  final Dio dio;
  final MerchantMockRepository _mock;

  @override
  Future<MerchantDashboardMetrics> getDashboardMetrics(String merchantId) async {
    try {
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
        salesGrowthPercentage: (data['salesGrowthPercentage'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.getDashboardMetrics failed: $e, falling back to mock');
      return _mock.getDashboardMetrics(merchantId);
    }
  }

  @override
  Future<List<MerchantProduct>> getProducts(
    String merchantId, {
    String? query,
    String? category,
    int? categoryId,
    int? subcategoryId,
    String? stockFilter,
  }) async {
    try {
      final numericId = int.tryParse(merchantId.replaceAll(RegExp(r'[^0-9]'), ''));
      final qParams = <String, dynamic>{
        'limit': 100,
        'page': 1,
        'orderBy': 'createdAt:DESC',
        'isActive': true,
        'includeVariants': true,
        if (query != null && query.isNotEmpty) 'search': query,
        if (categoryId != null) 'categoryId': categoryId,
        if (subcategoryId != null) 'subcategoryId': subcategoryId,
      };

      Response<dynamic>? response;
      try {
        response = await dio.get(ApiEndpoints.products.base, queryParameters: qParams);
      } catch (_) {
        // Fallback to merchant-specific path if base fails
        try {
          response = await dio.get('/api/v1/merchants/$merchantId/products', queryParameters: {
            if (query != null && query.isNotEmpty) 'q': query,
            if (category != null && category != 'All') 'category': category,
            if (stockFilter != null && stockFilter != 'All') 'stock': stockFilter,
          });
        } catch (_) {}
      }

      final rawData = response?.data;
      var list = rawData != null ? ApiResponse.unwrapList(rawData) : <dynamic>[];

      if (list.isNotEmpty) {
        var products = list.whereType<Map>().map((item) {
          return MerchantProduct.fromJson(Map<String, dynamic>.from(item));
        }).toList();

        // If merchant filter requested and products have merchant tags, filter if matches exist
        if (numericId != null) {
          final merchantMatches = products.where((p) => p.vendorId == numericId).toList();
          if (merchantMatches.isNotEmpty) {
            products = merchantMatches;
          }
        }

        if (category != null && category != 'All') {
          products = products.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
        }
        if (categoryId != null) {
          products = products.where((p) => p.categoryId == categoryId).toList();
        }
        if (subcategoryId != null) {
          products = products.where((p) => p.subcategoryId == subcategoryId).toList();
        }
        if (stockFilter != null && stockFilter != 'All') {
          if (stockFilter == 'In Stock') products = products.where((p) => p.isInStock).toList();
          if (stockFilter == 'Low Stock') products = products.where((p) => p.isLowStock).toList();
          if (stockFilter == 'Out of Stock') products = products.where((p) => p.isOutOfStock).toList();
        }
        return products;
      }
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.getProducts failed: $e, falling back to mock');
    }

    return _mock.getProducts(
      merchantId,
      query: query,
      category: category,
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      stockFilter: stockFilter,
    );
  }

  @override
  Future<MerchantProduct> addProduct(
    String merchantId,
    MerchantProduct product,
  ) async {
    try {
      final payload = product.toCreatePayload();
      Response<dynamic>? res;
      try {
        res = await dio.post(ApiEndpoints.products.base, data: payload);
      } catch (_) {
        res = await dio.post('/api/v1/merchants/$merchantId/products', data: payload);
      }

      final map = ApiResponse.unwrapMap(res.data);
      final created = map.isNotEmpty ? MerchantProduct.fromJson(map) : product;
      await _mock.addProduct(merchantId, created);
      return created;
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.addProduct remote call failed: $e, adding to mock store');
      return _mock.addProduct(merchantId, product);
    }
  }

  @override
  Future<MerchantProduct> updateProduct(
    String merchantId,
    MerchantProduct product,
  ) async {
    try {
      final payload = product.toCreatePayload();
      Response<dynamic>? res;
      try {
        res = await dio.patch(ApiEndpoints.products.byId(product.id), data: payload);
      } catch (_) {
        res = await dio.put(ApiEndpoints.products.byId(product.id), data: payload);
      }

      final map = ApiResponse.unwrapMap(res.data);
      final updated = map.isNotEmpty ? MerchantProduct.fromJson(map) : product;
      await _mock.updateProduct(merchantId, updated);
      return updated;
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.updateProduct failed: $e, falling back to mock');
      return _mock.updateProduct(merchantId, product);
    }
  }

  @override
  Future<void> deleteProduct(
    String merchantId,
    String productId,
  ) async {
    try {
      try {
        await dio.delete(ApiEndpoints.products.byId(productId));
      } catch (_) {
        await dio.delete('/api/v1/merchants/$merchantId/products/$productId');
      }
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.deleteProduct failed: $e, removing from mock');
    }
    await _mock.deleteProduct(merchantId, productId);
  }

  @override
  Future<void> adjustStock(
    String merchantId,
    String productId,
    int adjustment,
    String reason,
  ) async {
    try {
      await dio.patch<Map<String, dynamic>>(
        '/api/v1/merchants/$merchantId/products/$productId/stock',
        data: {'adjustment': adjustment, 'reason': reason},
      );
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.adjustStock failed: $e, adjusting mock');
    }
    await _mock.adjustStock(merchantId, productId, adjustment, reason);
  }

  @override
  Future<List<ShopCategory>> getCategories() async {
    try {
      final res = await dio.get(ApiEndpoints.productCategories.base, queryParameters: const {
        'page': 1,
        'limit': 50,
        'isActive': true,
      });
      final list = ApiResponse.unwrapList(res.data);
      final categories = list.whereType<Map>().map((i) => ShopCategory.fromJson(Map<String, dynamic>.from(i))).toList();
      if (categories.isNotEmpty) return categories;
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.getCategories fallback: $e');
    }
    return _mock.getCategories();
  }

  @override
  Future<List<ShopCategory>> getSubcategories({int? categoryId}) async {
    try {
      final res = await dio.get(ApiEndpoints.productSubcategories.base, queryParameters: {
        'page': 1,
        'limit': 100,
        'isActive': true,
        if (categoryId != null) 'categoryId': categoryId,
      });
      final list = ApiResponse.unwrapList(res.data);
      final subcats = list.whereType<Map>().map((i) => ShopCategory.fromJson(Map<String, dynamic>.from(i))).toList();
      if (subcats.isNotEmpty) {
        if (categoryId != null) {
          return subcats.where((s) => s.parentId == '$categoryId').toList();
        }
        return subcats;
      }
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.getSubcategories fallback: $e');
    }
    return _mock.getSubcategories(categoryId: categoryId);
  }

  @override
  Future<List<Brand>> getBrands() async {
    try {
      Response<dynamic>? res;
      try {
        res = await dio.get(ApiEndpoints.brands.base);
      } catch (_) {
        res = await dio.get(ApiEndpoints.storefront.popularBrands);
      }
      final list = ApiResponse.unwrapList(res.data);
      final brands = list.whereType<Map>().map((i) => Brand.fromJson(Map<String, dynamic>.from(i))).toList();
      if (brands.isNotEmpty) return brands;
    } catch (e) {
      AppLogger.w('MerchantRemoteRepository.getBrands fallback: $e');
    }
    return _mock.getBrands();
  }

  @override
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
      return list.map((item) => _mapOrder(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mock.getOrders(merchantId, status: status, query: query);
    }
  }

  @override
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

  @override
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
        status: MerchantOrderStatus.fromString(map['status'] as String? ?? newStatus.name),
      );
    } catch (_) {
      return _mock.updateOrderStatus(merchantId, orderId, newStatus);
    }
  }

  @override
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
      return _mapOrder(map.isNotEmpty ? map : {'id': order.id, ...response.data ?? {}});
    } catch (_) {
      return _mock.recordOrder(merchantId, order);
    }
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
