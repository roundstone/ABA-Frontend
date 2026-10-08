import { PageHeader } from '@/components/patterns/PageHeader';
import { CommissionApprovalsTable } from '@/features/commissions/components/CommissionApprovalsTable';
import { Button } from '@/components/ui/button';

export default function CommissionApprovalsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Pending Approvals" 
        description="Review and approve pending commission records."
        backHref="/erp/commissions"
        action={<Button>Bulk Approve Selected</Button>}
      />
      <div className="bg-surface rounded-xl border border-border p-6">
        <CommissionApprovalsTable />
      </div>
    </div>
  );
}
