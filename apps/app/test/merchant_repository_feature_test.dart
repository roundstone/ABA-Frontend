import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/merchant/data/merchant_mock_repository.dart';
import 'package:app/features/merchant/domain/merchant_order_entities.dart';
import 'package:app/features/merchant/domain/merchant_product_entities.dart';

void main() {
  group('MerchantMockRepository Tests', () {
    late MerchantMockRepository repo;

    setUp(() {
      repo = MerchantMockRepository();
    });

    test('getDashboardMetrics returns seeded metrics and sales trends', () async {
      final metrics = await repo.getDashboardMetrics('mer-1');

      expect(metrics.todaySales, greaterThan(0));
      expect(metrics.todayOrdersCount, greaterThan(0));
      expect(metrics.totalRevenue, greaterThan(1000000));
      expect(metrics.activeProductsCount, greaterThan(0));
      expect(metrics.salesTrend.length, equals(7));
      expect(metrics.salesGrowthPercentage, equals(14.8));
    });

    test('getProducts returns all products and filters by query and category', () async {
      final all = await repo.getProducts('mer-1');
      expect(all.length, greaterThanOrEqualTo(5));

      final shoes = await repo.getProducts('mer-1', category: 'Shoes & Footwear');
      expect(shoes.every((p) => p.category == 'Shoes & Footwear'), isTrue);

      final queryMatches = await repo.getProducts('mer-1', query: 'Oxford');
      expect(queryMatches.any((p) => p.name.contains('Oxford')), isTrue);
    });

    test('getProducts filters by stock status (In Stock, Low Stock, Out of Stock)', () async {
      final lowStock = await repo.getProducts('mer-1', stockFilter: 'Low Stock');
      expect(lowStock.every((p) => p.isLowStock), isTrue);

      final outOfStock = await repo.getProducts('mer-1', stockFilter: 'Out of Stock');
      expect(outOfStock.every((p) => p.isOutOfStock), isTrue);
    });

    test('addProduct inserts product into list', () async {
      final newProd = MerchantProduct(
        id: 'test-prod-999',
        name: 'Ariaria Special Sandals',
        sku: 'ABA-SD-099',
        category: 'Shoes & Footwear',
        price: 18000.0,
        costPrice: 11000.0,
        stock: 25,
        updatedAt: DateTime.now(),
      );

      final created = await repo.addProduct('mer-1', newProd);
      expect(created.id, equals('test-prod-999'));

      final list = await repo.getProducts('mer-1');
      expect(list.any((p) => p.id == 'test-prod-999'), isTrue);
    });

    test('adjustStock correctly increases or decreases inventory', () async {
      final products = await repo.getProducts('mer-1');
      final first = products.first;
      final initialStock = first.stock;

      await repo.adjustStock('mer-1', first.id, 5, 'Factory Shipment');
      final updatedList = await repo.getProducts('mer-1');
      final updated = updatedList.firstWhere((p) => p.id == first.id);

      expect(updated.stock, equals(initialStock + 5));
    });

    test('getOrders returns orders list and filters by status', () async {
      final allOrders = await repo.getOrders('mer-1');
      expect(allOrders.isNotEmpty, isTrue);

      final pendingOrders = await repo.getOrders(
        'mer-1',
        status: MerchantOrderStatus.pending,
      );
      expect(pendingOrders.every((o) => o.status == MerchantOrderStatus.pending), isTrue);
    });

    test('updateOrderStatus transitions order to next status', () async {
      final allOrders = await repo.getOrders('mer-1');
      final target = allOrders.firstWhere((o) => o.status == MerchantOrderStatus.pending);

      final updated = await repo.updateOrderStatus(
        'mer-1',
        target.id,
        MerchantOrderStatus.processing,
      );

      expect(updated.status, equals(MerchantOrderStatus.processing));

      final fetched = await repo.getOrderById('mer-1', target.id);
      expect(fetched.status, equals(MerchantOrderStatus.processing));
    });
  });
}
