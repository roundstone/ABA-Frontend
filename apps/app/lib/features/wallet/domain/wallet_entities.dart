class WalletInfo {
  const WalletInfo({
    required this.balance,
    required this.currency,
  });

  final double balance;
  final String currency;
}

enum TransactionType { credit, debit }

enum TransactionStatus { pending, completed, failed }

class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.date,
    required this.description,
  });

  final String id;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime date;
  final String description;
}
