'use client';

import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

const REPORT_CATEGORIES = [
  {
    category: 'Sales',
    slug: 'sales',
    reports: [
      { id: 'sales-by-merchant', name: 'Sales by Merchant', desc: 'Net sales, orders, and returns sliced by merchant location.' },
      { id: 'product-performance', name: 'Product Performance', desc: 'Top selling products, gross margin, and return rates.' },
      { id: 'customer-sales-history', name: 'Customer Sales History', desc: 'LTV, average order value, and order frequency.' },
    ]
  },
  {
    category: 'Finance & Accounting',
    slug: 'finance',
    reports: [
      { id: 'profit-loss', name: 'Profit & Loss', desc: 'Income, COGS, and Expenses over the selected period.' },
      { id: 'balance-sheet', name: 'Balance Sheet', desc: 'Assets, Liabilities, and Equity as of a specific date.' },
      { id: 'ar-ap-ageing', name: 'AR/AP Ageing', desc: 'Outstanding receivables and payables bucketed by age (30/60/90+ days).' },
    ]
  },
  {
    category: 'Inventory & Procurement',
    slug: 'inventory',
    reports: [
      { id: 'inventory-valuation', name: 'Inventory Valuation', desc: 'Current stock levels multiplied by unit cost (FIFO/Moving Average).' },
      { id: 'low-stock-alerts', name: 'Low Stock Alerts', desc: 'Items at or below their defined reorder point.' },
      { id: 'supplier-performance', name: 'Supplier Performance', desc: 'Fulfillment times, variance, and cost trends by supplier.' },
    ]
  },
  {
    category: 'Referrals & Commissions',
    slug: 'referrals',
    reports: [
      { id: 'referral-funnel', name: 'Referral Funnel', desc: 'Conversion rates from sign-up to qualified referral.' },
      { id: 'commission-liability', name: 'Commission Liability', desc: 'Total approved but unpaid commissions grouped by beneficiary.' },
      { id: 'top-earners', name: 'Top Earners', desc: 'Highest grossing referrers over a specified time period.' },
    ]
  }
];

export default function ReportsHubPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Reports Hub" 
        description="Access standardized reports, analytics, and data exports."
        action={
          <div className="flex gap-2">
            <Button variant="outline">Schedule Report</Button>
            <Button>Custom Query</Button>
          </div>
        }
      />

      <div className="bg-surface rounded-xl border border-border p-6 flex gap-4 items-center">
        <Input placeholder="Search for a report..." className="flex-1" />
        <select className="h-10 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
          <option>All Categories</option>
          {REPORT_CATEGORIES.map(c => <option key={c.category}>{c.category}</option>)}
        </select>
      </div>

      <div className="space-y-8 mt-6">
        {REPORT_CATEGORIES.map((section, idx) => (
          <div key={idx}>
            <h2 className="text-lg font-bold mb-4">{section.category}</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {section.reports.map((report, rIdx) => (
                <Link key={rIdx} href={`/erp/reports/${section.slug}/${report.id}`} className="block p-5 rounded-xl border border-border bg-surface hover:border-primary transition-colors group">
                  <h3 className="font-medium mb-2 group-hover:text-primary transition-colors">{report.name}</h3>
                  <p className="text-sm text-text-muted">{report.desc}</p>
                </Link>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
