import React from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { PromotionsTable } from '@/features/promotions/components/PromotionsTable';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export default function PromotionsAdminPage() {
  return (
    <div className="space-y-6">
      <PageHeader 
        title="Promotions" 
        description="Manage product promotions, view revenue, and approve requests."
        action={
          <Button asChild>
            <Link href="/erp/promotions/new">Create Promotion</Link>
          </Button>
        }
      />
      
      <div className="bg-white rounded-xl shadow-sm border p-6">
        <PromotionsTable />
      </div>
    </div>
  );
}
