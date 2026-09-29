import '../domain/wallet_entities.dart';
import '../domain/wallet_repository.dart';

class WalletMockRepository implements WalletRepository {
  @override
  Future<WalletInfo> getWalletInfo() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return const WalletInfo(
      balance: 145000.50,
      currency: 'NGN',
    );
  }

  @override
  Future<List<WalletTransaction>> getTransactions() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    return [
      WalletTransaction(
        id: 'tx_001',
        amount: 25000.0,
        type: TransactionType.credit,
        status: TransactionStatus.completed,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Funded wallet via Bank Transfer',
      ),
      WalletTransaction(
        id: 'tx_002',
        amount: 15400.0,
        type: TransactionType.debit,
        status: TransactionStatus.completed,
        date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        description: 'Purchased Order #10024',
      ),
      WalletTransaction(
        id: 'tx_003',
        amount: 5000.0,
        type: TransactionType.credit,
        status: TransactionStatus.completed,
        date: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
        description: 'Refund for Order #10019',
      ),
      WalletTransaction(
        id: 'tx_004',
        amount: 8000.0,
        type: TransactionType.debit,
        status: TransactionStatus.failed,
        date: DateTime.now().subtract(const Duration(days: 4, hours: 6)),
        description: 'Failed Purchase Attempt',
      ),
      WalletTransaction(
        id: 'tx_005',
        amount: 50000.0,
        type: TransactionType.credit,
        status: TransactionStatus.completed,
        date: DateTime.now().subtract(const Duration(days: 7, hours: 2)),
        description: 'Funded wallet via Card',
      ),
    ];
  }
}
