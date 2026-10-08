'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { ReferralCodesTable } from '@/features/referrals/components/ReferralCodesTable';

export default function ReferralCodesPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto max-w-7xl">
      <PageHeader 
        title="Referral Codes & Links" 
        description="Manage the unique identifier codes distributed to your referrers."
        backHref="/erp/referrals"
        action={
          <div className="flex gap-2">
            <Button variant="outline">Export Codes</Button>
          </div>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <ReferralCodesTable />
      </div>
    </div>
  );
}
