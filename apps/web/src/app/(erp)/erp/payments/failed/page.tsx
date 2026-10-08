import { PageHeader } from '@/components/patterns/PageHeader';
import { FailedPaymentsTable } from '@/features/payments/components/FailedPaymentsTable';

export default function FailedPaymentsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Failed & Pending Queue" 
        description="Monitor delayed transfers, failed card charges, and unconfirmed payments."
        backHref="/erp/payments"
      />
      <div className="bg-surface rounded-xl border border-border p-6">
        <FailedPaymentsTable />
      </div>
    </div>
  );
}
