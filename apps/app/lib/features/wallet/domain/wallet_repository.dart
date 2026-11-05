import 'wallet_entities.dart';

abstract class WalletRepository {
  Future<WalletInfo> getWalletInfo();

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
  });

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
  });

  // Fund Wallet via Paystack
  Future<WalletFundInitResult> initializeFundWallet(double amount);
  Future<bool> verifyFundWallet(String reference);

  // Withdrawals & Payouts
  Future<WalletPayout> createWithdrawal({
    required double amount,
    required int bankAccountId,
  });
  Future<List<WalletPayout>> getMyPayouts();
  Future<WalletPayout> getPayoutById(String id);

  // User Bank Accounts
  Future<List<BankOption>> getAvailableBanks();
  Future<List<UserBankAccount>> getUserBankAccounts();
  Future<UserBankAccount> addBankAccount({
    required String bankName,
    required String bankCode,
    required String accountNumber,
    bool isPrimary = false,
  });
  Future<UserBankAccount> updateBankAccount(
    int id, {
    String? bankName,
    String? bankCode,
    String? accountNumber,
    bool? isPrimary,
  });
  Future<void> deleteBankAccount(int id);
}
