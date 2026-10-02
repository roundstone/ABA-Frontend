
import React from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { KpiCard } from '@/components/patterns/KpiCard';
import { ShoppingCart, DollarSign, Users, Package, CreditCard, Banknote } from 'lucide-react';
import { Button } from '@/components/ui/button';

export function DashboardView({ role }: { role: string }) {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Dashboard"
        description={`Welcome back, here is what's happening today.`}
        action={
          <select className="h-9 px-3 py-1 rounded-md border border-border bg-white text-sm focus:outline-none focus:ring-2 focus:ring-brand-500">
            <option>Today</option>
            <option>Last 7 days</option>
            <option>Last 30 days</option>
            <option>This Quarter</option>
            <option>This Year</option>
          </select>
        }
      />

      {/* KPI Section */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <KpiCard
          title="Total Sales"
          value="₦24,500,000"
          trend="12.5%"
          trendDirection="up"
          supportingText="432 orders"
          href="/erp/orders"
          icon={ShoppingCart}
        />
        <KpiCard
          title="Revenue"
          value="₦18,200,000"
          trend="8.2%"
          trendDirection="up"
          supportingText="Gross ₦20M"
          href="/erp/finance"
          icon={DollarSign}
        />
        <KpiCard
          title="Active Customers"
          value="1,245"
          trend="4.1%"
          trendDirection="up"
          supportingText="+32 new"
          href="/erp/customers"
          icon={Users}
        />
        <KpiCard
          title="Pending Payouts"
          value="₦1,450,000"
          trend="2.4%"
          trendDirection="up" // Up is typically bad for payouts, maybe set trendDirection logic later
          supportingText="14 requests"
          href="/erp/payouts"
          icon={Banknote}
        />
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg border border-border shadow-sm p-5 h-80 flex flex-col">
          <h3 className="font-semibold text-text mb-4">Revenue Over Time</h3>
          <div className="flex-1 flex items-end gap-2 text-brand-200">
            {/* Mock Chart Bars */}
            {[40, 70, 45, 90, 65, 85, 100].map((h, i) => (
              <div key={i} className="flex-1 bg-brand-500 rounded-t-sm hover:bg-brand-600 transition-colors" style={{ height: `${h}%` }}></div>
            ))}
          </div>
          <div className="flex justify-between text-xs text-text-muted mt-2">
            <span>Mon</span>
            <span>Tue</span>
            <span>Wed</span>
            <span>Thu</span>
            <span>Fri</span>
            <span>Sat</span>
            <span>Sun</span>
          </div>
        </div>

        <div className="bg-white rounded-lg border border-border shadow-sm p-5 h-80 flex flex-col">
          <h3 className="font-semibold text-text mb-4">Sales by Category</h3>
          <div className="flex-1 flex items-center justify-center">
            {/* Mock Donut Chart */}
            <div className="relative w-48 h-48 rounded-full border-[16px] border-brand-500 border-r-surface-400 border-b-warning-main">
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <span className="text-xl font-bold text-text">3.2k</span>
                <span className="text-xs text-text-muted">Items Sold</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Tables Section */}
      <div className="bg-white border border-border rounded-lg shadow-sm overflow-hidden">
        <div className="p-4 border-b border-border flex justify-between items-center">
          <h3 className="font-semibold text-text">Recent Orders</h3>
          <Button variant="outline" size="sm">View All</Button>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="bg-surface-1 text-text-muted text-xs uppercase font-semibold">
              <tr>
                <th className="px-4 py-3">Order ID</th>
                <th className="px-4 py-3">Customer</th>
                <th className="px-4 py-3">Date</th>
                <th className="px-4 py-3 text-right">Amount</th>
                <th className="px-4 py-3 text-center">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border text-text">
              <tr className="hover:bg-surface-1">
                <td className="px-4 py-3 font-medium">ORD-2023-401</td>
                <td className="px-4 py-3">Acme Corp</td>
                <td className="px-4 py-3 text-text-muted">2 hours ago</td>
                <td className="px-4 py-3 text-right">₦450,000</td>
                <td className="px-4 py-3 text-center">
                  <span className="inline-block px-2 py-1 bg-brand-50 text-brand-700 text-xs rounded-full font-medium">Completed</span>
                </td>
              </tr>
              <tr className="hover:bg-surface-1">
                <td className="px-4 py-3 font-medium">ORD-2023-402</td>
                <td className="px-4 py-3">Globex Ltd</td>
                <td className="px-4 py-3 text-text-muted">4 hours ago</td>
                <td className="px-4 py-3 text-right">₦125,500</td>
                <td className="px-4 py-3 text-center">
                  <span className="inline-block px-2 py-1 bg-warning-bg text-warning-dark text-xs rounded-full font-medium">Pending</span>
                </td>
              </tr>
              <tr className="hover:bg-surface-1">
                <td className="px-4 py-3 font-medium">ORD-2023-403</td>
                <td className="px-4 py-3">Soylent Corp</td>
                <td className="px-4 py-3 text-text-muted">Yesterday</td>
                <td className="px-4 py-3 text-right">₦890,000</td>
                <td className="px-4 py-3 text-center">
                  <span className="inline-block px-2 py-1 bg-brand-50 text-brand-700 text-xs rounded-full font-medium">Completed</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
