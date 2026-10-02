'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { AmountText } from '@/components/patterns/AmountText';
import { getPurchaseOrders } from '@/features/procurement/api/procurement.api';
import { PurchaseOrder } from '@/features/procurement/types';
import { toast } from 'sonner';

export default function PurchaseOrdersPage() {
  const [orders, setOrders] = useState<PurchaseOrder[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  const fetchOrders = async () => {
    setIsLoading(true);
    try {
      const data = await getPurchaseOrders();
      setOrders(data);
    } catch (err) {
      toast.error('Failed to load purchase orders');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders();
  }, []);

  const filtered = orders.filter(o =>
    o.poNumber.toLowerCase().includes(search.toLowerCase()) ||
    o.supplierName.toLowerCase().includes(search.toLowerCase())
  );

  const columns = [
    {
      accessorKey: 'poNumber',
      header: 'PO #',
      cell: (info: any) => (
        <Link href={`/erp/procurement/orders/${info.getValue()}`} className="font-mono font-medium text-sm text-primary hover:underline">
          {info.getValue()}
        </Link>
      )
    },
    {
      accessorKey: 'supplierName',
      header: 'Supplier',
      cell: (info: any) => <span className="font-medium text-sm">{info.getValue()}</span>
    },
    {
      accessorKey: 'expectedDeliveryDate',
      header: 'Expected',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    {
      accessorKey: 'totalAmount',
      header: 'Total',
      cell: (info: any) => {
        const o = info.row.original as PurchaseOrder;
        return <span className="text-sm"><AmountText amountInKobo={info.getValue()} /></span>;
      }
    },
    {
      accessorKey: 'receivedPercentage',
      header: 'Received',
      cell: (info: any) => {
        const pct = info.getValue() as number;
        return (
          <div className="flex items-center gap-2">
            <div className="w-16 h-1.5 bg-surface-2 rounded-full overflow-hidden">
              <div className="h-full bg-success" style={{ width: `${pct}%` }}></div>
            </div>
            <span className="text-xs">{pct}%</span>
          </div>
        );
      }
    },
    {
      accessorKey: 'paymentStatus',
      header: 'Payment',
      cell: (info: any) => {
        const status = info.getValue() as string;
        let color = 'bg-error-bg text-error border-error-border';
        if (status === 'Paid') color = 'bg-success-bg text-success border-success-border';
        if (status === 'Partially Paid') color = 'bg-warning-bg text-warning-dark border-warning-border';
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium border ${color}`}>{status}</span>;
      }
    },
    {
      accessorKey: 'status',
      header: 'Status',
      cell: (info: any) => {
        const status = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted border-border';
        if (status === 'Ordered') color = 'bg-primary/10 text-primary border-primary/20';
        if (status === 'Partially Received') color = 'bg-warning-bg text-warning-dark border-warning-border';
        if (status === 'Received' || status === 'Closed') color = 'bg-success-bg text-success border-success-border';
        if (status === 'Cancelled') color = 'bg-error-bg text-error border-error-border';

        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium border ${color}`}>{status}</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        return (
          <div className="flex justify-end gap-1">
            <Link href={`/erp/procurement/orders/${info.row.original.poNumber}`}>
              <Button variant="ghost" size="sm" className="text-xs">View</Button>
            </Link>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader
        title="Purchase Orders"
        description="Track and manage orders issued to suppliers."
        action={
          <div className="flex gap-2">
            <Link href="/erp/procurement/orders/new">
              <Button>Create PO</Button>
            </Link>
          </div>
        }
      />

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="w-full max-w-md">
          <Input
            placeholder="Search PO number or supplier..."
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
          emptyMessage="No purchase orders found."
        />
      </div>
    </div>
  );
}
