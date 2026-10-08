'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Switch } from '@/components/ui/switch';
import { useQuery } from '@tanstack/react-query';
import { getPayoutSettings } from '@/features/payouts/api';

export default function PayoutSettingsPage() {
  const { data: settings, isLoading } = useQuery({
    queryKey: ['payout-settings'],
    queryFn: () => getPayoutSettings()
  });

  if (isLoading) return <div>Loading settings...</div>;
  if (!settings?.data) return <div>Failed to load settings</div>;

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-4xl">
      <PageHeader 
        title="Payout Settings" 
        description="Configure rules for automated withdrawals and processing."
        backHref="/erp/payouts"
        action={<Button>Save Changes</Button>}
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-6 space-y-8">
          
          {/* Minimums and Limits */}
          <section className="space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2">Limits & Rules</h3>
            <div className="grid grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Minimum Payout Amount (₦)</label>
                <Input type="number" defaultValue={settings.data.minAmount / 100} />
                <p className="text-xs text-text-muted">Lowest allowed withdrawal.</p>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Daily Limit per Payee (₦)</label>
                <Input type="number" defaultValue={settings.data.dailyLimit / 100} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Auto-Approve Below (₦)</label>
                <Input type="number" defaultValue={settings.data.autoApproveBelow / 100} />
                <p className="text-xs text-text-muted">Requests below this bypass manual approval.</p>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Schedule</label>
                <Select defaultValue={settings.data.schedule}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="On request">On request</SelectItem>
                    <SelectItem value="Weekly Friday">Weekly Friday</SelectItem>
                    <SelectItem value="Monthly">Monthly</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
          </section>

          {/* Compliance */}
          <section className="space-y-4 pt-4 border-t border-border">
            <h3 className="font-bold text-lg border-b border-border pb-2">Compliance & Security</h3>
            <div className="grid grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Required KYC Level</label>
                <Select defaultValue={settings.data.requiredKycLevel.toString()}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="1">Level 1 (Basic)</SelectItem>
                    <SelectItem value="2">Level 2 (Identity Verified)</SelectItem>
                    <SelectItem value="3">Level 3 (Address Verified)</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Holding Period (Days)</label>
                <Input type="number" defaultValue={settings.data.holdingPeriodDays} />
                <p className="text-xs text-text-muted">Wait time before funds become available.</p>
              </div>
            </div>
            
            <div className="flex items-center justify-between p-4 bg-surface-2 rounded-lg border border-border mt-4">
              <div>
                <p className="font-medium text-sm">Enforce Account Name Matching</p>
                <p className="text-xs text-text-muted">Reject bank accounts that don't match the payee's verified legal name.</p>
              </div>
              <Switch defaultChecked />
            </div>
          </section>

        </div>
      </div>
    </div>
  );
}
