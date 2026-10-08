import { Account, FinanceKPIs, JournalEntry, FinancialPeriod, Expense, Receivable, Payable } from './types';
import { mockAccounts, mockJournals, mockPeriods, mockExpenses, mockReceivables, mockPayables } from './mocks';

let accounts = [...mockAccounts];
let journals = [...mockJournals];
let periods = [...mockPeriods];

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

export async function getChartOfAccounts(): Promise<{ data: Account[] }> {
  await delay(300);
  return { data: accounts };
}

export async function getGeneralLedger(): Promise<{ data: JournalEntry[] }> {
  await delay(300);
  return { data: journals };
}

export async function getFinancialPeriods(): Promise<{ data: FinancialPeriod[] }> {
  await delay(300);
  return { data: periods };
}

export async function getFinanceKPIs(): Promise<FinanceKPIs> {
  await delay(300);
  return {
    revenue: 2500000000,
    cogs: 1100000000,
    grossProfit: 1400000000,
    operatingExpenses: 450000000,
    netProfit: 950000000,
    cashAndBank: 1250000000,
    receivables: 450000000,
    payables: 320000000,
    commissionsPayable: 82000000
  };
}

export async function getExpenses(): Promise<{ data: Expense[] }> {
  await delay(300);
  return { data: [...mockExpenses] as Expense[] };
}

export async function getReceivables(): Promise<{ data: Receivable[] }> {
  await delay(300);
  return { data: [...mockReceivables] as Receivable[] };
}

export async function getPayables(): Promise<{ data: Payable[] }> {
  await delay(300);
  return { data: [...mockPayables] as Payable[] };
}

// Additional mutation functions would go here
