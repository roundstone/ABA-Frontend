import '../domain/wallet_entities.dart';
import '../domain/wallet_repository.dart';

class WalletMockRepository implements WalletRepository {
  @override
  Future<WalletInfo> getWalletInfo() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return WalletInfo(
      id: 104,
      balance: 145000.50,
      currency: 'NGN',
      walletableType: 'customer',
      walletableId: 4,
      userId: 10,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<PaginatedWalletTransactionsResult> getPaginatedTransactions({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
    int? walletId,
    int? transactionType,
    int? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var list = _mockTransactions;

    if (transactionType != null) {
      list = list.where((t) => t.transactionType.value == transactionType).toList();
    }
    if (status != null) {
      list = list.where((t) => t.status.value == status).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      list = list.where((t) {
        return t.description.toLowerCase().contains(q) ||
            (t.referenceNumber?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    if (startDate != null && startDate.isNotEmpty) {
      final s = DateTime.tryParse(startDate);
      if (s != null) {
        final startDay = DateTime(s.year, s.month, s.day);
        list = list.where((t) => !t.date.isBefore(startDay)).toList();
      }
    }
    if (endDate != null && endDate.isNotEmpty) {
      final e = DateTime.tryParse(endDate);
      if (e != null) {
        final endDay = DateTime(e.year, e.month, e.day, 23, 59, 59);
        list = list.where((t) => !t.date.isAfter(endDay)).toList();
      }
    }

    final total = list.length;
    final totalPages = (total / limit).ceil().clamp(1, 999);
    final startIndex = (page - 1) * limit;
    final items = startIndex >= total
        ? <WalletTransaction>[]
        : list.skip(startIndex).take(limit).toList();

    return PaginatedWalletTransactionsResult(
      transactions: items,
      totalItems: total,
      totalPages: totalPages,
      currentPage: page,
      hasNext: page < totalPages,
    );
  }

  @override
  Future<List<WalletTransaction>> getTransactions({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
    int? walletId,
    int? transactionType,
    int? status,
  }) async {
    final result = await getPaginatedTransactions(
      page: page,
      limit: limit,
      search: search,
      startDate: startDate,
      endDate: endDate,
      orderBy: orderBy,
      walletId: walletId,
      transactionType: transactionType,
      status: status,
    );
    return result.transactions;
  }

  static final List<WalletTransaction> _mockTransactions = [
    WalletTransaction(
      id: '101',
      walletId: 12,
      referenceNumber: 'DEMO-WALLET-CUSTOMER-12-1',
      amount: 25000.0,
      type: TransactionType.credit,
      status: TransactionStatus.completed,
      transactionType: WalletTransactionType.deposit,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      description: 'Demo Paystack wallet deposit',
      balanceBefore: 0.0,
      balanceAfter: 25000.0,
      sourceType: 'wallet_transaction_seed',
      sourceId: 12,
    ),
    WalletTransaction(
      id: '102',
      walletId: 12,
      referenceNumber: 'DEMO-WALLET-CUSTOMER-12-2',
      amount: 5000.0,
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      transactionType: WalletTransactionType.orderPayment,
      date: DateTime.now().subtract(const Duration(hours: 1)),
      description: 'Demo wallet-funded order payment',
      balanceBefore: 25000.0,
      balanceAfter: 20000.0,
      sourceType: 'wallet_transaction_seed',
      sourceId: 12,
    ),
    WalletTransaction(
      id: '103',
      walletId: 12,
      referenceNumber: 'DEMO-WALLET-CUSTOMER-12-3',
      amount: 3000.0,
      type: TransactionType.credit,
      status: TransactionStatus.completed,
      transactionType: WalletTransactionType.refund,
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Refund for cancelled order item #310',
      balanceBefore: 20000.0,
      balanceAfter: 23000.0,
      sourceType: 'wallet_transaction_seed',
      sourceId: 12,
    ),
    WalletTransaction(
      id: '104',
      walletId: 12,
      referenceNumber: 'DEMO-WALLET-CUSTOMER-12-4',
      amount: 10000.0,
      type: TransactionType.debit,
      status: TransactionStatus.pending,
      transactionType: WalletTransactionType.withdrawal,
      date: DateTime.now().subtract(const Duration(days: 3)),
      description: 'Withdrawal to Access Bank •••• 4591',
      balanceBefore: 23000.0,
      balanceAfter: 13000.0,
      sourceType: 'wallet_transaction_seed',
      sourceId: 12,
    ),
  ];
}
