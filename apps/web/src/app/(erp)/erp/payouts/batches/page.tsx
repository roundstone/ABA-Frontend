'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { PayoutBatchesTable } from '@/features/payouts/components/PayoutBatchesTable';

export default function PayoutBatchesPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto max-w-7xl">
      <PageHeader 
        title="Payout Batches" 
        description="Manage grouped payouts sent for bulk processing."
        backHref="/erp/payouts"
        action={<Button>Create New Batch</Button>}
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <PayoutBatchesTable />
      </div>
    </div>
  );
}
