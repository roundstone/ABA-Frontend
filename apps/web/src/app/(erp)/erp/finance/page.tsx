'use client';

import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';

export default function FinanceDashboardPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Finance & Accounting" 
        description="Core financial metrics, period close status, and general ledger access."
        action={
          <div className="flex gap-2">
            <Link href="/erp/finance/chart-of-accounts">
              <Button variant="outline">Chart of Accounts</Button>
            </Link>
            <Link href="/erp/finance/gl">
              <Button>General Ledger</Button>
            </Link>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Total Revenue (MTD)" value={<AmountText amountInKobo={1250000000} />} className="text-success" />
        <KpiCard title="Net Profit Margin" value="18.4%" />
        <KpiCard title="Accounts Receivable" value={<AmountText amountInKobo={450000000} />} className="text-warning-dark" />
        <KpiCard title="Commissions Payable" value={<AmountText amountInKobo={82000000} />} className="text-error" />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        
        {/* Month End Close Checklist */}
        <div className="bg-surface rounded-xl border border-border p-6 flex flex-col">
          <div className="flex justify-between items-center mb-6">
            <div>
              <h2 className="text-lg font-bold">Month-End Close</h2>
              <p className="text-sm text-text-muted">September 2026</p>
            </div>
            <span className="bg-warning-bg text-warning-dark border border-warning-border px-3 py-1 rounded-full text-sm font-medium">In Progress</span>
          </div>

          <div className="space-y-4 flex-1">
            <div className="flex justify-between items-center p-3 rounded-lg border border-success-border bg-success-bg">
              <div className="flex items-center gap-3">
                <span className="text-success">✓</span>
                <span className="font-medium text-sm text-success-dark">Bank Reconciliation</span>
              </div>
              <span className="text-xs text-success-dark">Balanced</span>
            </div>
            <div className="flex justify-between items-center p-3 rounded-lg border border-border bg-surface-2">
              <div className="flex items-center gap-3">
                <span className="text-text-muted">○</span>
                <span className="font-medium text-sm">Inventory Subledger Match</span>
              </div>
              <span className="text-xs text-error font-medium">Diff: ₦45,000</span>
            </div>
            <div className="flex justify-between items-center p-3 rounded-lg border border-border bg-surface-2">
              <div className="flex items-center gap-3">
                <span className="text-text-muted">○</span>
                <span className="font-medium text-sm">Commission Liability Match</span>
              </div>
              <span className="text-xs text-text-muted">Pending Run</span>
            </div>
          </div>
          
          <Button className="w-full mt-6" disabled>Lock Period</Button>
        </div>

        {/* Quick Links & Reports */}
        <div className="bg-surface rounded-xl border border-border p-6 flex flex-col">
          <h2 className="text-lg font-bold mb-6">Financial Reports</h2>
          <div className="grid grid-cols-2 gap-4 flex-1">
            <Link href="#" className="p-4 rounded-xl border border-border bg-surface-2 hover:border-primary transition-colors flex flex-col items-center justify-center text-center gap-2">
              <span className="text-2xl">📊</span>
              <span className="font-medium text-sm">Profit & Loss</span>
            </Link>
            <Link href="#" className="p-4 rounded-xl border border-border bg-surface-2 hover:border-primary transition-colors flex flex-col items-center justify-center text-center gap-2">
              <span className="text-2xl">⚖️</span>
              <span className="font-medium text-sm">Balance Sheet</span>
            </Link>
            <Link href="#" className="p-4 rounded-xl border border-border bg-surface-2 hover:border-primary transition-colors flex flex-col items-center justify-center text-center gap-2">
              <span className="text-2xl">🌊</span>
              <span className="font-medium text-sm">Cash Flow</span>
            </Link>
            <Link href="#" className="p-4 rounded-xl border border-border bg-surface-2 hover:border-primary transition-colors flex flex-col items-center justify-center text-center gap-2">
              <span className="text-2xl">📋</span>
              <span className="font-medium text-sm">Trial Balance</span>
            </Link>
          </div>
        </div>

      </div>
    </div>
  );
}
