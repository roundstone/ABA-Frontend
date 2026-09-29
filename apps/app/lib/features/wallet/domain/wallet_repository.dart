import 'wallet_entities.dart';

abstract class WalletRepository {
  Future<WalletInfo> getWalletInfo();
  Future<List<WalletTransaction>> getTransactions();
}
