'use client';

import Link from 'next/link';
import { useQuery } from '@tanstack/react-query';
import { getPaymentKPIs } from '@/features/payments/api';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { PaymentsTable } from '@/features/payments/components/PaymentsTable';

export default function PaymentsDashboardPage() {
  const { data: kpis, isLoading } = useQuery({
    queryKey: ['payment-kpis'],
    queryFn: () => getPaymentKPIs()
  });

  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Payments" 
        description="Manage all incoming and outgoing payments, refunds, and reconciliation."
        action={
          <div className="flex gap-2">
            <Link href="/erp/payments/reconciliation">
              <Button variant="outline">Reconcile</Button>
            </Link>
            <Button>Record Payment</Button>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard 
          title="Collected (Period)" 
          value={isLoading ? '...' : <AmountText amountInKobo={kpis?.collectedPeriod || 0} />} 
          className="text-success" 
        />
        <KpiCard 
          title="Pending Transfers" 
          value={isLoading ? '...' : <AmountText amountInKobo={kpis?.pending || 0} />} 
          className="text-warning-dark"
        />
        <KpiCard 
          title="Failed / Failed Refund" 
          value={isLoading ? '...' : <AmountText amountInKobo={(kpis?.failed || 0) + (kpis?.refunded || 0)} />} 
          className="text-error" 
        />
        <KpiCard 
          title="Due Out (Suppliers)" 
          value={isLoading ? '...' : <AmountText amountInKobo={kpis?.paymentsDueOut || 0} />} 
        />
      </div>

      <div className="grid grid-cols-1 gap-6">
        <div className="bg-surface rounded-xl border border-border p-6">
          <div className="flex justify-between items-center mb-4">
             <h2 className="text-lg font-bold">Payment Records</h2>
             <div className="flex gap-2">
                <Link href="/erp/payments/refunds"><Button variant="outline" size="sm">Refunds</Button></Link>
                <Link href="/erp/payments/failed"><Button variant="outline" size="sm">Failed Queue</Button></Link>
                <Link href="/erp/payments/methods"><Button variant="outline" size="sm">Settings</Button></Link>
             </div>
          </div>
          <PaymentsTable />
        </div>
      </div>
    </div>
  );
}
