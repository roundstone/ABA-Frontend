import { PageHeader } from '@/components/patterns/PageHeader';
import { CommissionRulesTable } from '@/features/commissions/components/CommissionRulesTable';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export default function CommissionRulesPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Plans & Rules" 
        description="Configure commission plans, earning rules, and network depth."
        backHref="/erp/commissions"
        action={
          <Link href="/erp/commissions/rules/new">
            <Button>Create Plan</Button>
          </Link>
        }
      />
      <CommissionRulesTable />
    </div>
  );
}
