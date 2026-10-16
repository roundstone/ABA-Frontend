import '../domain/merchant_dashboard_entities.dart';
import '../domain/merchant_order_entities.dart';
import '../domain/merchant_product_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_mock_data.dart';

class MerchantMockRepository implements MerchantRepository {
  // In-memory state
  final List<MerchantProduct> _products = List.from(kInitialMerchantProducts);
  final List<MerchantOrder> _orders = List.from(kInitialMerchantOrders);

  @override
  Future<MerchantDashboardMetrics> getDashboardMetrics(String merchantId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final today = DateTime.now();
    final todayOrders = _orders.where((o) {
      return o.createdAt.year == today.year &&
          o.createdAt.month == today.month &&
          o.createdAt.day == today.day;
    }).toList();

    final todaySales = todayOrders.fold<double>(
      0.0,
      (sum, o) => sum + (o.paymentStatus == MerchantPaymentStatus.paid ? o.total : 0.0),
    );

    final totalRevenue = _orders.fold<double>(
      0.0,
      (sum, o) => sum + (o.paymentStatus == MerchantPaymentStatus.paid ? o.total : 0.0),
    );

    final lowStockCount = _products.where((p) => p.isLowStock || p.isOutOfStock).length;
    final activeProductsCount = _products.where((p) => p.status == MerchantProductStatus.active).length;
    final pendingOrdersCount = _orders.where((o) => o.status == MerchantOrderStatus.pending || o.status == MerchantOrderStatus.processing).length;

    return MerchantDashboardMetrics(
      todaySales: todaySales > 0 ? todaySales : 71500.0, // Seed today sales if mock is fresh
      todayOrdersCount: todayOrders.isNotEmpty ? todayOrders.length : 2,
      totalRevenue: totalRevenue + 1250000.0,
      lowStockCount: lowStockCount,
      activeProductsCount: activeProductsCount,
      pendingOrdersCount: pendingOrdersCount,
      commissionEarned: 18500.0,
      salesTrend: kMockSalesTrend,
      salesGrowthPercentage: 14.8,
    );
  }

  @override
  Future<List<MerchantProduct>> getProducts(
    String merchantId, {
    String? query,
    String? category,
    String? stockFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    var results = List<MerchantProduct>.from(_products);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      results = results.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    }

    if (category != null && category != 'All') {
      results = results.where((p) => p.category == category).toList();
    }

    if (stockFilter != null && stockFilter != 'All') {
      if (stockFilter == 'In Stock') {
        results = results.where((p) => p.isInStock).toList();
      } else if (stockFilter == 'Low Stock') {
        results = results.where((p) => p.isLowStock).toList();
      } else if (stockFilter == 'Out of Stock') {
        results = results.where((p) => p.isOutOfStock).toList();
      }
    }

    return results;
  }

  @override
  Future<MerchantProduct> addProduct(
    String merchantId,
    MerchantProduct product,
  ) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _products.insert(0, product);
    return product;
  }

  @override
  Future<MerchantProduct> updateProduct(
    String merchantId,
    MerchantProduct product,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _products[index] = product;
      return product;
    }
    throw Exception('Product with id ${product.id} not found.');
  }

  @override
  Future<void> adjustStock(
    String merchantId,
    String productId,
    int adjustment,
    String reason,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      final current = _products[index];
      final newStock = (current.stock + adjustment).clamp(0, 99999);
      _products[index] = current.copyWith(
        stock: newStock,
        updatedAt: DateTime.now(),
      );
      return;
    }
    throw Exception('Product with id $productId not found.');
  }

  @override
  Future<List<MerchantOrder>> getOrders(
    String merchantId, {
    MerchantOrderStatus? status,
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    var results = List<MerchantOrder>.from(_orders);

    if (status != null) {
      results = results.where((o) => o.status == status).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      results = results.where((o) {
        return o.id.toLowerCase().contains(q) ||
            o.customerName.toLowerCase().contains(q) ||
            o.customerPhone.contains(q);
      }).toList();
    }

    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  @override
  Future<MerchantOrder> getOrderById(String merchantId, String orderId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final order = _orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => throw Exception('Order $orderId not found'),
    );
    return order;
  }

  @override
  Future<MerchantOrder> updateOrderStatus(
    String merchantId,
    String orderId,
    MerchantOrderStatus newStatus,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final current = _orders[index];
      final updated = current.copyWith(status: newStatus);
      _orders[index] = updated;
      return updated;
    }
    throw Exception('Order $orderId not found.');
  }

  @override
  Future<MerchantOrder> recordOrder(
    String merchantId,
    MerchantOrder order,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _orders.insert(0, order);
    return order;
  }
}
