'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { ReferralFlagsTable } from '@/features/referrals/components/ReferralFlagsTable';

export default function ReferralFlagsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto max-w-7xl">
      <PageHeader 
        title="Suspicious Referrals Queue" 
        description="Review auto-flagged referrals for potential fraud or manipulation."
        backHref="/erp/referrals"
        action={
          <div className="flex gap-2">
            <Button variant="outline">Export Queue</Button>
          </div>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <ReferralFlagsTable />
      </div>
    </div>
  );
}
