'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { FilterBar, FilterDefinition } from '@/components/patterns/FilterBar';
import { AmountText } from '@/components/patterns/AmountText';
import { getPurchaseRequests } from '@/features/procurement/api/procurement.api';
import { PurchaseRequest } from '@/features/procurement/types';
import { toast } from 'sonner';

export default function PurchaseRequestsPage() {
  const [requests, setRequests] = useState<PurchaseRequest[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [activeFilters, setActiveFilters] = useState<Record<string, any>>({});

  const fetchRequests = async () => {
    setIsLoading(true);
    try {
      const data = await getPurchaseRequests();
      setRequests(data);
    } catch (err) {
      toast.error('Failed to load purchase requests');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchRequests();
  }, []);

  const filterConfigs: FilterDefinition[] = [
    {
      key: 'status',
      label: 'Status',
      type: 'select',
      options: [
        { label: 'Awaiting Approval', value: 'Awaiting Approval' },
        { label: 'Approved', value: 'Approved' },
        { label: 'Converted', value: 'Converted' },
        { label: 'Rejected', value: 'Rejected' },
      ]
    },
    {
      key: 'urgency',
      label: 'Urgency',
      type: 'select',
      options: [
        { label: 'Normal', value: 'Normal' },
        { label: 'High', value: 'High' },
        { label: 'Critical', value: 'Critical' },
      ]
    }
  ];

  const handleFilterChange = (key: string, value: any) => {
    setActiveFilters(prev => ({
      ...prev,
      [key]: value
    }));
  };

  const handleClearFilters = () => {
    setActiveFilters({});
  };

  const filtered = requests.filter(r => {
    const matchesSearch = r.prNumber.toLowerCase().includes(search.toLowerCase()) || 
                          r.requesterName.toLowerCase().includes(search.toLowerCase());
    
    const matchesStatus = !activeFilters.status || r.status === activeFilters.status;
    const matchesUrgency = !activeFilters.urgency || r.urgency === activeFilters.urgency;

    return matchesSearch && matchesStatus && matchesUrgency;
  });

  const columns = [
    { 
      accessorKey: 'prNumber', 
      header: 'PR #',
      cell: (info: any) => <span className="font-mono font-medium text-sm text-primary">{info.getValue()}</span>
    },
    { 
      accessorKey: 'requesterName', 
      header: 'Requested By',
      cell: (info: any) => {
        const r = info.row.original as PurchaseRequest;
        return (
          <div>
            <div className="font-medium text-sm">{r.requesterName}</div>
            <div className="text-text-muted text-xs">{r.department}</div>
          </div>
        );
      }
    },
    { 
      accessorKey: 'deliverToLocationName', 
      header: 'Location',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'urgency', 
      header: 'Urgency',
      cell: (info: any) => {
        const u = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted';
        if (u === 'Normal') color = 'bg-primary/10 text-primary';
        if (u === 'High') color = 'bg-warning-bg text-warning-dark';
        if (u === 'Critical') color = 'bg-error-bg text-error';
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium ${color}`}>{u}</span>;
      }
    },
    { 
      accessorKey: 'estimatedTotal', 
      header: 'Est. Value',
      cell: (info: any) => <span className="text-sm"><AmountText amountInKobo={info.getValue()} /></span>
    },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const status = info.getValue() as string;
        let color = 'bg-surface-2 text-text-muted border-border';
        if (status === 'Awaiting Approval') color = 'bg-warning-bg text-warning-dark border-warning-border';
        if (status === 'Approved') color = 'bg-success-bg text-success border-success-border';
        if (status === 'Converted') color = 'bg-primary/10 text-primary border-primary/20';
        if (status === 'Rejected') color = 'bg-error-bg text-error border-error-border';
        
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
            <Button variant="ghost" size="sm" className="text-xs">Approve</Button>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Purchase Requests" 
        description="Review and approve internal requests for materials and goods."
        action={
          <div className="flex gap-2">
            <Link href="/erp/procurement/requests/new">
              <Button>Create Request</Button>
            </Link>
          </div>
        }
      />

      <FilterBar 
        searchPlaceholder="Search PR number or requester..."
        searchValue={search}
        onSearchChange={setSearch}
        filters={filterConfigs}
        activeFilters={activeFilters}
        onFilterChange={handleFilterChange}
        onClearFilters={handleClearFilters}
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={filtered} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No purchase requests found."
        />
      </div>
    </div>
  );
}
