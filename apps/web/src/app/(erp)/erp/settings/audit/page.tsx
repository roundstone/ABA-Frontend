'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { DataTable } from '@/components/patterns/DataTable';
import Link from 'next/link';

const MOCK_AUDIT = [
  { id: 'EVT-99230', time: '2026-09-30 14:22:15', user: 'Admin User (U-001)', action: 'payouts.approve', module: 'Payouts', record: 'PYT-4029', ip: '192.168.1.45', diff: 'status: "Pending" → "Approved"' },
  { id: 'EVT-99229', time: '2026-09-30 14:18:02', user: 'System Worker', action: 'commissions.process', module: 'Commissions', record: 'COM-9912', ip: 'internal', diff: 'Created commission record' },
  { id: 'EVT-99228', time: '2026-09-30 12:05:44', user: 'Finance Manager (U-014)', action: 'finance.journal_create', module: 'Finance', record: 'JE-99014', ip: '10.0.0.12', diff: 'Manual journal entry created' },
  { id: 'EVT-99227', time: '2026-09-30 10:11:00', user: 'David Mark (U-082)', action: 'production.yield_record', module: 'Production', record: 'MFG-2003', ip: '192.168.1.102', diff: 'yieldQty: 0 → 240' },
];

export default function AuditLogPage() {
  const columns = [
    { accessorKey: 'time', header: 'Timestamp', cell: (info: any) => <span className="text-xs font-mono">{info.getValue()}</span> },
    { accessorKey: 'user', header: 'User', cell: (info: any) => <span className="font-medium text-sm">{info.getValue()}</span> },
    { accessorKey: 'module', header: 'Module', cell: (info: any) => <span className="text-xs uppercase tracking-wider">{info.getValue()}</span> },
    { accessorKey: 'action', header: 'Action', cell: (info: any) => <span className="font-mono text-xs text-primary">{info.getValue()}</span> },
    { 
      accessorKey: 'record', 
      header: 'Record Ref',
      cell: (info: any) => <span className="font-mono text-xs border border-border px-1.5 py-0.5 rounded bg-surface-2">{info.getValue()}</span> 
    },
    { accessorKey: 'diff', header: 'Change Summary', cell: (info: any) => <span className="text-sm truncate max-w-[200px] inline-block" title={info.getValue()}>{info.getValue()}</span> },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => (
        <div className="flex justify-end">
          <Link href={`/erp/settings/audit/${info.row.original.id}`}>
            <Button variant="ghost" size="sm" className="h-7 text-xs">Details</Button>
          </Link>
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="System Audit Log" 
        description="Immutable, chronological record of all system events and data changes."
        action={
          <Button variant="outline">Export Logs (CSV)</Button>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border flex flex-wrap gap-2 items-center bg-surface-2 justify-between">
          <h3 className="font-medium mr-4">Event Stream</h3>
          <div className="flex gap-2 flex-wrap">
            <Input placeholder="Search user, IP, or record..." className="h-9 w-64 text-sm" />
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
              <option>All Modules</option>
              <option>Finance</option>
              <option>Commissions</option>
              <option>Payouts</option>
              <option>Settings</option>
            </select>
            <Input type="date" className="h-9 text-sm" />
          </div>
        </div>
        <DataTable data={MOCK_AUDIT} columns={columns} />
      </div>
    </div>
  );
}
