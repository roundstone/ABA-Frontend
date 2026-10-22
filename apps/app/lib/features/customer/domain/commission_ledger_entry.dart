enum CommissionFlowStage {
  accrual('Accrual'),
  walletCredited('Wallet Credited'),
  payoutDisbursed('Bank Payout'),
  reversed('Reversed');

  const CommissionFlowStage(this.label);
  final String label;
}

class CommissionLedgerEntry {
  final String id;
  final DateTime date;
  final String commissionNumber;
  final String orderNumber;
  final String beneficiaryName;
  final int level;
  final CommissionFlowStage stage;
  final String journalEntryNumber;
  final String debitAccountCode;
  final String debitAccountName;
  final String creditAccountCode;
  final String creditAccountName;
  final int amountInKobo;
  final int runningPayableBalanceInKobo;
  final String status;
  final String notes;

  const CommissionLedgerEntry({
    required this.id,
    required this.date,
    required this.commissionNumber,
    required this.orderNumber,
    required this.beneficiaryName,
    required this.level,
    required this.stage,
    required this.journalEntryNumber,
    required this.debitAccountCode,
    required this.debitAccountName,
    required this.creditAccountCode,
    required this.creditAccountName,
    required this.amountInKobo,
    required this.runningPayableBalanceInKobo,
    required this.status,
    required this.notes,
  });

  double get amountInNaira => amountInKobo / 100.0;
  double get runningBalanceInNaira => runningPayableBalanceInKobo / 100.0;
}
