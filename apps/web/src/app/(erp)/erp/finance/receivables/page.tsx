'use client';

import { useQuery } from '@tanstack/react-query';
import { getReceivables } from '@/features/finance/api';
import { PageHeader } from '@/components/patterns/PageHeader';
import { InvoicesTable } from '@/features/finance/components/InvoicesTable';
import { Button } from '@/components/ui/button';

export default function ReceivablesPage() {
  const { data, isLoading } = useQuery({
    queryKey: ['receivables'],
    queryFn: () => getReceivables()
  });

  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Accounts Receivable" 
        description="Track and manage incoming payments from customers and merchants."
        backHref="/erp/finance"
        action={<Button>Record Payment</Button>}
      />
      <InvoicesTable data={data?.data || []} isLoading={isLoading} />
    </div>
  );
}
