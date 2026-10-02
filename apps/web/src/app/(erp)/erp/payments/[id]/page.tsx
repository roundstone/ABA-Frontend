'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import Link from 'next/link';
import { getPaymentById } from '@/features/payments/api/payments.api';
import { Payment } from '@/features/payments/types';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';
import { toast } from 'sonner';

export default function PaymentDetailPage() {
  const params = useParams();
  const router = useRouter();
  const id = params.id as string;

  const [payment, setPayment] = useState<Payment | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    getPaymentById(id)
      .then(setPayment)
      .catch(() => {
        toast.error('Payment not found');
        router.push('/payments');
      })
      .finally(() => setIsLoading(false));
  }, [id, router]);

  if (isLoading) return <div className="p-8 text-center text-text-muted">Loading Payment...</div>;
  if (!payment) return null;

  return (
    <div className="space-y-6 pb-20 pt-4 max-w-5xl mx-auto">

      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-start justify-between gap-4">
        <div>
          <div className="flex items-center gap-3 mb-1">
            <h1 className="text-h3 font-mono">{payment.referenceNumber}</h1>
            <span className={`px-2 py-0.5 rounded text-xs font-medium border ${payment.status === 'Completed' ? 'bg-success-bg text-success border-success-border' :
                payment.status === 'Pending' ? 'bg-warning-bg text-warning-dark border-warning-border' :
                  'bg-error-bg text-error border-error-border'
              }`}>
              {payment.status}
            </span>
            <span className={`px-2 py-0.5 rounded text-xs font-medium border bg-surface-2 text-text-muted border-border uppercase tracking-wider`}>
              {payment.direction}
            </span>
            {payment.isReconciled && (
              <span className="px-2 py-0.5 rounded text-xs font-medium bg-primary/10 text-primary border border-primary/20">
                ✓ Reconciled
              </span>
            )}
          </div>
          <div className="text-sm text-text-muted">
            {payment.type} • Created: {new Date(payment.createdAt).toLocaleString()}
          </div>
        </div>

        <div className="flex flex-wrap gap-2">
          {payment.status === 'Pending' && <Button className="bg-success text-white hover:bg-success-dark">Confirm Transfer</Button>}
          <Button variant="outline">Print Receipt</Button>
          <Button variant="outline" className="text-error border-error-border hover:bg-error-bg">Void</Button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">

        {/* Left Column */}
        <div className="md:col-span-2 space-y-6">

          <div className="bg-surface rounded-xl border border-border p-6 flex items-center justify-between">
            <div>
              <p className="text-text-muted text-sm mb-1">Net Amount</p>
              <p className={`text-4xl font-bold ${payment.direction === 'In' ? 'text-success' : 'text-text'}`}>
                {payment.direction === 'In' ? '+' : '-'}<AmountText amountInKobo={payment.netAmount} />
              </p>
            </div>
            <div className="text-right text-sm">
              <p className="text-text-muted mb-1">Gross: <AmountText amountInKobo={payment.amount} /></p>
              <p className="text-text-muted">Fee: <AmountText amountInKobo={payment.fee} /></p>
            </div>
          </div>

          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border">
              <h3 className="font-medium">Document Allocations</h3>
            </div>
            <table className="w-full text-sm text-left whitespace-nowrap">
              <thead className="bg-surface text-text-muted border-b border-border">
                <tr>
                  <th className="px-6 py-3 font-medium">Document Type</th>
                  <th className="px-6 py-3 font-medium">Document #</th>
                  <th className="px-6 py-3 font-medium text-right">Amount Allocated</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {payment.allocations.map(alloc => (
                  <tr key={alloc.id}>
                    <td className="px-6 py-4">{alloc.documentType}</td>
                    <td className="px-6 py-4">
                      {alloc.documentType === 'Order' ? (
                        <Link href={`/erp/orders/${alloc.documentNumber}`} className="text-primary hover:underline font-mono">
                          {alloc.documentNumber}
                        </Link>
                      ) : (
                        <span className="font-mono">{alloc.documentNumber}</span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-right font-medium"><AmountText amountInKobo={alloc.amountAllocated} /></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

        </div>

        {/* Right Column */}
        <div className="space-y-6">

          <div className="bg-surface p-6 rounded-xl border border-border">
            <h3 className="font-medium mb-4">Payment Details</h3>
            <dl className="space-y-4 text-sm">
              <div>
                <dt className="text-text-muted text-xs mb-1">Party ({payment.direction === 'In' ? 'Customer' : 'Supplier'})</dt>
                <dd className="font-medium">{payment.partyName}</dd>
              </div>
              <div>
                <dt className="text-text-muted text-xs mb-1">Method</dt>
                <dd className="font-medium">{payment.method}</dd>
              </div>
              <div>
                <dt className="text-text-muted text-xs mb-1">Account / Gateway</dt>
                <dd className="font-medium">{payment.accountName}</dd>
              </div>
              {payment.bankReference && (
                <div>
                  <dt className="text-text-muted text-xs mb-1">Bank Reference</dt>
                  <dd className="font-mono text-xs">{payment.bankReference}</dd>
                </div>
              )}
              {payment.gatewayReference && (
                <div>
                  <dt className="text-text-muted text-xs mb-1">Gateway Reference</dt>
                  <dd className="font-mono text-xs">{payment.gatewayReference}</dd>
                </div>
              )}
              <div>
                <dt className="text-text-muted text-xs mb-1">Recorded By</dt>
                <dd className="font-medium">{payment.recordedBy}</dd>
              </div>
            </dl>
          </div>

          <div className="bg-surface p-6 rounded-xl border border-border">
            <h3 className="font-medium mb-2">Finance Actions</h3>
            <div className="space-y-2">
              <Link href="#" className="flex items-center justify-between p-3 rounded-lg border border-border hover:border-primary group transition-colors">
                <span className="text-sm font-medium">View Journal Entry</span>
                <span className="text-primary opacity-0 group-hover:opacity-100 transition-opacity">→</span>
              </Link>
              <Link href="#" className="flex items-center justify-between p-3 rounded-lg border border-border hover:border-primary group transition-colors">
                <span className="text-sm font-medium">Bank Reconciliation</span>
                <span className="text-primary opacity-0 group-hover:opacity-100 transition-opacity">→</span>
              </Link>
            </div>
          </div>

        </div>

      </div>

    </div>
  );
}
