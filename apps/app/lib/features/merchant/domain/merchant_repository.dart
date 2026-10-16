import 'merchant_dashboard_entities.dart';
import 'merchant_product_entities.dart';
import 'merchant_order_entities.dart';

abstract class MerchantRepository {
  Future<MerchantDashboardMetrics> getDashboardMetrics(String merchantId);

  Future<List<MerchantProduct>> getProducts(
    String merchantId, {
    String? query,
    String? category,
    String? stockFilter,
  });

  Future<MerchantProduct> addProduct(
    String merchantId,
    MerchantProduct product,
  );

  Future<MerchantProduct> updateProduct(
    String merchantId,
    MerchantProduct product,
  );

  Future<void> adjustStock(
    String merchantId,
    String productId,
    int adjustment,
    String reason,
  );

  Future<List<MerchantOrder>> getOrders(
    String merchantId, {
    MerchantOrderStatus? status,
    String? query,
  });

  Future<MerchantOrder> getOrderById(
    String merchantId,
    String orderId,
  );

  Future<MerchantOrder> updateOrderStatus(
    String merchantId,
    String orderId,
    MerchantOrderStatus newStatus,
  );

  Future<MerchantOrder> recordOrder(
    String merchantId,
    MerchantOrder order,
  );
}
