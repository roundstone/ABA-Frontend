'use client';

import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { DataTable } from '@/components/patterns/DataTable';
import { KpiCard } from '@/components/patterns/KpiCard';

const MOCK_PRODUCTION = [
  { id: 'MFG-2004', product: 'Premium Rice 50kg', targetQty: 1000, yieldQty: 0, date: '2026-10-01', status: 'Planned' },
  { id: 'MFG-2003', product: 'Parboiled Rice 25kg', targetQty: 500, yieldQty: 240, date: '2026-09-30', status: 'In Progress' },
  { id: 'MFG-2002', product: 'Premium Rice 50kg', targetQty: 800, yieldQty: 795, date: '2026-09-28', status: 'Completed' },
  { id: 'MFG-2001', product: 'Rice Bran 10kg', targetQty: 200, yieldQty: 180, date: '2026-09-27', status: 'Completed' },
];

export default function ProductionPage() {
  const columns = [
    { 
      accessorKey: 'id', 
      header: 'Order #',
      cell: (info: any) => <Link href={`/erp/production/${info.getValue()}`} className="font-mono font-medium text-primary hover:underline">{info.getValue()}</Link>
    },
    { accessorKey: 'date', header: 'Start Date' },
    { accessorKey: 'product', header: 'Finished Product', cell: (info: any) => <span className="font-medium">{info.getValue()}</span> },
    { accessorKey: 'targetQty', header: 'Target Yield' },
    { accessorKey: 'yieldQty', header: 'Actual Yield' },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const s = info.getValue();
        let color = 'bg-surface-2 text-text-muted';
        if (s === 'Completed') color = 'bg-success-bg text-success border-success-border border';
        if (s === 'In Progress') color = 'bg-warning-bg text-warning-dark border-warning-border border';
        if (s === 'Planned') color = 'bg-primary/10 text-primary border-primary/20 border';
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
            <Link href={`/erp/production/${id}`}>
              <Button variant="ghost" size="sm" className="h-7 text-xs">Manage</Button>
            </Link>
          </div>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20 max-w-7xl mx-auto">
      <PageHeader 
        title="Production & Manufacturing" 
        description="Manage production runs, raw material consumption, and finished goods yield."
        action={
          <div className="flex gap-2">
            <Button variant="outline">Formulas (BOM)</Button>
            <Link href="/erp/production/new">
              <Button>New Production Order</Button>
            </Link>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Active Runs" value="3" className="text-warning-dark" />
        <KpiCard title="Units Produced (Week)" value="4,250" className="text-success" />
        <KpiCard title="Yield Efficiency" value="98.4%" />
        <KpiCard title="Raw Material Shortages" value="1 Item" className="text-error" />
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border flex justify-between items-center bg-surface-2">
          <h3 className="font-medium">Production Orders</h3>
          <div className="flex gap-2">
            <Input placeholder="Search batch or product..." className="h-9 w-64 text-sm" />
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary">
              <option>All Statuses</option>
              <option>Planned</option>
              <option>In Progress</option>
              <option>Completed</option>
            </select>
          </div>
        </div>
        <DataTable data={MOCK_PRODUCTION} columns={columns} />
      </div>
    </div>
  );
}
