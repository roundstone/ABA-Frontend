'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { getGRNs } from '@/features/procurement/api/procurement.api';
import { GoodsReceiptNote } from '@/features/procurement/types';
import { toast } from 'sonner';

export default function ReceivingPage() {
  const [grns, setGrns] = useState<GoodsReceiptNote[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  const fetchGRNs = async () => {
    setIsLoading(true);
    try {
      const data = await getGRNs();
      setGrns(data);
    } catch (err) {
      toast.error('Failed to load receipts');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchGRNs();
  }, []);

  const filtered = grns.filter(g => 
    g.grnNumber.toLowerCase().includes(search.toLowerCase()) || 
    g.poNumber.toLowerCase().includes(search.toLowerCase()) ||
    g.supplierName.toLowerCase().includes(search.toLowerCase())
  );

  const columns = [
    { 
      accessorKey: 'grnNumber', 
      header: 'GRN #',
      cell: (info: any) => <span className="font-mono font-medium text-sm text-primary hover:underline cursor-pointer">{info.getValue()}</span>
    },
    { 
      accessorKey: 'poNumber', 
      header: 'PO #',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'supplierName', 
      header: 'Supplier',
      cell: (info: any) => <span className="font-medium text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'receivingWarehouseName', 
      header: 'Received At',
      cell: (info: any) => <span className="text-sm text-text-muted">{info.getValue()}</span>
    },
    { 
      accessorKey: 'receivedDate', 
      header: 'Date',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const status = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted border-border';
        if (status === 'Posted') color = 'bg-success-bg text-success border-success-border';
        if (status === 'Voided') color = 'bg-error-bg text-error border-error-border';
        
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium border ${color}`}>{status}</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        return (
          <div className="flex justify-end gap-1">
            <Button variant="ghost" size="sm" className="text-xs">View</Button>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Goods Receipts (GRN)" 
        description="Track physical goods received against Purchase Orders."
        action={
          <div className="flex gap-2">
            <Link href="/erp/procurement/receiving/new">
              <Button>Receive Goods</Button>
            </Link>
          </div>
        }
      />

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="w-full max-w-md">
          <Input 
            placeholder="Search GRN, PO, or supplier..." 
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
          emptyMessage="No goods receipts found."
        />
      </div>
    </div>
  );
}
