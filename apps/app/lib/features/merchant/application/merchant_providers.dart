import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/auth_providers.dart';
import '../../shop/domain/shop_entities.dart';
import '../data/merchant_mock_repository.dart';
import '../data/merchant_remote_repository.dart';
import '../domain/merchant_order_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_dashboard_notifier.dart';
import 'merchant_orders_notifier.dart';
import 'merchant_products_notifier.dart';

export 'merchant_dashboard_notifier.dart';
export 'merchant_orders_notifier.dart';
export 'merchant_products_notifier.dart';

final merchantMockRepositoryProvider = Provider<MerchantMockRepository>((ref) {
  return MerchantMockRepository();
});

final merchantRepositoryProvider = Provider<MerchantRepository>((ref) {
  return MerchantRemoteRepository(
    dio: ref.watch(dioProvider),
    mockFallback: ref.watch(merchantMockRepositoryProvider),
  );
});

final currentMerchantIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.merchantId ?? 'mer-1';
});

final merchantCategoriesProvider =
    FutureProvider.autoDispose<List<ShopCategory>>((ref) async {
  final repo = ref.watch(merchantRepositoryProvider);
  return repo.getCategories();
});

final merchantSubcategoriesProvider =
    FutureProvider.autoDispose.family<List<ShopCategory>, int?>((ref, categoryId) async {
  final repo = ref.watch(merchantRepositoryProvider);
  return repo.getSubcategories(categoryId: categoryId);
});

final merchantBrandsProvider =
    FutureProvider.autoDispose<List<Brand>>((ref) async {
  final repo = ref.watch(merchantRepositoryProvider);
  return repo.getBrands();
});

final merchantDashboardProvider =
    StateNotifierProvider<MerchantDashboardNotifier, MerchantDashboardState>(
  (ref) {
    final repo = ref.watch(merchantRepositoryProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    return MerchantDashboardNotifier(
      repository: repo,
      merchantId: merchantId,
    );
  },
);

final merchantProductsProvider =
    StateNotifierProvider<MerchantProductsNotifier, MerchantProductsState>(
  (ref) {
    final repo = ref.watch(merchantRepositoryProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    return MerchantProductsNotifier(
      repository: repo,
      merchantId: merchantId,
    );
  },
);

final merchantOrdersProvider =
    StateNotifierProvider<MerchantOrdersNotifier, MerchantOrdersState>(
  (ref) {
    final repo = ref.watch(merchantRepositoryProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    return MerchantOrdersNotifier(
      repository: repo,
      merchantId: merchantId,
    );
  },
);

final merchantOrderDetailProvider =
    FutureProvider.family<MerchantOrder, String>((ref, orderId) async {
  final repo = ref.watch(merchantRepositoryProvider);
  final merchantId = ref.watch(currentMerchantIdProvider);
  return repo.getOrderById(merchantId, orderId);
});
