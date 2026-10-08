'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { ReferralRecordsTable } from '@/features/referrals/components/ReferralRecordsTable';

export default function ReferralRecordsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto max-w-7xl">
      <PageHeader 
        title="Referral Records" 
        description="View all referrals, their qualification status, and generated commissions."
        backHref="/erp/referrals"
        action={
          <div className="flex gap-2">
            <Button variant="outline">Export Records</Button>
          </div>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <ReferralRecordsTable />
      </div>
    </div>
  );
}
