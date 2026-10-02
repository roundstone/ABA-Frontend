'use client';

import { useState } from 'react';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

// Mock data
const TODAY_ORDERS = [
  { id: '1', time: '10:45 AM', type: 'Completed', amount: 4500000, customer: 'Walk-in' },
  { id: '2', time: '11:20 AM', type: 'Completed', amount: 1200000, customer: 'Sarah Cole' },
];

const HELD_SALES = [
  { id: 'h1', time: '12:05 PM', items: 3, amount: 2850000, customer: 'John (Forgot Wallet)' },
];

export default function PosOrdersPage() {
  const [activeTab, setActiveTab] = useState('Held');

  return (
    <div className="flex-1 bg-surface-2 p-6 flex justify-center">
      <div className="w-full max-w-3xl flex flex-col h-full bg-surface rounded-2xl border border-border shadow-sm overflow-hidden">

        {/* Header */}
        <div className="px-6 py-4 border-b border-border flex items-center justify-between bg-surface">
          <h2 className="text-xl font-bold">Register Queue</h2>
          <Link href="/pos/sell">
            <Button variant="outline">Back to Sell</Button>
          </Link>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-border bg-surface-2 px-6">
          <button
            onClick={() => setActiveTab('Held')}
            className={`py-3 px-4 text-sm font-medium border-b-2 transition-colors ${activeTab === 'Held' ? 'border-primary text-primary' : 'border-transparent text-text-muted'}`}
          >
            Held Sales ({HELD_SALES.length})
          </button>
          <button
            onClick={() => setActiveTab('Today')}
            className={`py-3 px-4 text-sm font-medium border-b-2 transition-colors ${activeTab === 'Today' ? 'border-primary text-primary' : 'border-transparent text-text-muted'}`}
          >
            Today's Orders ({TODAY_ORDERS.length})
          </button>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto p-6">

          {activeTab === 'Held' && (
            <div className="space-y-3">
              {HELD_SALES.map(sale => (
                <div key={sale.id} className="flex items-center justify-between p-4 rounded-xl border border-border hover:border-primary transition-colors bg-surface group">
                  <div>
                    <p className="font-medium">{sale.customer}</p>
                    <p className="text-sm text-text-muted">{sale.time} • {sale.items} items • <AmountText amountInKobo={sale.amount} /></p>
                  </div>
                  <div className="flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <Button variant="outline" size="sm" className="text-error hover:bg-error-bg hover:text-error hover:border-error-border">Discard</Button>
                    <Button size="sm">Recall</Button>
                  </div>
                </div>
              ))}
              {HELD_SALES.length === 0 && <p className="text-center text-text-muted mt-10">No held sales.</p>}
            </div>
          )}

          {activeTab === 'Today' && (
            <div className="space-y-3">
              {TODAY_ORDERS.map(order => (
                <div key={order.id} className="flex items-center justify-between p-4 rounded-xl border border-border bg-surface">
                  <div>
                    <p className="font-medium">Order #{order.id} <span className="text-text-muted font-normal ml-2">{order.customer}</span></p>
                    <p className="text-sm text-text-muted">{order.time}</p>
                  </div>
                  <div className="flex items-center gap-4">
                    <span className="font-medium"><AmountText amountInKobo={order.amount} /></span>
                    <Button variant="outline" size="sm">Receipt</Button>
                  </div>
                </div>
              ))}
              {TODAY_ORDERS.length === 0 && <p className="text-center text-text-muted mt-10">No orders yet today.</p>}
            </div>
          )}

        </div>
      </div>
    </div>
  );
}
