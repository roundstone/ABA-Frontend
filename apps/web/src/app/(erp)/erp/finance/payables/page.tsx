'use client';

import { useQuery } from '@tanstack/react-query';
import { getPayables } from '@/features/finance/api';
import { PageHeader } from '@/components/patterns/PageHeader';
import { InvoicesTable } from '@/features/finance/components/InvoicesTable';
import { Button } from '@/components/ui/button';

export default function PayablesPage() {
  const { data, isLoading } = useQuery({
    queryKey: ['payables'],
    queryFn: () => getPayables()
  });

  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Accounts Payable" 
        description="Track and manage outgoing payments to suppliers and vendors."
        backHref="/erp/finance"
        action={<Button>Record Payment</Button>}
      />
      <InvoicesTable data={data?.data || []} isLoading={isLoading} />
    </div>
  );
}
