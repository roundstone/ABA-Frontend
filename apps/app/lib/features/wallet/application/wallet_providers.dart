import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/wallet_mock_repository.dart';
import '../data/wallet_remote_repository.dart';
import '../domain/wallet_entities.dart';
import '../domain/wallet_repository.dart';

export '../domain/wallet_entities.dart';
export '../domain/wallet_repository.dart';

class WalletTransactionFilter {
  const WalletTransactionFilter({
    this.type,
    this.status,
    this.search,
    this.startDate,
    this.endDate,
    this.orderBy = 'createdAt:DESC',
  });

  final WalletTransactionType? type;
  final TransactionStatus? status;
  final String? search;
  final String? startDate;
  final String? endDate;
  final String orderBy;

  WalletTransactionFilter copyWith({
    WalletTransactionType? type,
    bool clearType = false,
    TransactionStatus? status,
    bool clearStatus = false,
    String? search,
    bool clearSearch = false,
    String? startDate,
    bool clearStartDate = false,
    String? endDate,
    bool clearEndDate = false,
    String? orderBy,
  }) {
    return WalletTransactionFilter(
      type: clearType ? null : (type ?? this.type),
      status: clearStatus ? null : (status ?? this.status),
      search: clearSearch ? null : (search ?? this.search),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      orderBy: orderBy ?? this.orderBy,
    );
  }
}

final walletMockRepositoryProvider = Provider<WalletMockRepository>((ref) {
  return WalletMockRepository();
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final mock = ref.watch(walletMockRepositoryProvider);
  return WalletRemoteRepository(dio: dio, mockFallback: mock);
});

final walletInfoProvider = FutureProvider.autoDispose<WalletInfo>((ref) async {
  final repo = ref.watch(walletRepositoryProvider);
  return repo.getWalletInfo();
});

final walletFilterProvider =
    StateProvider.autoDispose<WalletTransactionFilter>((ref) {
  return const WalletTransactionFilter();
});

final walletTransactionsProvider =
    FutureProvider.autoDispose<List<WalletTransaction>>((ref) async {
  final repo = ref.watch(walletRepositoryProvider);
  final filter = ref.watch(walletFilterProvider);
  return repo.getTransactions(
    page: 1,
    limit: 20,
    search: filter.search,
    startDate: filter.startDate,
    endDate: filter.endDate,
    orderBy: filter.orderBy,
    transactionType: filter.type?.value,
    status: filter.status?.value,
  );
});
