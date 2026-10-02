'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { getPurchaseOrderById } from '@/features/procurement/api/procurement.api';
import { PurchaseOrder } from '@/features/procurement/types';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { toast } from 'sonner';

const TABS = ['Overview', 'Items', 'Receiving', 'Invoices', 'Payments', 'Timeline'];

export default function PurchaseOrderDetailPage() {
  const params = useParams();
  const router = useRouter();
  const id = params.id as string;

  const [po, setPo] = useState<PurchaseOrder | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('Overview');

  useEffect(() => {
    getPurchaseOrderById(id)
      .then(setPo)
      .catch(() => {
        toast.error('PO not found');
        router.push('/erp/procurement/orders');
      })
      .finally(() => setIsLoading(false));
  }, [id, router]);

  if (isLoading) return <div className="p-8 text-center text-text-muted">Loading PO...</div>;
  if (!po) return null;

  return (
    <div className="space-y-6 pb-20">
      
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-start justify-between gap-4">
        <div>
          <div className="flex items-center gap-3 mb-1">
            <h1 className="text-h3 font-mono">{po.poNumber}</h1>
            <span className="px-2 py-0.5 rounded text-xs font-medium bg-primary/10 text-primary border border-primary/20">
              {po.status}
            </span>
          </div>
          <div className="text-sm text-text-muted">
            Supplier: <span className="font-medium text-text">{po.supplierName}</span> • Expected: {po.expectedDeliveryDate}
          </div>
        </div>

        <div className="flex gap-2">
          <Button variant="outline">Print / PDF</Button>
          <Button variant="outline" className="border-primary text-primary hover:bg-primary/5">Email Supplier</Button>
          <Button>Receive Goods (GRN)</Button>
        </div>
      </div>

      {/* Step Indicator */}
      <div className="bg-surface p-4 rounded-xl border border-border">
        <div className="flex items-center justify-between">
          <div className="flex flex-col items-center">
            <div className="w-8 h-8 rounded-full bg-success text-white flex items-center justify-center text-sm mb-2">✓</div>
            <span className="text-xs font-medium text-success">Approved</span>
          </div>
          <div className="flex-1 h-1 bg-success mx-4"></div>
          <div className="flex flex-col items-center">
            <div className="w-8 h-8 rounded-full bg-success text-white flex items-center justify-center text-sm mb-2">✓</div>
            <span className="text-xs font-medium text-success">Ordered</span>
          </div>
          <div className={`flex-1 h-1 mx-4 ${po.receivedPercentage > 0 ? 'bg-success' : 'bg-surface-2'}`}></div>
          <div className="flex flex-col items-center">
            <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm mb-2 ${po.receivedPercentage === 100 ? 'bg-success text-white' : po.receivedPercentage > 0 ? 'bg-warning-bg border-2 border-warning-dark text-warning-dark' : 'bg-surface-2 text-text-muted'}`}>
              {po.receivedPercentage === 100 ? '✓' : '3'}
            </div>
            <span className="text-xs font-medium text-text-muted">Received ({po.receivedPercentage}%)</span>
          </div>
          <div className={`flex-1 h-1 mx-4 ${po.invoicedPercentage > 0 ? 'bg-success' : 'bg-surface-2'}`}></div>
          <div className="flex flex-col items-center">
            <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm mb-2 ${po.invoicedPercentage === 100 ? 'bg-success text-white' : 'bg-surface-2 text-text-muted'}`}>4</div>
            <span className="text-xs font-medium text-text-muted">Invoiced</span>
          </div>
          <div className={`flex-1 h-1 mx-4 ${po.paymentStatus === 'Paid' ? 'bg-success' : 'bg-surface-2'}`}></div>
          <div className="flex flex-col items-center">
            <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm mb-2 ${po.paymentStatus === 'Paid' ? 'bg-success text-white' : 'bg-surface-2 text-text-muted'}`}>5</div>
            <span className="text-xs font-medium text-text-muted">Paid</span>
          </div>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard title="Total Value" value={<AmountText amountInKobo={po.totalAmount} />} />
        <KpiCard title="Received Value" value={<AmountText amountInKobo={po.totalAmount * (po.receivedPercentage/100)} />} />
        <KpiCard title="Invoiced Value" value={<AmountText amountInKobo={po.totalAmount * (po.invoicedPercentage/100)} />} />
        <KpiCard title="Payment Status" value={po.paymentStatus} className={po.paymentStatus === 'Paid' ? 'text-success' : 'text-error'} />
      </div>

      {/* Tabs */}
      <div className="border-b border-border flex overflow-x-auto no-scrollbar">
        {TABS.map(tab => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-3 text-sm font-medium whitespace-nowrap border-b-2 transition-colors ${
              activeTab === tab 
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
        {activeTab === 'Overview' && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="bg-surface p-6 rounded-xl border border-border">
              <h3 className="font-medium text-lg mb-4">Logistics</h3>
              <dl className="space-y-4 text-sm">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <dt className="text-text-muted text-xs mb-1">Order Date</dt>
                    <dd className="font-medium">{po.orderDate}</dd>
                  </div>
                  <div>
                    <dt className="text-text-muted text-xs mb-1">Expected Delivery</dt>
                    <dd className="font-medium text-primary">{po.expectedDeliveryDate}</dd>
                  </div>
                </div>
                <div>
                  <dt className="text-text-muted text-xs mb-1">Deliver To</dt>
                  <dd className="font-medium">{po.deliverToLocationName}</dd>
                </div>
              </dl>
            </div>

            <div className="bg-surface p-6 rounded-xl border border-border">
              <h3 className="font-medium text-lg mb-4">Commercial</h3>
              <dl className="space-y-4 text-sm">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <dt className="text-text-muted text-xs mb-1">Payment Terms</dt>
                    <dd className="font-medium">{po.paymentTerms}</dd>
                  </div>
                  <div>
                    <dt className="text-text-muted text-xs mb-1">Currency</dt>
                    <dd className="font-medium">{po.currency}</dd>
                  </div>
                </div>
              </dl>
            </div>
          </div>
        )}

        {activeTab === 'Items' && (
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <table className="w-full text-sm text-left whitespace-nowrap">
              <thead className="bg-surface-2 text-text-muted">
                <tr>
                  <th className="px-6 py-3 font-medium">Product</th>
                  <th className="px-6 py-3 font-medium">Qty</th>
                  <th className="px-6 py-3 font-medium">Unit Price</th>
                  <th className="px-6 py-3 font-medium">Tax %</th>
                  <th className="px-6 py-3 font-medium text-right">Line Total</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {po.lines.map(line => (
                  <tr key={line.id}>
                    <td className="px-6 py-4 font-medium">{line.productName}</td>
                    <td className="px-6 py-4">{line.quantity}</td>
                    <td className="px-6 py-4"><AmountText amountInKobo={line.unitPrice} /></td>
                    <td className="px-6 py-4">{line.taxRate}%</td>
                    <td className="px-6 py-4 text-right font-medium"><AmountText amountInKobo={line.lineTotal} /></td>
                  </tr>
                ))}
              </tbody>
            </table>
            
            <div className="bg-surface-2 p-6 border-t border-border flex justify-end">
              <div className="w-full max-w-xs space-y-3">
                <div className="flex justify-between text-sm">
                  <span className="text-text-muted">Subtotal</span>
                  <span><AmountText amountInKobo={po.subtotal}/></span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-text-muted">Tax</span>
                  <span><AmountText amountInKobo={po.taxTotal}/></span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-text-muted">Shipping</span>
                  <span><AmountText amountInKobo={po.shippingCharge}/></span>
                </div>
                <div className="flex justify-between font-medium text-lg pt-3 border-t border-border">
                  <span>Total</span>
                  <span className="text-primary"><AmountText amountInKobo={po.totalAmount}/></span>
                </div>
              </div>
            </div>
          </div>
        )}

        {activeTab !== 'Overview' && activeTab !== 'Items' && (
          <div className="bg-surface p-12 text-center rounded-xl border border-border">
            <h3 className="font-medium text-lg mb-1">{activeTab} Integration</h3>
            <p className="text-text-muted text-sm mb-4">This section connects to the GRN and Invoicing workflows.</p>
          </div>
        )}
      </div>

    </div>
  );
}
