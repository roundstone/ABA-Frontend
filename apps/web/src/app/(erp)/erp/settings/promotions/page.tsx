import React from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { PromotionPackagesTable } from '@/features/promotions/components/PromotionPackagesTable';
import { Button } from '@/components/ui/button';

export default function PromotionPackagesSettingsPage() {
  return (
    <div className="space-y-6">
      <PageHeader 
        title="Promotion Packages" 
        description="Configure available promotional packages and placements for merchants."
        action={
          <Button asChild>
            <Link href="/erp/settings/promotions/new">New Package</Link>
          </Button>
        }
      />
      
      <div className="bg-white rounded-xl shadow-sm border p-6">
        <PromotionPackagesTable />
      </div>
    </div>
  );
}
