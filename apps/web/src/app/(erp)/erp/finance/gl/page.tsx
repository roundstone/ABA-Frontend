'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { DataTable } from '@/components/patterns/DataTable';
import { AmountText } from '@/components/patterns/AmountText';

const MOCK_JOURNAL = [
  { id: 'JE-99014', date: '2026-09-30', description: 'Payment for Order ORD-10482', sourceDoc: 'PAY-89234', account: '1010 - Bank - GTB Main', dr: 16625000, cr: 0 },
  { id: 'JE-99014', date: '2026-09-30', description: 'Payment for Order ORD-10482', sourceDoc: 'PAY-89234', account: '1100 - Accounts Receivable', dr: 0, cr: 16625000 },
  
  { id: 'JE-99015', date: '2026-09-30', description: 'Commission Approval (Aisha Bello)', sourceDoc: 'COM-9912', account: '6200 - Commission Expense', dr: 4500000, cr: 0 },
  { id: 'JE-99015', date: '2026-09-30', description: 'Commission Approval (Aisha Bello)', sourceDoc: 'COM-9912', account: '2110 - Commissions Payable', dr: 0, cr: 4500000 },
];

export default function GeneralLedgerPage() {
  const columns = [
    { accessorKey: 'date', header: 'Date', cell: (info: any) => <span className="text-sm">{info.getValue()}</span> },
    { accessorKey: 'id', header: 'JE #', cell: (info: any) => <span className="font-mono text-primary cursor-pointer hover:underline text-sm">{info.getValue()}</span> },
    { accessorKey: 'sourceDoc', header: 'Source', cell: (info: any) => <span className="font-mono text-xs bg-surface-2 px-1.5 py-0.5 rounded border border-border">{info.getValue()}</span> },
    { accessorKey: 'account', header: 'Account', cell: (info: any) => <span className="font-medium text-sm">{info.getValue()}</span> },
    { accessorKey: 'description', header: 'Description', cell: (info: any) => <span className="text-sm">{info.getValue()}</span> },
    { 
      accessorKey: 'dr', 
      header: 'Debit (Dr)',
      cell: (info: any) => {
        const val = info.getValue();
        return val > 0 ? <span className="font-medium text-sm"><AmountText amountInKobo={val} /></span> : null;
      }
    },
    { 
      accessorKey: 'cr', 
      header: 'Credit (Cr)',
      cell: (info: any) => {
        const val = info.getValue();
        return val > 0 ? <span className="font-medium text-sm"><AmountText amountInKobo={val} /></span> : null;
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="General Ledger" 
        description="Master double-entry journal containing all system transactions."
        backHref="/erp/finance"
        action={
          <div className="flex gap-2">
            <Button variant="outline">Export GL</Button>
            <Button>Manual Journal Entry</Button>
          </div>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border flex flex-col md:flex-row justify-between items-start md:items-center gap-4 bg-surface-2">
          <h3 className="font-medium">Journal Entries</h3>
          <div className="flex gap-2 w-full md:w-auto">
            <Input placeholder="Search JE, doc ref, or amount..." className="h-9 w-full md:w-64 text-sm" />
            <Input type="date" className="h-9 text-sm" />
          </div>
        </div>
        <DataTable data={MOCK_JOURNAL} columns={columns} />
      </div>
    </div>
  );
}
