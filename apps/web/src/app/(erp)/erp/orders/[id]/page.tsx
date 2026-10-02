'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { getOrderById } from '@/features/sales/api/sales.api';
import { Order } from '@/features/sales/types';
import { Button } from '@/components/ui/button';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { toast } from 'sonner';
import { OrderOverviewTab } from '@/features/sales/components/OrderOverviewTab';
import { OrderItemsTab } from '@/features/sales/components/OrderItemsTab';
import { OrderPaymentsTab } from '@/features/sales/components/OrderPaymentsTab';
import { OrderFulfilmentTab } from '@/features/sales/components/OrderFulfilmentTab';
import { OrderReturnsTab } from '@/features/sales/components/OrderReturnsTab';
import { OrderTimelineTab } from '@/features/sales/components/OrderTimelineTab';
const TABS = ['Overview', 'Items', 'Payments', 'Fulfilment', 'Returns', 'Timeline'];

export default function OrderDetailPage() {
  const params = useParams();
  const router = useRouter();
  const id = params.id as string;

  const [order, setOrder] = useState<Order | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('Overview');

  useEffect(() => {
    getOrderById(id)
      .then(setOrder)
      .catch(() => {
        toast.error('Order not found');
        router.push('/erp/orders');
      })
      .finally(() => setIsLoading(false));
  }, [id, router]);

  if (isLoading) return <div className="p-8 text-center text-text-muted">Loading Order...</div>;
  if (!order) return null;

  return (
    <div className="space-y-6 pb-20 pt-4 max-w-7xl mx-auto">

      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-start justify-between gap-4">
        <div>
          <div className="flex items-center gap-3 mb-1">
            <h1 className="text-h3 font-mono">{order.orderNumber}</h1>
            <span className="px-2 py-0.5 rounded text-xs font-medium bg-primary/10 text-primary border border-primary/20">
              {order.status}
            </span>
            <span className="px-2 py-0.5 rounded text-xs font-medium bg-surface-2 text-text-muted border border-border">
              {order.channel}
            </span>
          </div>
          <div className="text-sm text-text-muted">
            Customer: <span className="font-medium text-text">{order.customerName}</span> • Placed: {new Date(order.createdAt).toLocaleString()}
          </div>
        </div>

        <div className="flex flex-wrap gap-2">
          <Button variant="outline">Print Invoice</Button>
          <Button variant="outline">Record Payment</Button>
          <Button>Fulfil Order</Button>
        </div>
      </div>

      {/* Step Indicator */}
      <div className="bg-surface p-4 rounded-xl border border-border overflow-x-auto">
        <div className="flex items-center justify-between min-w-[600px]">
          <div className="flex flex-col items-center flex-1">
            <div className="w-8 h-8 rounded-full bg-success text-white flex items-center justify-center text-sm mb-2">✓</div>
            <span className="text-xs font-medium text-success">Placed</span>
          </div>
          <div className={`h-1 flex-1 ${order.paymentStatus === 'Paid' ? 'bg-success' : order.paymentStatus === 'Partially Paid' ? 'bg-warning-bg' : 'bg-surface-2'}`}></div>
          <div className="flex flex-col items-center flex-1">
            <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm mb-2 ${order.paymentStatus === 'Paid' ? 'bg-success text-white' :
                order.paymentStatus === 'Partially Paid' ? 'bg-warning-bg border-2 border-warning-dark text-warning-dark' :
                  'bg-surface-2 text-text-muted'
              }`}>
              {order.paymentStatus === 'Paid' ? '✓' : '2'}
            </div>
            <span className={`text-xs font-medium ${order.paymentStatus === 'Unpaid' ? 'text-text-muted' : order.paymentStatus === 'Partially Paid' ? 'text-warning-dark' : 'text-success'}`}>
              Paid
            </span>
          </div>
          <div className={`h-1 flex-1 ${order.fulfilmentStatus === 'Fulfilled' ? 'bg-success' : 'bg-surface-2'}`}></div>
          <div className="flex flex-col items-center flex-1">
            <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm mb-2 ${order.fulfilmentStatus === 'Fulfilled' ? 'bg-success text-white' :
                'bg-surface-2 text-text-muted'
              }`}>
              {order.fulfilmentStatus === 'Fulfilled' ? '✓' : '3'}
            </div>
            <span className={`text-xs font-medium ${order.fulfilmentStatus === 'Fulfilled' ? 'text-success' : 'text-text-muted'}`}>Packed</span>
          </div>
          <div className={`h-1 flex-1 ${order.status === 'Completed' ? 'bg-success' : 'bg-surface-2'}`}></div>
          <div className="flex flex-col items-center flex-1">
            <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm mb-2 ${order.status === 'Completed' ? 'bg-success text-white' : 'bg-surface-2 text-text-muted'
              }`}>4</div>
            <span className={`text-xs font-medium ${order.status === 'Completed' ? 'text-success' : 'text-text-muted'}`}>Delivered</span>
          </div>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Order Total" value={<AmountText amountInKobo={order.totalAmount} />} />
        <KpiCard title="Amount Paid" value={<AmountText amountInKobo={order.amountPaid} />} className={order.amountPaid > 0 ? 'text-success' : ''} />
        <KpiCard title="Balance Due" value={<AmountText amountInKobo={order.balanceDue} />} className={order.balanceDue > 0 ? 'text-error' : 'text-success'} />
        <KpiCard title="Payment Status" value={order.paymentStatus} />
      </div>

      {/* Tabs */}
      <div className="border-b border-border flex overflow-x-auto no-scrollbar">
        {TABS.map(tab => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-3 text-sm font-medium whitespace-nowrap border-b-2 transition-colors ${activeTab === tab
                ? 'border-primary text-primary'
                : 'border-transparent text-text-muted hover:text-text hover:border-border'
              }`}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Tab Content */}
      <div className="pt-2">
        {activeTab === 'Overview' && <OrderOverviewTab order={order} />}
        {activeTab === 'Items' && <OrderItemsTab order={order} />}
        {activeTab === 'Payments' && <OrderPaymentsTab order={order} />}
        {activeTab === 'Fulfilment' && <OrderFulfilmentTab order={order} />}
        {activeTab === 'Returns' && <OrderReturnsTab order={order} />}
        {activeTab === 'Timeline' && <OrderTimelineTab order={order} />}
      </div>

    </div>
  );
}
