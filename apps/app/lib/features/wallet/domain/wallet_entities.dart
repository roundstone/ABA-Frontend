// Wallet domain entities, enums, and data models matching the ABA ERP backend.
export 'wallet_payout_models.dart';

enum WalletTransactionType {
  deposit(1),
  orderPayment(2),
  withdrawal(3),
  refund(4);

  const WalletTransactionType(this.value);
  final int value;

  bool get isCredit =>
      this == WalletTransactionType.deposit ||
      this == WalletTransactionType.refund;

  bool get isDebit =>
      this == WalletTransactionType.orderPayment ||
      this == WalletTransactionType.withdrawal;

  String get displayName {
    switch (this) {
      case WalletTransactionType.deposit:
        return 'Deposit';
      case WalletTransactionType.orderPayment:
        return 'Order Payment';
      case WalletTransactionType.withdrawal:
        return 'Withdrawal';
      case WalletTransactionType.refund:
        return 'Refund';
    }
  }

  static WalletTransactionType fromValue(dynamic val) {
    if (val is int) {
      return WalletTransactionType.values.firstWhere(
        (e) => e.value == val,
        orElse: () => WalletTransactionType.deposit,
      );
    }
    final s = val?.toString().toLowerCase() ?? '';
    if (s.contains('deposit')) return WalletTransactionType.deposit;
    if (s.contains('order') || s.contains('payment')) {
      return WalletTransactionType.orderPayment;
    }
    if (s.contains('withdraw')) return WalletTransactionType.withdrawal;
    if (s.contains('refund')) return WalletTransactionType.refund;
    final parsed = int.tryParse(s);
    return parsed != null ? fromValue(parsed) : WalletTransactionType.deposit;
  }
}

enum TransactionType { credit, debit }

enum TransactionStatus {
  pending(1),
  completed(2),
  failed(3),
  cancelled(4);

  const TransactionStatus(this.value);
  final int value;

  String get displayName {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }

  static TransactionStatus fromValue(dynamic val) {
    if (val is int) {
      return TransactionStatus.values.firstWhere(
        (e) => e.value == val,
        orElse: () => TransactionStatus.completed,
      );
    }
    final s = val?.toString().toLowerCase() ?? '';
    if (s.contains('pending')) return TransactionStatus.pending;
    if (s.contains('fail')) return TransactionStatus.failed;
    if (s.contains('cancel')) return TransactionStatus.cancelled;
    if (s.contains('complete') || s.contains('success')) {
      return TransactionStatus.completed;
    }
    final parsed = int.tryParse(s);
    return parsed != null ? fromValue(parsed) : TransactionStatus.completed;
  }
}

class WalletInfo {
  const WalletInfo({
    this.id,
    required this.balance,
    required this.currency,
    this.walletableType,
    this.walletableId,
    this.userId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final double balance;
  final String currency;
  final String? walletableType;
  final int? walletableId;
  final int? userId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    final balanceRaw = json['balance'];
    final parsedBalance = double.tryParse(balanceRaw?.toString() ?? '0') ?? 0.0;
    final currencyRaw = json['currency'];
    final currencyStr =
        (currencyRaw == 1 || currencyRaw == '1' || currencyRaw == null)
            ? 'NGN'
            : currencyRaw.toString();

    return WalletInfo(
      id: json['id'] as int?,
      balance: parsedBalance,
      currency: currencyStr,
      walletableType: json['walletable_type']?.toString(),
      walletableId: json['walletable_id'] as int?,
      userId: json['user_id'] as int?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}

class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.date,
    required this.description,
    this.walletId,
    this.referenceNumber,
    this.transactionType = WalletTransactionType.deposit,
    this.currency = 'NGN',
    this.balanceBefore,
    this.balanceAfter,
    this.sourceType,
    this.sourceId,
    this.metadata,
    this.wallet,
  });

  final String id;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime date;
  final String description;
  final int? walletId;
  final String? referenceNumber;
  final WalletTransactionType transactionType;
  final String currency;
  final double? balanceBefore;
  final double? balanceAfter;
  final String? sourceType;
  final int? sourceId;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? wallet;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    final txType = WalletTransactionType.fromValue(json['transaction_type']);
    final txStatus = TransactionStatus.fromValue(json['status']);
    final parsedAmount =
        double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0;
    final parsedDate = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
        : DateTime.now();
    final legacyType =
        txType.isCredit ? TransactionType.credit : TransactionType.debit;

    return WalletTransaction(
      id: json['id']?.toString() ?? '',
      amount: parsedAmount,
      type: legacyType,
      status: txStatus,
      date: parsedDate,
      description: json['description']?.toString() ?? txType.displayName,
      walletId: json['wallet_id'] as int?,
      referenceNumber: json['reference_number']?.toString(),
      transactionType: txType,
      currency:
          (json['currency'] == 1 || json['currency'] == '1' || json['currency'] == null)
              ? 'NGN'
              : json['currency'].toString(),
      balanceBefore:
          double.tryParse(json['balance_before']?.toString() ?? ''),
      balanceAfter:
          double.tryParse(json['balance_after']?.toString() ?? ''),
      sourceType: json['source_type']?.toString(),
      sourceId: json['source_id'] as int?,
      metadata: json['metadata'] is Map<String, dynamic>
          ? json['metadata'] as Map<String, dynamic>
          : null,
      wallet: json['wallet'] is Map<String, dynamic>
          ? json['wallet'] as Map<String, dynamic>
          : null,
    );
  }
}

class PaginatedWalletTransactionsResult {
  const PaginatedWalletTransactionsResult({
    required this.transactions,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
  });

  final List<WalletTransaction> transactions;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;
}
