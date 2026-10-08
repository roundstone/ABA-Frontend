import { PageHeader } from '@/components/patterns/PageHeader';
import { CommissionReversalsTable } from '@/features/commissions/components/CommissionReversalsTable';

export default function CommissionReversalsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Reversals & Clawbacks" 
        description="Manage negative commissions from cancelled or refunded orders."
        backHref="/erp/commissions"
      />
      <div className="bg-surface rounded-xl border border-border p-6">
        <CommissionReversalsTable />
      </div>
    </div>
  );
}
