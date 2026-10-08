import { PageHeader } from '@/components/patterns/PageHeader';
import { ChartOfAccountsTable } from '@/features/finance/components/ChartOfAccountsTable';

export default function ChartOfAccountsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Chart of Accounts" 
        description="Manage your ledger accounts and their current balances."
        backHref="/erp/finance"
      />
      <ChartOfAccountsTable />
    </div>
  );
}
