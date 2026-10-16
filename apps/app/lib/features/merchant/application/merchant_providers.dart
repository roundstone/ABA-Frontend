import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';
import '../data/merchant_mock_repository.dart';
import '../domain/merchant_order_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_dashboard_notifier.dart';
import 'merchant_orders_notifier.dart';
import 'merchant_products_notifier.dart';

final merchantRepositoryProvider = Provider<MerchantRepository>((ref) {
  return MerchantMockRepository();
});

final currentMerchantIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.merchantId ?? 'mer-1';
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
