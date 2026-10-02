'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';

export default function RefundsPage() {
  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Refunds" 
        description="Manage customer refunds, returns, and reversals."
        action={
          <Button>Process New Refund</Button>
        }
      />
      <div className="bg-surface rounded-xl border border-border p-12 text-center text-text-muted">
        <p>Refunds list tracking requested, approved, and processed refunds.</p>
        <p className="text-sm mt-2">Requires integration with Orders returns workflow.</p>
      </div>
    </div>
  );
}
