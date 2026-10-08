import { PageHeader } from '@/components/patterns/PageHeader';
import { FinancialPeriodsTable } from '@/features/finance/components/FinancialPeriodsTable';

export default function FinancialPeriodsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Financial Periods" 
        description="Manage accounting periods, month-end closes, and period locks."
        backHref="/erp/finance"
      />
      <FinancialPeriodsTable />
    </div>
  );
}
