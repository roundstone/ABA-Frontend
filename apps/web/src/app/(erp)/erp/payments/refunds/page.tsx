import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { RefundsTable } from '@/features/payments/components/RefundsTable';

export default function RefundsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Refunds" 
        description="Manage refund requests, approvals, and processing."
        backHref="/erp/payments"
        action={<Button>Process Approved</Button>}
      />
      <div className="bg-surface rounded-xl border border-border p-6">
        <RefundsTable />
      </div>
    </div>
  );
}
