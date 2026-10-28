import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';
import '../data/merchant_remote_repository.dart';
import '../domain/merchant_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_filter_notifier.dart';

final merchantRepositoryProvider = Provider<MerchantRepository>((ref) {
  return MerchantRemoteRepository(ref.watch(dioProvider));
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

final merchantProductsProvider =
    FutureProvider.autoDispose.family<List<Product>, String>((ref, merchantId) async {
  final shopRepo = ref.watch(shopRepositoryProvider);
  final idNum = int.tryParse(merchantId);
  return shopRepo.fetchProducts(
    vendorId: idNum,
    queryParams: ListQueryParams(
      limit: 50,
      customParams: {'merchantId': merchantId},
    ),
  );
});

final merchantsSpotlightProvider =
    FutureProvider.autoDispose<List<Merchant>>((ref) async {
  final repo = ref.watch(merchantRepositoryProvider);
  return repo.getMerchantsSpotlight();
});

