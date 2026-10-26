import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/address_remote_repository.dart';
import '../domain/address_repository.dart';
import '../domain/address_entities.dart';
import '../application/address_notifier.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AddressRemoteRepository(dio: dio, ref: ref);
});

final addressesProvider = StateNotifierProvider<AddressNotifier, List<DeliveryAddress>>((ref) {
  final repo = ref.watch(addressRepositoryProvider);
  return AddressNotifier(repository: repo);
});