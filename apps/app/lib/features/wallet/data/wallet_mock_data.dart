import '../domain/wallet_entities.dart';

class WalletMockData {
  WalletMockData._();

  static double mockBalance = 145000.50;

  static final ShoppingCreditInfo mockShoppingCredits = ShoppingCreditInfo(
    id: 2,
    userId: 10,
    balance: 0.0,
    isActivated: false,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 5)),
  );

  static final List<BankOption> mockBanks = [
    const BankOption(name: '5TT MFB', code: '51455', active: true),
    const BankOption(
      name: '78 Finance Company Ltd',
      code: '40195',
      active: true,
    ),
    const BankOption(name: 'Access Bank', code: '044', active: true),
    const BankOption(name: 'First Bank of Nigeria', code: '011', active: true),
    const BankOption(name: 'Guaranty Trust Bank (GTB)', code: '058', active: true),
    const BankOption(name: 'Kuda Bank', code: '50211', active: true),
    const BankOption(name: 'Moniepoint MFB', code: '50515', active: true),
    const BankOption(
      name: 'OPay Digital Services Limited (OPay)',
      code: '999992',
      active: true,
    ),
    const BankOption(name: 'PalmPay', code: '999991', active: true),
    const BankOption(name: 'United Bank For Africa (UBA)', code: '033', active: true),
    const BankOption(name: 'Zenith Bank', code: '057', active: true),
  ];

  static final List<UserBankAccount> mockBankAccounts = [
    UserBankAccount(
      id: 1,
      userId: 10,
      bankName: 'OPay Digital Services Limited (OPay)',
      bankCode: '999992',
      accountNumber: '8166551496',
      accountName: 'DAVID OSAGIE ENABULELE',
      isVerified: true,
      isPrimary: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  static final List<WalletPayout> mockPayouts = [
    WalletPayout(
      id: '1',
      amount: 10000.0,
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      reference: 'PYT-2026-001',
      bankAccountId: 1,
      bankName: 'OPay Digital Services Limited (OPay)',
      accountNumber: '8166551496',
      accountName: 'DAVID OSAGIE ENABULELE',
    ),
  ];

  static final List<WalletTransaction> mockTransactions = [
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

