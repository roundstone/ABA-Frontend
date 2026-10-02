'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { AmountText } from '@/components/patterns/AmountText';
import { getSuppliers } from '@/features/suppliers/api/suppliers.api';
import { Supplier } from '@/features/suppliers/types';
import { toast } from 'sonner';

export default function SuppliersListPage() {
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  const fetchSuppliers = async () => {
    setIsLoading(true);
    try {
      const data = await getSuppliers();
      setSuppliers(data);
    } catch (err) {
      toast.error('Failed to load suppliers');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchSuppliers();
  }, []);

  const filteredSuppliers = suppliers.filter(s => 
    s.companyName.toLowerCase().includes(search.toLowerCase()) || 
    s.supplierNo.toLowerCase().includes(search.toLowerCase()) ||
    s.contactPerson.toLowerCase().includes(search.toLowerCase())
  );

  const renderStars = (rating: number) => {
    if (rating === 0) return <span className="text-xs text-text-muted">Unrated</span>;
    return (
      <div className="flex items-center gap-1">
        <span className="text-warning-dark">★</span>
        <span className="text-sm font-medium">{rating.toFixed(1)}</span>
      </div>
    );
  };

  const columns = [
    { 
      accessorKey: 'supplier', 
      header: 'Supplier',
      cell: (info: any) => {
        const s = info.row.original as Supplier;
        return (
          <div>
            <div className="font-medium">{s.companyName}</div>
            <div className="text-text-muted text-xs">{s.supplierNo} • {s.type}</div>
          </div>
        );
      }
    },
    { 
      accessorKey: 'contact', 
      header: 'Contact',
      cell: (info: any) => {
        const s = info.row.original as Supplier;
        return (
          <div>
            <div className="text-sm">{s.contactPerson}</div>
            <div className="text-text-muted text-xs">{s.phone}</div>
          </div>
        );
      }
    },
    { 
      accessorKey: 'paymentTerms', 
      header: 'Terms',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'outstandingBalance', 
      header: 'Balance',
      cell: (info: any) => {
        const s = info.row.original as Supplier;
        return (
          <div>
            <div className="text-sm font-medium"><AmountText amountInKobo={s.outstandingBalance} /></div>
            {s.overduePayable > 0 && (
              <div className="text-error text-xs">{s.currency} {(s.overduePayable / 100).toLocaleString()} overdue</div>
            )}
          </div>
        );
      }
    },
    { 
      accessorKey: 'rating', 
      header: 'Rating',
      cell: (info: any) => renderStars(info.getValue())
    },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const status = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted border-border';
        if (status === 'Active') color = 'bg-success-bg text-success border-success-border';
        if (status === 'On hold') color = 'bg-warning-bg text-warning-dark border-warning-border';
        if (status === 'Blacklisted') color = 'bg-error-bg text-error border-error-border';
        
        return <span className={`px-2 py-0.5 rounded text-xs font-medium border ${color}`}>{status}</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        const s = info.row.original as Supplier;
        return (
          <div className="flex justify-end gap-1">
            <Link href={`/erp/suppliers/${s.id}`}>
              <Button variant="ghost" size="sm">View</Button>
            </Link>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Suppliers" 
        description="Manage vendors, payment terms, and monitor supply performance."
        action={
          <Link href="/erp/suppliers/new">
            <Button>Add Supplier</Button>
          </Link>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
        {/* KPI Strip per §5.5 */}
        <div className="bg-surface p-4 rounded-xl border border-border">
          <div className="text-text-muted text-xs mb-1">Active Suppliers</div>
          <div className="text-xl font-medium">{suppliers.filter(s => s.status === 'Active').length}</div>
        </div>
        <div className="bg-surface p-4 rounded-xl border border-border">
          <div className="text-text-muted text-xs mb-1">Total Payable</div>
          <div className="text-xl font-medium"><AmountText amountInKobo={suppliers.reduce((acc, s) => acc + s.outstandingBalance, 0)} /></div>
        </div>
        <div className="bg-surface p-4 rounded-xl border border-border bg-error-bg/30">
          <div className="text-error text-xs mb-1">Overdue Payable</div>
          <div className="text-xl font-medium text-error"><AmountText amountInKobo={suppliers.reduce((acc, s) => acc + s.overduePayable, 0)} /></div>
        </div>
        <div className="bg-surface p-4 rounded-xl border border-border">
          <div className="text-text-muted text-xs mb-1">Spend (12m)</div>
          <div className="text-xl font-medium"><AmountText amountInKobo={suppliers.reduce((acc, s) => acc + s.totalPurchases12m, 0)} /></div>
        </div>
        <div className="bg-surface p-4 rounded-xl border border-border">
          <div className="text-text-muted text-xs mb-1">Avg Lead Time</div>
          <div className="text-xl font-medium">~14 days</div>
        </div>
      </div>

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="w-full max-w-md">
          <Input 
            placeholder="Search by company, contact, or ID..." 
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
          data={filteredSuppliers} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No suppliers found."
        />
      </div>
    </div>
  );
}
