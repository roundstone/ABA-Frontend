import { PageHeader } from '@/components/patterns/PageHeader';
import { CommissionRecordsTable } from '@/features/commissions/components/CommissionRecordsTable';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export default function CommissionRecordsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Commission Records" 
        description="View all generated referral commissions."
        backHref="/erp/commissions"
        action={
          <Link href="/erp/commissions/records/new">
            <Button>Manual Adjustment</Button>
          </Link>
        }
      />
      <CommissionRecordsTable />
    </div>
  );
}
