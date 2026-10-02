'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { DataTable } from '@/components/patterns/DataTable';

const MOCK_COA = [
  { code: '1000', name: 'Cash', type: 'Asset', subType: 'Current Asset', balance: 450000000 },
  { code: '1010', name: 'Bank - GTB Main', type: 'Asset', subType: 'Current Asset', balance: 1250000000 },
  { code: '1100', name: 'Accounts Receivable', type: 'Asset', subType: 'Current Asset', balance: 450000000 },
  { code: '1200', name: 'Inventory - Raw Materials', type: 'Asset', subType: 'Current Asset', balance: 890000000 },
  { code: '2000', name: 'Accounts Payable', type: 'Liability', subType: 'Current Liability', balance: 320000000 },
  { code: '2110', name: 'Commissions Payable', type: 'Liability', subType: 'Current Liability', balance: 82000000 },
  { code: '3000', name: 'Owner Equity', type: 'Equity', subType: 'Equity', balance: 5000000000 },
  { code: '4000', name: 'Sales Revenue', type: 'Revenue', subType: 'Operating Revenue', balance: 2450000000 },
  { code: '5000', name: 'Cost of Goods Sold (COGS)', type: 'Expense', subType: 'Direct Costs', balance: 980000000 },
];

export default function ChartOfAccountsPage() {
  const columns = [
    { accessorKey: 'code', header: 'Account Code', cell: (info: any) => <span className="font-mono font-bold text-primary">{info.getValue()}</span> },
    { accessorKey: 'name', header: 'Account Name', cell: (info: any) => <span className="font-medium">{info.getValue()}</span> },
    { 
      accessorKey: 'type', 
      header: 'Type',
      cell: (info: any) => {
        const type = info.getValue();
        let badge = 'bg-surface-2 text-text-muted';
        if (type === 'Asset') badge = 'bg-success-bg text-success border border-success-border';
        if (type === 'Liability') badge = 'bg-error-bg text-error border border-error-border';
        if (type === 'Equity') badge = 'bg-primary/10 text-primary border border-primary/20';
        if (type === 'Revenue') badge = 'bg-success text-white';
        if (type === 'Expense') badge = 'bg-warning-bg text-warning-dark border border-warning-border';
        
        return <span className={`px-2 py-0.5 rounded text-xs font-medium ${badge}`}>{type}</span>;
      }
    },
    { accessorKey: 'subType', header: 'Sub-Category' },
    {
      id: 'actions',
      header: '',
      cell: () => (
        <div className="flex justify-end gap-2">
          <Button variant="ghost" size="sm" className="h-7 text-xs">Edit</Button>
          <Button variant="outline" size="sm" className="h-7 text-xs">View Ledger</Button>
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6 pb-20 max-w-6xl mx-auto">
      <PageHeader 
        title="Chart of Accounts" 
        description="The foundational structure of the general ledger."
        backHref="/erp/finance"
        action={<Button>+ New Account</Button>}
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border flex justify-between items-center bg-surface-2">
          <div className="flex gap-2">
            <Input placeholder="Search code or name..." className="h-9 w-64 text-sm" />
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
              <option>All Types</option>
              <option>Asset</option>
              <option>Liability</option>
              <option>Equity</option>
              <option>Revenue</option>
              <option>Expense</option>
            </select>
          </div>
        </div>
        <DataTable data={MOCK_COA} columns={columns} />
      </div>
    </div>
  );
}
