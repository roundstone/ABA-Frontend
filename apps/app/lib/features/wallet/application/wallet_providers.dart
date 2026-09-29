import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/wallet_mock_repository.dart';
import '../domain/wallet_entities.dart';
import '../domain/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletMockRepository();
});

final walletInfoProvider = FutureProvider.autoDispose<WalletInfo>((ref) async {
  final repo = ref.watch(walletRepositoryProvider);
  return repo.getWalletInfo();
});

final walletTransactionsProvider = FutureProvider.autoDispose<List<WalletTransaction>>((ref) async {
  final repo = ref.watch(walletRepositoryProvider);
  return repo.getTransactions();
});
