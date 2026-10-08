import { PageHeader } from '@/components/patterns/PageHeader';
import { ExpensesTable } from '@/features/finance/components/ExpensesTable';
import { Button } from '@/components/ui/button';

export default function ExpensesPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Expenses" 
        description="Track and manage all operational expenses."
        backHref="/erp/finance"
        action={<Button>Record Expense</Button>}
      />
      <ExpensesTable />
    </div>
  );
}
