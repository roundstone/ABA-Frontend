'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { ChartCard } from '@/components/patterns/ChartCard';
import { Button } from '@/components/ui/button';
import { getStockLevels } from '@/features/inventory/api/inventory.api';
import { StockLevel } from '@/features/inventory/types';

export default function InventoryDashboardPage() {
  const [stocks, setStocks] = useState<StockLevel[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    getStockLevels().then(setStocks).finally(() => setIsLoading(false));
  }, []);

  if (isLoading) {
    return <div className="p-8 text-center text-text-muted">Loading dashboard...</div>;
  }

  const totalValue = stocks.reduce((acc, s) => acc + s.totalValue, 0);
  const lowStockCount = stocks.filter(s => s.status === 'Low Stock').length;
  const outOfStockCount = stocks.filter(s => s.status === 'Out of Stock').length;
  const inTransitCount = stocks.reduce((acc, s) => acc + s.inTransit, 0);

  const lowStockItems = stocks.filter(s => s.status === 'Low Stock' || s.status === 'Out of Stock');

  const locationData = [
    { name: 'Lagos Main', value: 45000000, color: '#0f172a' },
    { name: 'Abuja Dist.', value: 21000000, color: '#3b82f6' },
    { name: 'PH Hub', value: 18000000, color: '#10b981' },
    { name: 'Ikeja Retail', value: 5000000, color: '#f59e0b' }
  ];

  const ageingData = [
    { name: '0-30 Days', count: 120 },
    { name: '31-60 Days', count: 45 },
    { name: '61-90 Days', count: 30 },
    { name: '90+ Days', count: 15 }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Inventory Dashboard" 
        description="Monitor stock valuations, movements, and alerts across all locations."
        action={
          <div className="flex gap-2">
            <Link href="/erp/inventory/transfers/new">
              <Button variant="outline">Transfer Stock</Button>
            </Link>
            <Link href="/erp/inventory/stock">
              <Button>View All Stock</Button>
            </Link>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Total Inventory Value" value={<AmountText amountInKobo={totalValue} />} />
        <KpiCard 
          title="Low Stock SKUs" 
          value={lowStockCount.toString()} 
          className={lowStockCount > 0 ? "text-warning-dark" : ""} 
        />
        <KpiCard 
          title="Out of Stock SKUs" 
          value={outOfStockCount.toString()} 
          className={outOfStockCount > 0 ? "text-error" : ""} 
        />
        <KpiCard title="Items in Transit" value={inTransitCount.toString()} />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Main Charts area */}
        <div className="lg:col-span-2 space-y-6">
          <ChartCard 
            title="Inventory Value by Location" 
            subtitle="Total value of stock currently on hand"
            type="pie"
            data={locationData}
            pieDataKey="value"
            pieNameKey="name"
            valueFormatter={(val) => `₦ ${(val / 100).toLocaleString()}`}
          />
          <ChartCard 
            title="Stock Ageing" 
            subtitle="Number of SKUs by days in inventory"
            type="bar"
            data={ageingData}
            series={[{ key: 'count', name: 'SKUs', color: '#3b82f6' }]}
            xAxisKey="name"
          />
        </div>

        {/* Alerts & Actions area */}
        <div className="space-y-6">
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
              <h3 className="font-medium">Action Required</h3>
              <span className="text-xs bg-error-bg text-error px-2 py-0.5 rounded-full">{lowStockItems.length}</span>
            </div>
            <div className="divide-y divide-border">
              {lowStockItems.length > 0 ? (
                lowStockItems.map(item => (
                  <div key={item.id} className="p-4 space-y-2">
                    <div className="flex justify-between items-start">
                      <div>
                        <div className="font-medium text-sm">{item.productName}</div>
                        <div className="text-xs text-text-muted">{item.locationName}</div>
                      </div>
                      <span className={`text-xs font-medium px-2 py-0.5 rounded ${
                        item.status === 'Out of Stock' ? 'bg-error-bg text-error' : 'bg-warning-bg text-warning-dark'
                      }`}>
                        {item.status}
                      </span>
                    </div>
                    <div className="flex justify-between text-xs text-text-muted bg-surface-2 p-2 rounded">
                      <span>On Hand: <strong>{item.onHand}</strong></span>
                      <span>Reorder: <strong>{item.reorderLevel}</strong></span>
                    </div>
                    <Button variant="outline" size="sm" className="w-full text-xs h-7">Create Purchase Request</Button>
                  </div>
                ))
              ) : (
                <div className="p-6 text-center text-sm text-text-muted">
                  All stock levels are healthy!
                </div>
              )}
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
