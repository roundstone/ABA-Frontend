import '../domain/wallet_entities.dart';
import '../domain/wallet_repository.dart';
import 'wallet_mock_data.dart';

class WalletMockRepository implements WalletRepository {
  @override
  Future<WalletInfo> getWalletInfo() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return WalletInfo(
      id: 104, balance: WalletMockData.mockBalance, currency: 'NGN',
      walletableType: 'customer', walletableId: 4, userId: 10, isActive: true,
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
    await Future.delayed(const Duration(milliseconds: 300));
    var list = List<WalletTransaction>.from(WalletMockData.mockTransactions);

    if (transactionType != null) {
      list = list.where((t) => t.transactionType.value == transactionType).toList();
    }
    if (status != null) {
      list = list.where((t) => t.status.value == status).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      list = list.where((t) =>
          t.description.toLowerCase().contains(q) ||
          (t.referenceNumber?.toLowerCase().contains(q) ?? false)).toList();
    }
    if (startDate != null && startDate.isNotEmpty) {
      final s = DateTime.tryParse(startDate);
      if (s != null) {
        list = list.where((t) => !t.date.isBefore(DateTime(s.year, s.month, s.day))).toList();
      }
    }
    if (endDate != null && endDate.isNotEmpty) {
      final e = DateTime.tryParse(endDate);
      if (e != null) {
        list = list.where((t) => !t.date.isAfter(DateTime(e.year, e.month, e.day, 23, 59, 59))).toList();
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
  }) async =>
      (await getPaginatedTransactions(
        page: page,
        limit: limit,
        search: search,
        startDate: startDate,
        endDate: endDate,
        orderBy: orderBy,
        walletId: walletId,
        transactionType: transactionType,
        status: status,
      ))
          .transactions;

  @override
  Future<WalletFundInitResult> initializeFundWallet(double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return WalletFundInitResult(
      reference: 'WLT-${DateTime.now().millisecondsSinceEpoch}',
      email: 'c-davidenabs@gmail.com',
      amountInKobo: (amount * 100).round(),
      publicKey: 'pk_test_a3c52ce327f5f3e830c62d7d2209ca361833dbb9',
    );
  }

  @override
  Future<bool> verifyFundWallet(String reference) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return reference.isNotEmpty;
  }

  @override
  Future<WalletPayout> createWithdrawal({
    required double amount,
    required int bankAccountId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final acc = WalletMockData.mockBankAccounts.firstWhere(
      (b) => b.id == bankAccountId,
      orElse: () => WalletMockData.mockBankAccounts.first,
    );
    WalletMockData.mockBalance =
        (WalletMockData.mockBalance - amount).clamp(0.0, double.infinity);

    final payout = WalletPayout(
      id: '${WalletMockData.mockPayouts.length + 1}',
      amount: amount, status: 'pending', createdAt: DateTime.now(),
      reference: 'PYT-${DateTime.now().millisecondsSinceEpoch}',
      bankAccountId: bankAccountId, bankName: acc.bankName,
      accountNumber: acc.accountNumber, accountName: acc.accountName,
    );
    WalletMockData.mockPayouts.insert(0, payout);

    WalletMockData.mockTransactions.insert(
      0,
      WalletTransaction(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        walletId: 104,
        referenceNumber: payout.reference,
        amount: amount,
        type: TransactionType.debit,
        status: TransactionStatus.pending,
        transactionType: WalletTransactionType.withdrawal,
        date: DateTime.now(),
        description: 'Withdrawal to ${acc.bankName} ${acc.maskedAccountNumber}',
      ),
    );
    return payout;
  }

  @override
  Future<List<WalletPayout>> getMyPayouts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(WalletMockData.mockPayouts);
  }

  @override
  Future<WalletPayout> getPayoutById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return WalletMockData.mockPayouts.firstWhere((p) => p.id == id,
        orElse: () => WalletMockData.mockPayouts.first);
  }

  @override
  Future<List<BankOption>> getAvailableBanks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(WalletMockData.mockBanks);
  }

  @override
  Future<List<UserBankAccount>> getUserBankAccounts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(WalletMockData.mockBankAccounts);
  }

  @override
  Future<UserBankAccount> addBankAccount({
    required String bankName,
    required String bankCode,
    required String accountNumber,
    bool isPrimary = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (isPrimary) {
      for (var i = 0; i < WalletMockData.mockBankAccounts.length; i++) {
        WalletMockData.mockBankAccounts[i] = WalletMockData.mockBankAccounts[i].copyWith(isPrimary: false);
      }
    }
    final newAcc = UserBankAccount(
      id: WalletMockData.mockBankAccounts.length + 1,
      userId: 10,
      bankName: bankName,
      bankCode: bankCode,
      accountNumber: accountNumber,
      accountName: 'DAVID OSAGIE ENABULELE',
      isVerified: true,
      isPrimary: isPrimary || WalletMockData.mockBankAccounts.isEmpty,
      createdAt: DateTime.now(), updatedAt: DateTime.now(),
    );
    WalletMockData.mockBankAccounts.insert(0, newAcc);
    return newAcc;
  }

  @override
  Future<UserBankAccount> updateBankAccount(
    int id, {
    String? bankName,
    String? bankCode,
    String? accountNumber,
    bool? isPrimary,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (isPrimary == true) {
      for (var i = 0; i < WalletMockData.mockBankAccounts.length; i++) {
        WalletMockData.mockBankAccounts[i] = WalletMockData.mockBankAccounts[i].copyWith(isPrimary: false);
      }
    }
    final idx = WalletMockData.mockBankAccounts.indexWhere((b) => b.id == id);
    if (idx >= 0) {
      final updated = WalletMockData.mockBankAccounts[idx].copyWith(
        bankName: bankName,
        bankCode: bankCode,
        accountNumber: accountNumber,
        isPrimary: isPrimary,
      );
      WalletMockData.mockBankAccounts[idx] = updated;
      return updated;
    }
    return WalletMockData.mockBankAccounts.first;
  }

  @override
  Future<void> deleteBankAccount(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    WalletMockData.mockBankAccounts.removeWhere((b) => b.id == id);
  }

  @override
  Future<ShoppingCreditInfo> getShoppingCredits() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return WalletMockData.mockShoppingCredits;
  }
}
