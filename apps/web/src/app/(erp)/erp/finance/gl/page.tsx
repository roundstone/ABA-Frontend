import { PageHeader } from '@/components/patterns/PageHeader';
import { GeneralLedgerTable } from '@/features/finance/components/GeneralLedgerTable';

export default function GeneralLedgerPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="General Ledger" 
        description="View and manage all journal entries across the system."
        backHref="/erp/finance"
      />
      <GeneralLedgerTable />
    </div>
  );
}
