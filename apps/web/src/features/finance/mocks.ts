import { Account, JournalEntry, FinancialPeriod, CommissionLedgerEntry } from './types';

export const mockAccounts: Account[] = [
  { id: 'acc-1000', code: '1000', name: 'Cash', type: 'Asset', normalBalance: 'Debit', balance: 50000000, active: true, system: true, allowManualPosting: true },
  { id: 'acc-1010', code: '1010', name: 'Bank', type: 'Asset', normalBalance: 'Debit', balance: 1200000000, active: true, system: true, allowManualPosting: true },
  { id: 'acc-1100', code: '1100', name: 'Accounts Receivable', type: 'Asset', normalBalance: 'Debit', balance: 450000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-1200', code: '1200', name: 'Inventory – Raw', type: 'Asset', normalBalance: 'Debit', balance: 200000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-1210', code: '1210', name: 'Inventory – Finished', type: 'Asset', normalBalance: 'Debit', balance: 650000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-1220', code: '1220', name: 'Work in Progress (WIP)', type: 'Asset', normalBalance: 'Debit', balance: 80000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-1300', code: '1300', name: 'Goods Received Not Invoiced (GRNI)', type: 'Liability', normalBalance: 'Credit', balance: 40000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-2000', code: '2000', name: 'Accounts Payable', type: 'Liability', normalBalance: 'Credit', balance: 320000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-2100', code: '2100', name: 'Wallet Liability', type: 'Liability', normalBalance: 'Credit', balance: 150000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-2110', code: '2110', name: 'Commissions Payable', type: 'Liability', normalBalance: 'Credit', balance: 82000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-2200', code: '2200', name: 'VAT Payable', type: 'Liability', normalBalance: 'Credit', balance: 95000000, active: true, system: true, allowManualPosting: true },
  { id: 'acc-3000', code: '3000', name: 'Owner Equity', type: 'Equity', normalBalance: 'Credit', balance: 1000000000, active: true, system: true, allowManualPosting: true },
  { id: 'acc-4000', code: '4000', name: 'Sales Revenue', type: 'Revenue', normalBalance: 'Credit', balance: 2500000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-4100', code: '4100', name: 'Sales Returns', type: 'Revenue', normalBalance: 'Debit', balance: 50000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-5000', code: '5000', name: 'Cost of Goods Sold (COGS)', type: 'COGS', normalBalance: 'Debit', balance: 1100000000, active: true, system: true, allowManualPosting: false },
  { id: 'acc-6000', code: '6000', name: 'Operating Expenses', type: 'Expense', normalBalance: 'Debit', balance: 450000000, active: true, system: true, allowManualPosting: true },
];

export const mockJournals: JournalEntry[] = [
  {
    id: 'je-001',
    jeNumber: 'JE-0001',
    date: '2026-09-01T10:00:00Z',
    type: 'Auto',
    description: 'Sale of finished goods (Order ORD-001)',
    total: 25000000,
    status: 'Posted',
    sourceModule: 'Sales',
    sourceId: 'ORD-001',
    lines: [
      { id: 'jel-001a', accountId: 'acc-1100', debit: 25000000, credit: 0, memo: 'Order ORD-001 Receivable' },
      { id: 'jel-001b', accountId: 'acc-4000', debit: 0, credit: 25000000, memo: 'Order ORD-001 Revenue' }
    ]
  },
  {
    id: 'je-002',
    jeNumber: 'JE-0002',
    date: '2026-09-02T14:30:00Z',
    type: 'Auto',
    description: 'Cost of goods sold (Order ORD-001)',
    total: 10000000,
    status: 'Posted',
    sourceModule: 'Sales',
    sourceId: 'ORD-001',
    lines: [
      { id: 'jel-002a', accountId: 'acc-5000', debit: 10000000, credit: 0 },
      { id: 'jel-002b', accountId: 'acc-1210', debit: 0, credit: 10000000 }
    ]
  },
  {
    id: 'je-003',
    jeNumber: 'JE-0003',
    date: '2026-09-03T11:00:00Z',
    type: 'Auto',
    description: 'Commission accrued for ORD-001',
    total: 1250000,
    status: 'Posted',
    sourceModule: 'Commissions',
    sourceId: 'COM-001',
    lines: [
      { id: 'jel-003a', accountId: 'acc-6000', debit: 1250000, credit: 0, memo: 'Commission expense' },
      { id: 'jel-003b', accountId: 'acc-2110', debit: 0, credit: 1250000, memo: 'Commission liability' }
    ]
  }
];

export const mockPeriods: FinancialPeriod[] = [
  { id: 'fp-2026-07', name: 'July 2026', startDate: '2026-07-01', endDate: '2026-07-31', status: 'Closed', closedBy: 'admin', closedAt: '2026-08-01T10:00:00Z' },
  { id: 'fp-2026-08', name: 'August 2026', startDate: '2026-08-01', endDate: '2026-08-31', status: 'Closed', closedBy: 'admin', closedAt: '2026-09-01T12:00:00Z' },
  { id: 'fp-2026-09', name: 'September 2026', startDate: '2026-09-01', endDate: '2026-09-30', status: 'Open' },
];

export const mockExpenses = [
  { id: 'exp-1', expenseNumber: 'EXP-001', date: '2026-09-10T10:00:00Z', categoryId: 'acc-6000', payee: 'Office Supplies Inc', amount: 15000000, tax: 0, paidFromId: 'acc-1010', onCredit: false, status: 'Paid' },
  { id: 'exp-2', expenseNumber: 'EXP-002', date: '2026-09-12T10:00:00Z', categoryId: 'acc-6000', payee: 'Lagos Electric', amount: 8000000, tax: 0, onCredit: true, status: 'Approved' }
];

export const mockReceivables = [
  { id: 'rec-1', invoiceNumber: 'INV-001', partyId: 'merch-1', partyName: 'Emeka Stores', date: '2026-09-01', dueDate: '2026-09-15', amount: 25000000, balance: 25000000, status: 'Open' },
  { id: 'rec-2', invoiceNumber: 'INV-002', partyId: 'merch-2', partyName: 'Ada Boutiques', date: '2026-08-20', dueDate: '2026-09-03', amount: 15000000, balance: 5000000, status: 'Overdue' }
];

export const mockPayables = [
  { id: 'pay-1', invoiceNumber: 'SINV-001', partyId: 'sup-1', partyName: 'Global Raw Materials Ltd', date: '2026-09-05', dueDate: '2026-09-20', amount: 50000000, balance: 50000000, status: 'Open' },
  { id: 'pay-2', invoiceNumber: 'SINV-002', partyId: 'sup-2', partyName: 'Fast Transport Co', date: '2026-08-25', dueDate: '2026-09-09', amount: 12000000, balance: 12000000, status: 'Overdue' }
];

export const mockCommissionLedger: CommissionLedgerEntry[] = [
  {
    id: 'cfl-001',
    date: '2026-09-03T11:00:00Z',
    commissionId: 'COM-001',
    commissionNumber: 'COM-001',
    orderNumber: 'ORD-001',
    beneficiaryName: 'Aisha Bello',
    beneficiaryId: 'usr-492',
    level: 1,
    stage: 'Accrual',
    journalEntryNumber: 'JE-0003',
    debitAccount: { code: '6000', name: 'Operating Expenses (Referral Commission)' },
    creditAccount: { code: '2110', name: 'Commissions Payable' },
    amountInKobo: 1250000,
    runningPayableBalanceInKobo: 1250000,
    status: 'Posted',
    notes: 'Direct 5% referral commission on ORD-001',
  },
  {
    id: 'cfl-002',
    date: '2026-09-17T09:30:00Z',
    commissionId: 'COM-001',
    commissionNumber: 'COM-001',
    orderNumber: 'ORD-001',
    beneficiaryName: 'Aisha Bello',
    beneficiaryId: 'usr-492',
    level: 1,
    stage: 'Wallet Credited',
    journalEntryNumber: 'JE-0008',
    debitAccount: { code: '2110', name: 'Commissions Payable' },
    creditAccount: { code: '2100', name: 'Marketer Wallet Liability' },
    amountInKobo: 1250000,
    runningPayableBalanceInKobo: 0,
    status: 'Posted',
    notes: 'Cool-off completed; credited to user wallet for withdrawal or shopping',
  },
  {
    id: 'cfl-003',
    date: '2026-09-18T14:15:00Z',
    commissionId: 'COM-001',
    commissionNumber: 'PO-001',
    orderNumber: 'ORD-001',
    beneficiaryName: 'Aisha Bello',
    beneficiaryId: 'usr-492',
    level: 1,
    stage: 'Payout Disbursed',
    journalEntryNumber: 'JE-0012',
    debitAccount: { code: '2100', name: 'Marketer Wallet Liability' },
    creditAccount: { code: '1010', name: 'Bank Account' },
    amountInKobo: 1000000,
    runningPayableBalanceInKobo: 0,
    status: 'Posted',
    notes: 'Withdrawal disburse to GTBank via Paystack transfer',
  },
  {
    id: 'cfl-004',
    date: '2026-09-20T16:00:00Z',
    commissionId: 'COM-002',
    commissionNumber: 'COM-002',
    orderNumber: 'ORD-002',
    beneficiaryName: 'Michael Okon',
    beneficiaryId: 'usr-881',
    level: 1,
    stage: 'Accrual',
    journalEntryNumber: 'JE-0015',
    debitAccount: { code: '6000', name: 'Operating Expenses (Referral Commission)' },
    creditAccount: { code: '2110', name: 'Commissions Payable' },
    amountInKobo: 1800000,
    runningPayableBalanceInKobo: 1800000,
    status: 'Posted',
    notes: 'Direct 5% referral commission on ORD-002',
  },
  {
    id: 'cfl-005',
    date: '2026-09-21T10:45:00Z',
    commissionId: 'COM-003',
    commissionNumber: 'COM-003',
    orderNumber: 'ORD-002',
    beneficiaryName: 'Aisha Bello',
    beneficiaryId: 'usr-492',
    level: 2,
    stage: 'Accrual',
    journalEntryNumber: 'JE-0016',
    debitAccount: { code: '6000', name: 'Operating Expenses (Referral Commission)' },
    creditAccount: { code: '2110', name: 'Commissions Payable' },
    amountInKobo: 450000,
    runningPayableBalanceInKobo: 2250000,
    status: 'Posted',
    notes: 'Tier-2 network bonus on ORD-002 via direct sub-referral',
  },
  {
    id: 'cfl-006',
    date: '2026-09-22T12:00:00Z',
    commissionId: 'COM-004',
    commissionNumber: 'REV-001',
    orderNumber: 'ORD-004',
    beneficiaryName: 'Chidi Eze',
    beneficiaryId: 'usr-701',
    level: 1,
    stage: 'Reversed',
    journalEntryNumber: 'JE-0019',
    debitAccount: { code: '2110', name: 'Commissions Payable' },
    creditAccount: { code: '6000', name: 'Operating Expenses (Commission Clawback)' },
    amountInKobo: 800000,
    runningPayableBalanceInKobo: 1450000,
    status: 'Reversed',
    notes: 'Clawback due to customer order cancellation & refund',
  },
];
