'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export default function ProcurementDashboardPage() {
  
  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Procurement Dashboard" 
        description="Monitor spending, pending approvals, and upcoming deliveries."
        action={
          <div className="flex gap-2">
            <Link href="/erp/procurement/requests/new">
              <Button variant="outline">New Request</Button>
            </Link>
            <Link href="/erp/procurement/orders/new">
              <Button>Create PO</Button>
            </Link>
          </div>
        }
      />

      {/* KPI Cards */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
        <KpiCard title="Procurement Spend (30d)" value={<AmountText amountInKobo={4500000000} />} />
        <KpiCard title="Open POs Value" value={<AmountText amountInKobo={1250000000} />} />
        <KpiCard title="Awaiting Approval" value="8" className="text-warning-dark" />
        <KpiCard title="Overdue Deliveries" value="3" className="text-error" />
        <KpiCard title="Avg Lead Time" value="14 Days" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Charts area stub */}
        <div className="lg:col-span-2 space-y-6">
          <div className="bg-surface p-6 rounded-xl border border-border h-[400px] flex items-center justify-center">
            <div className="text-center">
              <p className="font-medium mb-1">Spend by Category (Donut)</p>
              <p className="text-text-muted text-sm text-center">Chart visualization component goes here</p>
            </div>
          </div>
        </div>

        {/* Alerts & Action items */}
        <div className="space-y-6">
          
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
              <h3 className="font-medium">Deliveries Due This Week</h3>
              <span className="text-xs bg-primary/10 text-primary px-2 py-0.5 rounded-full">4</span>
            </div>
            <div className="divide-y divide-border">
              <div className="p-4 space-y-1">
                <div className="flex justify-between items-start">
                  <div className="font-medium text-sm">PO-2041</div>
                  <span className="text-xs font-medium text-success">Tomorrow</span>
                </div>
                <div className="text-xs text-text-muted">Global Textiles Ltd</div>
                <div className="text-xs text-text-muted">Raw Cotton 100% (200kg)</div>
              </div>
              <div className="p-4 space-y-1">
                <div className="flex justify-between items-start">
                  <div className="font-medium text-sm">PO-2038</div>
                  <span className="text-xs font-medium text-error">2 days late</span>
                </div>
                <div className="text-xs text-text-muted">Chemicals Plus</div>
                <div className="text-xs text-text-muted">Blue Dye (50L)</div>
              </div>
            </div>
            <div className="bg-surface-2 p-3 border-t border-border text-center">
              <Link href="/erp/procurement/orders" className="text-sm text-primary hover:underline font-medium">View all Purchase Orders</Link>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}
