import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';

export default function TransactionsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Cash & Bank Transactions" 
        description="View all inflows and outflows across cash, bank, and gateway accounts."
        backHref="/erp/finance"
        action={<Button>Transfer Funds</Button>}
      />
      <div className="p-12 text-center border border-dashed rounded-lg bg-surface text-text-muted">
        <p>Transaction ledger view is under construction.</p>
        <p className="text-sm mt-2">Will display all movements for Cash and Bank asset accounts.</p>
      </div>
    </div>
  );
}
