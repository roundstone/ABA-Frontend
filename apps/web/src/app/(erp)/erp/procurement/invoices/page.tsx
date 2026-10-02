'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { AmountText } from '@/components/patterns/AmountText';
import { getSupplierInvoices } from '@/features/procurement/api/procurement.api';
import { SupplierInvoice } from '@/features/procurement/types';
import { toast } from 'sonner';

export default function SupplierInvoicesPage() {
  const [invoices, setInvoices] = useState<SupplierInvoice[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  const fetchInvoices = async () => {
    setIsLoading(true);
    try {
      const data = await getSupplierInvoices();
      setInvoices(data);
    } catch (err) {
      toast.error('Failed to load invoices');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchInvoices();
  }, []);

  const filtered = invoices.filter(i => 
    i.invoiceNumber.toLowerCase().includes(search.toLowerCase()) || 
    i.supplierInvoiceNo.toLowerCase().includes(search.toLowerCase()) ||
    i.supplierName.toLowerCase().includes(search.toLowerCase())
  );

  const columns = [
    { 
      accessorKey: 'invoiceNumber', 
      header: 'System Ref',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'supplierInvoiceNo', 
      header: 'Supplier Invoice #',
      cell: (info: any) => <span className="font-mono font-medium text-sm text-primary hover:underline cursor-pointer">{info.getValue()}</span>
    },
    { 
      accessorKey: 'supplierName', 
      header: 'Supplier',
      cell: (info: any) => <span className="font-medium text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'invoiceDate', 
      header: 'Date',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'dueDate', 
      header: 'Due',
      cell: (info: any) => <span className="text-sm text-error">{info.getValue()}</span>
    },
    { 
      accessorKey: 'totalAmount', 
      header: 'Amount',
      cell: (info: any) => <span className="text-sm font-medium"><AmountText amountInKobo={info.getValue()} /></span>
    },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const status = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted border-border';
        if (status === 'Approved') color = 'bg-success-bg text-success border-success-border';
        if (status === 'Matched' || status === 'Partially paid') color = 'bg-primary/10 text-primary border-primary/20';
        if (status === 'On hold' || status === 'Overdue') color = 'bg-error-bg text-error border-error-border';
        
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium border ${color}`}>{status}</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        return (
          <div className="flex justify-end gap-1">
            <Button variant="ghost" size="sm" className="text-xs">Pay</Button>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Supplier Invoices" 
        description="Match invoices to POs and Receipts (3-way match) before passing to Finance."
        action={
          <div className="flex gap-2">
            <Link href="/procurement/invoices/new">
              <Button>Log Invoice</Button>
            </Link>
          </div>
        }
      />

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="w-full max-w-md">
          <Input 
            placeholder="Search internal ref, supplier invoice #, or name..." 
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <div className="flex gap-2 w-full sm:w-auto">
          <Button variant="outline" className="flex-1 sm:flex-none">Filters</Button>
        </div>
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={filtered} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No supplier invoices found."
        />
      </div>
    </div>
  );
}
