'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';

export default function PendingPaymentsPage() {
  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Action Queue" 
        description="Review pending transfers, failed charges, and unconfirmed payments."
      />
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="px-6 py-4 border-b border-border bg-warning-bg">
            <h3 className="font-medium text-warning-dark">Pending Bank Transfers (Requires Confirmation)</h3>
          </div>
          <div className="p-8 text-center text-text-muted text-sm">
            Finance staff review physical bank statements to confirm these incoming transfers.
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="px-6 py-4 border-b border-border bg-error-bg">
            <h3 className="font-medium text-error">Failed Gateway Payments</h3>
          </div>
          <div className="p-8 text-center text-text-muted text-sm">
            Gateway transactions that were declined or timed out. Needs retry or customer contact.
          </div>
        </div>
      </div>
    </div>
  );
}
