export interface Account {
  id: string;
  code: string;
  name: string;
  type: 'Asset' | 'Liability' | 'Equity' | 'Revenue' | 'COGS' | 'Expense';
  subType?: string;
  normalBalance: 'Debit' | 'Credit';
  balance: number;
  active: boolean;
  system: boolean; // Cannot be deleted
  allowManualPosting: boolean;
}

export interface JournalLine {
  id: string;
  accountId: string;
  debit: number;
  credit: number;
  memo?: string;
  partyId?: string; // e.g. Customer, Supplier
}

export interface JournalEntry {
  id: string;
  jeNumber: string;
  date: string;
  type: 'Auto' | 'Manual' | 'Reversal';
  description: string;
  lines: JournalLine[];
  total: number;
  status: 'Draft' | 'Awaiting Approval' | 'Posted' | 'Reversed' | 'Rejected';
  sourceModule?: string;
  sourceId?: string; // EntityLink
  postedBy?: string;
}

export interface FinancialPeriod {
  id: string;
  name: string;
  startDate: string;
  endDate: string;
  status: 'Open' | 'Closing' | 'Closed' | 'Locked';
  closedBy?: string;
  closedAt?: string;
}

export interface FinanceKPIs {
  revenue: number;
  cogs: number;
  grossProfit: number;
  operatingExpenses: number;
  netProfit: number;
  cashAndBank: number;
  receivables: number;
  payables: number;
  commissionsPayable: number;
}

export interface Expense {
  id: string;
  expenseNumber: string;
  date: string;
  categoryId: string; // Account ID
  payee: string;
  amount: number;
  tax: number;
  paidFromId?: string; // Account ID
  onCredit: boolean;
  reference?: string;
  costCenter?: string;
  notes?: string;
  status: 'Draft' | 'Awaiting Approval' | 'Approved' | 'Paid' | 'Rejected';
}

export interface Invoice {
  id: string;
  invoiceNumber: string;
  partyId: string;
  partyName: string;
  date: string;
  dueDate: string;
  amount: number;
  balance: number;
  status: 'Open' | 'Partially Paid' | 'Paid' | 'Overdue' | 'Written off';
}

export type Receivable = Invoice;
export type Payable = Invoice;
