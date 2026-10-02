'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { KpiCard } from '@/components/patterns/KpiCard';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { AmountText } from '@/components/patterns/AmountText';
import { getPayments } from '@/features/payments/api/payments.api';
import { Payment } from '@/features/payments/types';
import { toast } from 'sonner';

export default function PaymentsPage() {
  const [payments, setPayments] = useState<Payment[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  const fetchPayments = async () => {
    setIsLoading(true);
    try {
      const data = await getPayments();
      setPayments(data);
    } catch (err) {
      toast.error('Failed to load payments');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchPayments();
  }, []);

  const filtered = payments.filter(p => 
    p.referenceNumber.toLowerCase().includes(search.toLowerCase()) || 
    p.partyName.toLowerCase().includes(search.toLowerCase())
  );

  const columns = [
    { 
      accessorKey: 'referenceNumber', 
      header: 'Payment #',
      cell: (info: any) => (
        <Link href={`/payments/${info.getValue()}`} className="font-mono font-medium text-sm text-primary hover:underline">
          {info.getValue()}
        </Link>
      )
    },
    { 
      accessorKey: 'paymentDate', 
      header: 'Date',
      cell: (info: any) => {
        const d = new Date(info.getValue());
        return <span className="text-sm">{d.toLocaleDateString()}</span>;
      }
    },
    { 
      accessorKey: 'type', 
      header: 'Type',
      cell: (info: any) => {
        const type = info.getValue();
        const row = info.row.original as Payment;
        return (
          <div>
            <span className="text-sm font-medium">{type}</span>
            <div className="text-[10px] text-text-muted mt-0.5 border border-border px-1 py-0.5 rounded inline-block bg-surface-2 uppercase">
              {row.direction}
            </div>
          </div>
        );
      }
    },
    { 
      accessorKey: 'partyName', 
      header: 'Party',
      cell: (info: any) => <span className="font-medium text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'method', 
      header: 'Method',
      cell: (info: any) => {
        const row = info.row.original as Payment;
        return (
          <div>
            <span className="text-sm">{info.getValue()}</span>
            {row.bankReference && <div className="text-[10px] text-text-muted font-mono truncate max-w-[120px]" title={row.bankReference}>{row.bankReference}</div>}
          </div>
        );
      }
    },
    { 
      accessorKey: 'amount', 
      header: 'Amount',
      cell: (info: any) => {
        const row = info.row.original as Payment;
        return (
          <span className={`text-sm font-medium ${row.direction === 'In' ? 'text-success' : 'text-text'}`}>
            {row.direction === 'In' ? '+' : '-'}<AmountText amountInKobo={info.getValue()} />
          </span>
        );
      }
    },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const status = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted border-border';
        if (status === 'Completed') color = 'bg-success-bg text-success border-success-border';
        if (status === 'Pending') color = 'bg-warning-bg text-warning-dark border-warning-border';
        if (status === 'Failed') color = 'bg-error-bg text-error border-error-border';
        
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium border ${color}`}>{status}</span>;
      }
    },
    { 
      accessorKey: 'isReconciled', 
      header: 'Reconciled',
      cell: (info: any) => {
        return info.getValue() ? 
          <span className="text-success font-bold">✓</span> : 
          <span className="text-text-muted text-xs">No</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        const row = info.row.original as Payment;
        return (
          <div className="flex justify-end gap-1">
            {row.status === 'Pending' && <Button variant="outline" size="sm" className="text-xs h-7 px-2 border-success text-success hover:bg-success hover:text-white">Confirm</Button>}
            <Link href={`/erp/payments/${row.referenceNumber}`}>
              <Button variant="ghost" size="sm" className="text-xs h-7 px-2">View</Button>
            </Link>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Payments Ledger" 
        description="Global view of all money in and money out."
        action={
          <div className="flex gap-2">
            <Button variant="outline">Export CSV</Button>
            <Button>Record Payment</Button>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Collected (Today)" value={<AmountText amountInKobo={19312500} />} className="text-success" />
        <KpiCard title="Pending Transfers" value={<AmountText amountInKobo={16625000} />} className="text-warning-dark" />
        <KpiCard title="Payouts (Today)" value={<AmountText amountInKobo={0} />} />
        <KpiCard title="Unreconciled" value="14 items" />
      </div>

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="w-full max-w-md">
          <Input 
            placeholder="Search payment reference or party..." 
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <div className="flex gap-2 w-full sm:w-auto">
          <select className="flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm">
            <option value="All">All Types</option>
            <option value="Order">Orders</option>
            <option value="Supplier">Supplier Invoices</option>
            <option value="Refund">Refunds</option>
          </select>
          <Button variant="outline" className="flex-1 sm:flex-none">More Filters</Button>
        </div>
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={filtered} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No payments found."
        />
      </div>
    </div>
  );
}
