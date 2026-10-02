'use client';

import { useState, useEffect } from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { getWarehouses } from '@/features/inventory/api/inventory.api';
import { Warehouse } from '@/features/inventory/types';
import { toast } from 'sonner';

export default function WarehousesPage() {
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  const fetchWarehouses = async () => {
    setIsLoading(true);
    try {
      const data = await getWarehouses();
      setWarehouses(data);
    } catch (err) {
      toast.error('Failed to load warehouses');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchWarehouses();
  }, []);

  const filtered = warehouses.filter(w => 
    w.name.toLowerCase().includes(search.toLowerCase()) || 
    w.type.toLowerCase().includes(search.toLowerCase())
  );

  const columns = [
    { 
      accessorKey: 'name', 
      header: 'Warehouse Name',
      cell: (info: any) => <span className="font-medium text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'type', 
      header: 'Type',
      cell: (info: any) => {
        const type = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted';
        if (type === 'Central') color = 'bg-primary/10 text-primary border border-primary/20';
        if (type === 'Production') color = 'bg-warning-bg text-warning-dark border border-warning-border';
        if (type === 'Shop') color = 'bg-success-bg text-success border border-success-border';
        if (type === 'Quarantine') color = 'bg-error-bg text-error border border-error-border';
        
        return <span className={`px-2 py-0.5 rounded text-xs font-medium ${color}`}>{type}</span>;
      }
    },
    { 
      accessorKey: 'address', 
      header: 'Address',
      cell: (info: any) => <span className="text-sm text-text-muted line-clamp-1">{info.getValue()}</span>
    },
    { 
      accessorKey: 'isActive', 
      header: 'Status',
      cell: (info: any) => (
        <span className={`text-xs font-medium px-2 py-1 rounded ${info.getValue() ? 'bg-success-bg text-success' : 'bg-surface-2 text-text-muted'}`}>
          {info.getValue() ? 'Active' : 'Inactive'}
        </span>
      )
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        return (
          <div className="flex justify-end gap-1">
            <Button variant="ghost" size="sm" className="text-xs">Edit</Button>
            <Button variant="ghost" size="sm" className="text-xs">View Stock</Button>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Warehouses & Locations" 
        description="Manage storage facilities, retail locations, and production floors."
        action={
          <Button>Add Location</Button>
        }
      />

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="w-full max-w-md">
          <Input 
            placeholder="Search locations..." 
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={filtered} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No warehouses found."
        />
      </div>
    </div>
  );
}
