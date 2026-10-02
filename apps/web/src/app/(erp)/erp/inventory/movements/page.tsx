'use client';

import { useState, useEffect } from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { AmountText } from '@/components/patterns/AmountText';
import { getStockMovements } from '@/features/inventory/api/inventory.api';
import { StockMovement } from '@/features/inventory/types';
import { toast } from 'sonner';
import { format } from 'date-fns';

export default function StockMovementsPage() {
  const [movements, setMovements] = useState<StockMovement[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  const fetchMovements = async () => {
    setIsLoading(true);
    try {
      const data = await getStockMovements();
      setMovements(data);
    } catch (err) {
      toast.error('Failed to load stock movements');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchMovements();
  }, []);

  const filtered = movements.filter(m => 
    m.productName.toLowerCase().includes(search.toLowerCase()) || 
    m.movementNo.toLowerCase().includes(search.toLowerCase()) ||
    m.sourceDocument.ref.toLowerCase().includes(search.toLowerCase())
  );

  const formatType = (type: string) => {
    return type.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
  };

  const columns = [
    { 
      accessorKey: 'date', 
      header: 'Date & Time',
      cell: (info: any) => {
        const m = info.row.original as StockMovement;
        const d = new Date(m.date);
        return (
          <div>
            <div className="font-medium text-sm">{format(d, 'MMM d, yyyy')}</div>
            <div className="text-text-muted text-xs">{format(d, 'HH:mm')}</div>
          </div>
        );
      }
    },
    { 
      accessorKey: 'movementNo', 
      header: 'Ref No.',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'type', 
      header: 'Type',
      cell: (info: any) => {
        const type = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted';
        if (type.includes('receipt') || type.includes('in') || type.includes('up')) color = 'bg-success-bg text-success border border-success-border';
        if (type.includes('issue') || type.includes('out') || type.includes('down')) color = 'bg-warning-bg text-warning-dark border border-warning-border';
        
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium ${color}`}>{formatType(type)}</span>;
      }
    },
    { 
      accessorKey: 'product', 
      header: 'Product',
      cell: (info: any) => {
        const m = info.row.original as StockMovement;
        return <span className="text-sm font-medium line-clamp-1">{m.productName}</span>;
      }
    },
    { 
      accessorKey: 'quantity', 
      header: 'Qty',
      cell: (info: any) => {
        const qty = info.getValue() as number;
        return (
          <span className={`font-medium ${qty > 0 ? 'text-success' : 'text-error'}`}>
            {qty > 0 ? '+' : ''}{qty}
          </span>
        );
      }
    },
    { 
      accessorKey: 'balanceAfter', 
      header: 'Balance',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'sourceDocument', 
      header: 'Source',
      cell: (info: any) => {
        const source = info.getValue() as { type: string, ref: string };
        return (
          <div>
            <div className="text-sm text-primary hover:underline cursor-pointer">{source.ref}</div>
            <div className="text-text-muted text-xs">{source.type}</div>
          </div>
        );
      }
    },
    { 
      accessorKey: 'userName', 
      header: 'User',
      cell: (info: any) => <span className="text-sm text-text-muted">{info.getValue()}</span>
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Stock Movements" 
        description="Append-only ledger of all inventory transactions and adjustments."
        action={
          <Button variant="outline">Export CSV</Button>
        }
      />

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="w-full max-w-md">
          <Input 
            placeholder="Search by product, movement ref, or source..." 
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
          emptyMessage="No stock movements found."
        />
      </div>
    </div>
  );
}
