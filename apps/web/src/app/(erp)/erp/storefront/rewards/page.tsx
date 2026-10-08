import { Metadata } from 'next';
import { PageHeader } from '@/components/patterns/PageHeader';
import { RewardRulesList, RewardsLedgerTable, AdjustPointsModal } from '@/features/rewards/components';
import { brand } from '@/config/brand';

export const metadata: Metadata = {
  title: `${brand.rewardsName} Settings`,
};

export default function AdminRewardsPage() {
  return (
    <div className="space-y-8 p-6 max-w-7xl mx-auto">
      <PageHeader 
        title={`${brand.rewardsName} Management`} 
        description="Manage reward rules, ledger, and view liability"
      />

      <div className="space-y-6">
        <RewardRulesList />
        
        <div className="flex items-center justify-between mt-8">
          <h2 className="text-xl font-semibold">Ledger & Adjustments</h2>
          {/* We'll pass a default user for testing, normally you'd have a user selector in admin */}
          <AdjustPointsModal userId="user-1" />
        </div>
        
        {/* Mock userId for now to show data */}
        <RewardsLedgerTable userId="user-1" />

        <div className="border rounded-xl bg-white shadow-sm overflow-hidden">
          <div className="p-6 pb-2 border-b border-border">
            <h3 className="text-lg font-semibold">Liability Report</h3>
          </div>
          <div className="p-6">
            <p className="text-sm text-gray-500 mb-4">
              Overview of all outstanding points across the platform.
            </p>
            {/* Mock liability summary */}
            <div className="grid grid-cols-2 gap-4 max-w-md">
              <div className="p-4 border rounded">
                <div className="text-sm font-medium text-gray-500">Total Available Points</div>
                <div className="text-2xl font-bold mt-1">12,450</div>
              </div>
              <div className="p-4 border rounded">
                <div className="text-sm font-medium text-gray-500">Total Pending Points</div>
                <div className="text-2xl font-bold mt-1">4,300</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
