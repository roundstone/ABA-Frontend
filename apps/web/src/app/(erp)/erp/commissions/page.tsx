'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { DataTable } from '@/components/patterns/DataTable';
import { AmountText } from '@/components/patterns/AmountText';

const MOCK_COMMISSIONS = [
  { id: 'COM-9912', date: '2026-09-30', beneficiary: 'Aisha Bello (ABA-492)', sourceOrder: 'ORD-10482', level: 'L2', margin: 500000, rate: '30% of L2 (9%)', amount: 45000, status: 'Pending Approval' },
  { id: 'COM-9911', date: '2026-09-30', beneficiary: 'Michael Okon (ABA-881)', sourceOrder: 'ORD-10482', level: 'L1', margin: 500000, rate: '60% of L1 (18%)', amount: 90000, status: 'Pending Approval' },
  { id: 'COM-9910', date: '2026-09-29', beneficiary: 'John Doe (ABA-112)', sourceOrder: 'ORD-10470', level: 'L1', margin: 120000, rate: '60% of L1 (18%)', amount: 21600, status: 'Approved (Unpaid)' },
  { id: 'COM-9892', date: '2026-09-28', beneficiary: 'Aisha Bello (ABA-492)', sourceOrder: 'ORD-10421', level: 'L3', margin: 800000, rate: '10% of L3 (3%)', amount: 24000, status: 'Paid' },
];

export default function CommissionsLedgerPage() {
  const columns = [
    { accessorKey: 'id', header: 'COM #' },
    { accessorKey: 'date', header: 'Date' },
    { accessorKey: 'beneficiary', header: 'Beneficiary' },
    { 
      accessorKey: 'sourceOrder', 
      header: 'Source Order',
      cell: (info: any) => <span className="font-mono text-primary cursor-pointer hover:underline">{info.getValue()}</span>
    },
    { accessorKey: 'level', header: 'Network Level' },
    { 
      accessorKey: 'amount', 
      header: 'Commission Earned',
      cell: (info: any) => <span className="font-bold text-success"><AmountText amountInKobo={info.getValue() * 100} /></span>
    },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const s = info.getValue();
        let color = 'bg-surface-2 text-text-muted';
        if (s === 'Paid') color = 'bg-success-bg text-success border-success-border border';
        if (s === 'Pending Approval') color = 'bg-warning-bg text-warning-dark border-warning-border border';
        if (s === 'Approved (Unpaid)') color = 'bg-primary/10 text-primary border-primary/20 border';
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium ${color}`}>{s}</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        const s = info.row.original.status;
        return (
          <div className="flex justify-end gap-2">
            {s === 'Pending Approval' && <Button variant="outline" size="sm" className="h-7 text-xs border-success text-success hover:bg-success hover:text-white">Approve</Button>}
            <Button variant="ghost" size="sm" className="h-7 text-xs">View</Button>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Commission Ledger" 
        description="Master record of all generated commissions and liabilities."
        action={
          <div className="flex gap-2">
            <Button variant="outline">Approvals Queue</Button>
            <Button variant="outline">Export GL</Button>
          </div>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border flex justify-between items-center bg-surface-2">
          <h3 className="font-medium">All Commission Records</h3>
          <div className="flex gap-2">
            <Input placeholder="Search beneficiary or order..." className="h-9 w-64 text-sm" />
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
              <option>All Statuses</option>
              <option>Pending Approval</option>
              <option>Approved (Unpaid)</option>
              <option>Paid</option>
            </select>
          </div>
        </div>
        <DataTable data={MOCK_COMMISSIONS} columns={columns} />
      </div>
    </div>
  );
}
