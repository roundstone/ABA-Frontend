'use client';
import { brand } from '@/config/brand';


import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { KpiCard } from '@/components/patterns/KpiCard';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { DataTable } from '@/components/patterns/DataTable';

const MOCK_REFERRALS = [
  { id: 'REF-1002', referrer: `Aisha Bello (${brand.referralCodePrefix}492)`, referee: 'Michael Okon', source: 'Link', level: 'L1', date: '2026-09-30', status: 'Qualified', comm: 215000 },
  { id: 'REF-1003', referrer: `Michael Okon (${brand.referralCodePrefix}881)`, referee: 'Sarah Jane', source: 'POS Code', level: 'L2', date: '2026-09-29', status: 'Pending Qualification', comm: 0 },
  { id: 'REF-1004', referrer: `John Doe (${brand.referralCodePrefix}112)`, referee: 'Musa Ibrahim', source: 'Link', level: 'L1', date: '2026-09-28', status: 'Flagged', comm: 0 },
];

export default function ReferralsDashboardPage() {
  const columns = [
    { accessorKey: 'id', header: 'Ref #' },
    { accessorKey: 'referrer', header: 'Referrer (Upline)' },
    { accessorKey: 'referee', header: 'Referred Customer' },
    { accessorKey: 'level', header: 'Network Level' },
    { accessorKey: 'source', header: 'Source' },
    { accessorKey: 'date', header: 'Date Referred' },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const s = info.getValue();
        let color = 'bg-surface-2 text-text-muted';
        if (s === 'Qualified') color = 'bg-success-bg text-success border border-success-border';
        if (s === 'Pending Qualification') color = 'bg-warning-bg text-warning-dark border border-warning-border';
        if (s === 'Flagged') color = 'bg-error-bg text-error border border-error-border';
        return <span className={`px-2 py-0.5 rounded text-xs font-medium ${color}`}>{s}</span>;
      }
    },
    {
      id: 'actions',
      header: '',
      cell: () => (
        <div className="flex justify-end">
          <Button variant="ghost" size="sm" className="h-8 text-xs">View</Button>
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Referrals Dashboard" 
        description="Monitor network growth, qualifications, and flagged activities."
        action={
          <div className="flex gap-2">
            <Link href="/erp/referrals/network">
              <Button variant="outline">Network Tree Explorer</Button>
            </Link>
            <Link href="/erp/commissions/rules">
              <Button>Commission Rules</Button>
            </Link>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Total Referrers" value="1,248" />
        <KpiCard title="Qualified Referrals" value="8,930" className="text-success" />
        <KpiCard title="Conversion Rate" value="68.4%" />
        <KpiCard title="Flagged / Suspicious" value="12" className="text-error" />
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border flex justify-between items-center bg-surface-2">
          <h3 className="font-medium">Recent Referrals</h3>
          <div className="flex gap-2">
            <Input placeholder="Search code or name..." className="h-9 w-64 text-sm" />
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary">
              <option>All Statuses</option>
              <option>Qualified</option>
              <option>Pending</option>
              <option>Flagged</option>
            </select>
          </div>
        </div>
        <DataTable data={MOCK_REFERRALS} columns={columns} />
      </div>
    </div>
  );
}
