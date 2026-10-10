import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/merchant_mock_repository.dart';
import '../domain/merchant_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_filter_notifier.dart';

final merchantRepositoryProvider = Provider<MerchantRepository>((ref) {
  return MerchantMockRepository();
});

final merchantFilterProvider =
    StateNotifierProvider<MerchantFilterNotifier, MerchantFilterParams>((ref) {
  return MerchantFilterNotifier();
});

final merchantsDirectoryProvider =
    FutureProvider.autoDispose<MerchantDirectoryResult>((ref) async {
  final repo = ref.watch(merchantRepositoryProvider);
  final params = ref.watch(merchantFilterProvider);
  return repo.getMerchants(params);
});

final merchantDetailProvider =
    FutureProvider.autoDispose.family<Merchant?, String>((ref, id) async {
  final repo = ref.watch(merchantRepositoryProvider);
  return repo.getMerchantById(id);
});
