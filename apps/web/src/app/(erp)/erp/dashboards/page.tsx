'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { ChartCard } from '@/components/patterns/ChartCard';

export default function ExecutiveDashboardPage() {
  const revenueVsOpexData = [
    { name: 'Jan', revenue: 120000000, opex: 80000000 },
    { name: 'Feb', revenue: 135000000, opex: 85000000 },
    { name: 'Mar', revenue: 110000000, opex: 82000000 },
    { name: 'Apr', revenue: 150000000, opex: 90000000 },
    { name: 'May', revenue: 180000000, opex: 95000000 },
    { name: 'Jun', revenue: 175000000, opex: 92000000 },
  ];

  const salesByCategoryData = [
    { name: 'Food & Bev', sales: 450000 },
    { name: 'Electronics', sales: 320000 },
    { name: 'Fashion', sales: 280000 },
    { name: 'Home Goods', sales: 150000 },
  ];

  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Executive Dashboard" 
        description="High-level rollup of key business metrics."
        action={
          <div className="flex gap-2 items-center">
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
              <option>Today</option>
              <option>This Week</option>
              <option>This Month</option>
              <option>Year to Date</option>
            </select>
            <Button variant="outline">Export PDF</Button>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Gross Sales" value={<AmountText amountInKobo={1452000000} />} className="text-success" />
        <KpiCard title="Total Orders" value="1,492" />
        <KpiCard title="Net Profit Margin" value="18.2%" />
        <KpiCard title="Cash & Bank" value={<AmountText amountInKobo={1800000000} />} />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-6">
        
        <ChartCard
          title="Revenue vs Operating Expenses (YTD)"
          subtitle="Monthly comparison"
          type="line"
          data={revenueVsOpexData}
          xAxisKey="name"
          series={[
            { key: 'revenue', name: 'Revenue', color: '#10b981' },
            { key: 'opex', name: 'Operating Expenses', color: '#ef4444' }
          ]}
          valueFormatter={(val) => `₦${(val / 1000000).toLocaleString()}M`}
        />

        <ChartCard
          title="Sales by Product Category"
          subtitle="Total items sold"
          type="bar"
          data={salesByCategoryData}
          xAxisKey="name"
          series={[
            { key: 'sales', name: 'Sales', color: '#3b82f6' }
          ]}
        />

        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium">Actionable Alerts</h3>
          </div>
          <div className="p-4 space-y-3">
            <div className="p-3 rounded-lg bg-error-bg border border-error-border text-sm flex justify-between items-center">
              <div>
                <strong className="text-error font-medium">Low Stock Warning</strong>
                <p className="text-error/80 mt-0.5">3 items are below reorder point.</p>
              </div>
              <Button size="sm" variant="outline" className="h-7 text-xs border-error text-error hover:bg-error-bg">View Items</Button>
            </div>
            <div className="p-3 rounded-lg bg-warning-bg border border-warning-border text-sm flex justify-between items-center">
              <div>
                <strong className="text-warning-dark font-medium">Pending Payouts</strong>
                <p className="text-warning-dark/80 mt-0.5">14 commission withdrawals require approval.</p>
              </div>
              <Button size="sm" variant="outline" className="h-7 text-xs border-warning-dark text-warning-dark hover:bg-warning-bg">Review</Button>
            </div>
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium">Top Performing Merchants</h3>
          </div>
          <table className="w-full text-sm text-left">
            <thead className="bg-surface text-text-muted border-b border-border">
              <tr>
                <th className="px-6 py-2 font-medium">Merchant</th>
                <th className="px-6 py-2 font-medium text-right">Net Sales</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              <tr>
                <td className="px-6 py-3 font-medium">ABA Surulere Branch</td>
                <td className="px-6 py-3 text-right font-medium text-success"><AmountText amountInKobo={450000000} /></td>
              </tr>
              <tr>
                <td className="px-6 py-3 font-medium">ABA Kano Depot</td>
                <td className="px-6 py-3 text-right font-medium text-success"><AmountText amountInKobo={380000000} /></td>
              </tr>
              <tr>
                <td className="px-6 py-3 font-medium">ABA Port Harcourt</td>
                <td className="px-6 py-3 text-right font-medium text-success"><AmountText amountInKobo={210000000} /></td>
              </tr>
            </tbody>
          </table>
        </div>

      </div>

    </div>
  );
}
