import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_error.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/merchant_dashboard_entities.dart';
import '../domain/merchant_order_entities.dart';
import '../domain/merchant_product_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_catalog_remote_service.dart';
import 'merchant_mock_repository.dart';
import 'merchant_orders_remote_service.dart';
import 'merchant_products_remote_service.dart';

class MerchantRemoteRepository implements MerchantRepository {
  MerchantRemoteRepository({
    required this.dio,
    MerchantMockRepository? mockFallback,
  }) : _mock = mockFallback ?? MerchantMockRepository(),
       _catalogService = MerchantCatalogRemoteService(
         dio,
         mockFallback ?? MerchantMockRepository(),
       ),
       _productsService = MerchantProductsRemoteService(
         dio,
         mockFallback ?? MerchantMockRepository(),
       ),
       _ordersService = MerchantOrdersRemoteService(
         dio,
         mockFallback ?? MerchantMockRepository(),
       );

  final Dio dio;
  final MerchantMockRepository _mock;
  final MerchantCatalogRemoteService _catalogService;
  final MerchantProductsRemoteService _productsService;
  final MerchantOrdersRemoteService _ordersService;

  @override
  Future<MerchantDashboardMetrics> getDashboardMetrics(
    String merchantId,
  ) async {
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
        activeProductsCount:
            (data['activeProductsCount'] as num?)?.toInt() ?? 0,
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
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w(
          'MerchantRemoteRepository.getDashboardMetrics fallback: $e',
        );
        return _mock.getDashboardMetrics(merchantId);
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.getDashboardMetrics(merchantId);
      rethrow;
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
  }) => _productsService.getProducts(
    merchantId,
    query: query,
    category: category,
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    stockFilter: stockFilter,
  );

  @override
  Future<MerchantProduct> addProduct(
    String merchantId,
    MerchantProduct product,
  ) => _productsService.addProduct(merchantId, product);

  @override
  Future<MerchantProduct> updateProduct(
    String merchantId,
    MerchantProduct product,
  ) => _productsService.updateProduct(merchantId, product);

  @override
  Future<void> deleteProduct(String merchantId, String productId) =>
      _productsService.deleteProduct(merchantId, productId);

  @override
  Future<void> adjustStock(
    String merchantId,
    String productId,
    int adjustment,
    String reason,
  ) => _productsService.adjustStock(merchantId, productId, adjustment, reason);

  @override
  Future<List<ShopCategory>> getCategories() => _catalogService.getCategories();

  @override
  Future<List<ShopCategory>> getSubcategories({int? categoryId}) =>
      _catalogService.getSubcategories(categoryId: categoryId);

  @override
  Future<List<Brand>> getBrands() => _catalogService.getBrands();

  @override
  Future<List<MerchantOrder>> getOrders(
    String merchantId, {
    MerchantOrderStatus? status,
    String? query,
  }) => _ordersService.getOrders(merchantId, status: status, query: query);

  @override
  Future<MerchantOrder> getOrderById(String merchantId, String orderId) =>
      _ordersService.getOrderById(merchantId, orderId);

  @override
  Future<MerchantOrder> updateOrderStatus(
    String merchantId,
    String orderId,
    MerchantOrderStatus newStatus,
  ) => _ordersService.updateOrderStatus(merchantId, orderId, newStatus);

  @override
  Future<MerchantOrder> recordOrder(String merchantId, MerchantOrder order) =>
      _ordersService.recordOrder(merchantId, order);
}
