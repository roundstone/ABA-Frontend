'use client';

import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { KpiCard } from '@/components/patterns/KpiCard';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

export default function SalesDashboardPage() {
  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Sales Overview" 
        description="Monitor sales performance, orders, and channel metrics."
        action={
          <div className="flex gap-2">
            <Link href="/erp/orders/new">
              <Button>New Order</Button>
            </Link>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Total Sales" value={<AmountText amountInKobo={45890000} />} />
        <KpiCard title="Total Orders" value="142" />
        <KpiCard title="Avg Order Value" value={<AmountText amountInKobo={323169} />} />
        <KpiCard title="Pending Orders" value="18" className="text-warning-dark" />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-2 bg-surface p-6 rounded-xl border border-border h-80 flex flex-col items-center justify-center text-text-muted">
          <p className="mb-2">Sales Over Time Chart</p>
          <p className="text-xs">(Requires Charting Library)</p>
        </div>

        <div className="space-y-6">
          <div className="bg-surface p-6 rounded-xl border border-border h-36 flex flex-col items-center justify-center text-text-muted">
            <p className="mb-2">Sales by Channel</p>
            <p className="text-xs">POS vs Web vs Admin</p>
          </div>
          <div className="bg-surface p-6 rounded-xl border border-border h-36 flex flex-col items-center justify-center text-text-muted">
            <p className="mb-2">Top Products</p>
          </div>
        </div>
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="px-6 py-4 border-b border-border flex justify-between items-center">
          <h3 className="font-medium">Recent Orders</h3>
          <Link href="/erp/orders" className="text-sm text-primary hover:underline font-medium">View All</Link>
        </div>
        <div className="p-12 text-center text-text-muted">
          <p>Recent orders list placeholder. Full DataTable is available on the <Link href="/erp/orders" className="text-primary hover:underline">Orders page</Link>.</p>
        </div>
      </div>
    </div>
  );
}
