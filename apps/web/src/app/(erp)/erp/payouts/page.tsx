'use client';

import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { DataTable } from '@/components/patterns/DataTable';
import { AmountText } from '@/components/patterns/AmountText';

const MOCK_PAYOUTS = [
  { id: 'PYT-4029', requested: '2026-09-30 08:14', payee: 'Aisha Bello', source: 'Commission', amount: 15000000, fee: 5000, net: 14995000, bank: 'GTBank ••••4192', status: 'Pending Approval' },
  { id: 'PYT-4028', requested: '2026-09-29 16:30', payee: 'ABA Surulere Branch', source: 'Merchant Settlement', amount: 48500000, fee: 0, net: 48500000, bank: 'Zenith ••••9912', status: 'Processing' },
  { id: 'PYT-4027', requested: '2026-09-28 11:20', payee: 'John Doe', source: 'Wallet', amount: 500000, fee: 5000, net: 495000, bank: 'FirstBank ••••1102', status: 'Paid' },
];

export default function PayoutsPage() {
  const columns = [
    { 
      accessorKey: 'id', 
      header: 'Payout #',
      cell: (info: any) => <Link href={`/erp/payouts/${info.getValue()}`} className="font-mono font-medium text-primary hover:underline">{info.getValue()}</Link>
    },
    { accessorKey: 'requested', header: 'Requested Date' },
    { accessorKey: 'payee', header: 'Payee' },
    { 
      accessorKey: 'source', 
      header: 'Source',
      cell: (info: any) => <span className="text-xs bg-surface-2 border border-border px-2 py-0.5 rounded">{info.getValue()}</span>
    },
    { 
      accessorKey: 'net', 
      header: 'Net Transfer',
      cell: (info: any) => <span className="font-medium"><AmountText amountInKobo={info.getValue()} /></span>
    },
    { accessorKey: 'bank', header: 'Destination', cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span> },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const s = info.getValue();
        let color = 'bg-surface-2 text-text-muted';
        if (s === 'Paid') color = 'bg-success-bg text-success border-success-border border';
        if (s === 'Pending Approval') color = 'bg-warning-bg text-warning-dark border-warning-border border';
        if (s === 'Processing') color = 'bg-primary/10 text-primary border-primary/20 border';
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium ${color}`}>{s}</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        const id = info.row.original.id;
        return (
          <div className="flex justify-end">
            <Link href={`/erp/payouts/${id}`}>
              <Button variant="ghost" size="sm" className="h-7 text-xs">Review</Button>
            </Link>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Payouts & Withdrawals" 
        description="Manage commission withdrawals, wallet cashouts, and merchant settlements."
        action={
          <div className="flex gap-2">
            <Button variant="outline">Export Bank CSV</Button>
            <Button>Approve Batch (0)</Button>
          </div>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border flex justify-between items-center bg-surface-2">
          <h3 className="font-medium">Payout Requests</h3>
          <div className="flex gap-2">
            <Input placeholder="Search payee or bank..." className="h-9 w-64 text-sm" />
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
              <option>All Types</option>
              <option>Commission</option>
              <option>Wallet</option>
              <option>Settlement</option>
            </select>
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
              <option>All Statuses</option>
              <option>Pending</option>
              <option>Processing</option>
              <option>Paid</option>
            </select>
          </div>
        </div>
        <DataTable data={MOCK_PAYOUTS} columns={columns} />
      </div>
    </div>
  );
}
