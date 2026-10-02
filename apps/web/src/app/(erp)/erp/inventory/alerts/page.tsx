'use client';

import { useState, useEffect } from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { getStockLevels } from '@/features/inventory/api/inventory.api';
import { StockLevel } from '@/features/inventory/types';
import { toast } from 'sonner';

export default function StockAlertsPage() {
  const [alerts, setAlerts] = useState<StockLevel[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  const fetchAlerts = async () => {
    setIsLoading(true);
    try {
      const data = await getStockLevels();
      // Filter for items at or below reorder level
      const criticalStock = data.filter(s => s.onHand <= s.reorderLevel);
      setAlerts(criticalStock);
    } catch (err) {
      toast.error('Failed to load stock alerts');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchAlerts();
  }, []);

  const columns = [
    { 
      accessorKey: 'product', 
      header: 'Product',
      cell: (info: any) => {
        const s = info.row.original as StockLevel;
        return (
          <div>
            <div className="font-medium text-sm line-clamp-1">{s.productName}</div>
            <div className="text-text-muted text-xs">{s.sku}</div>
          </div>
        );
      }
    },
    { 
      accessorKey: 'locationName', 
      header: 'Location',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'onHand', 
      header: 'On Hand',
      cell: (info: any) => {
        const qty = info.getValue() as number;
        return <span className={`font-medium text-sm ${qty === 0 ? 'text-error' : 'text-warning-dark'}`}>{qty}</span>;
      }
    },
    { 
      accessorKey: 'reorderLevel', 
      header: 'Reorder Level',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'deficit', 
      header: 'Deficit',
      cell: (info: any) => {
        const s = info.row.original as StockLevel;
        const deficit = s.reorderLevel - s.onHand;
        return <span className="text-error font-medium text-sm">-{deficit}</span>;
      }
    },
    { 
      accessorKey: 'pipeline', 
      header: 'In Pipeline',
      cell: (info: any) => {
        const s = info.row.original as StockLevel;
        const totalIncoming = s.inTransit + s.onOrder;
        if (totalIncoming === 0) return <span className="text-error text-xs font-medium">None</span>;
        return <span className="text-success text-xs font-medium">+{totalIncoming} Incoming</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        return (
          <div className="flex justify-end">
            <Button size="sm">Create PR</Button>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Stock Alerts" 
        description="Monitor products that have fallen below their safety reorder thresholds."
        action={
          <Button>Bulk Create Purchase Requests</Button>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={alerts} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No stock alerts! All inventory is at healthy levels."
        />
      </div>
    </div>
  );
}
