'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Switch } from '@/components/ui/switch';

export default function ReferralSettingsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto max-w-4xl">
      <PageHeader 
        title="Referral Program Settings" 
        description="Configure rules, qualification triggers, and abuse prevention."
        backHref="/erp/referrals"
        action={<Button>Save Settings</Button>}
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-6 space-y-8">
          
          <section className="space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2">Program Core</h3>
            <div className="grid grid-cols-2 gap-6">
              <div className="flex items-center justify-between p-4 bg-surface-2 rounded-lg border border-border col-span-2">
                <div>
                  <p className="font-medium text-sm">Program Status</p>
                  <p className="text-xs text-text-muted">Enable or disable the referral program entirely.</p>
                </div>
                <Switch defaultChecked />
              </div>

              <div className="space-y-2">
                <label className="text-sm font-medium">Who can refer?</label>
                <Select defaultValue="verified">
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Customers</SelectItem>
                    <SelectItem value="verified">Verified Customers Only</SelectItem>
                    <SelectItem value="groups">Selected Groups</SelectItem>
                    <SelectItem value="merchants">Merchants Only</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <label className="text-sm font-medium">Max Levels Tracked</label>
                <Input type="number" defaultValue={5} />
                <p className="text-xs text-text-muted">Aligns with commission plan depth.</p>
              </div>
            </div>
          </section>

          <section className="space-y-4 pt-4 border-t border-border">
            <h3 className="font-bold text-lg border-b border-border pb-2">Attribution & Qualification</h3>
            <div className="grid grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Attribution Window (Days)</label>
                <Input type="number" defaultValue={30} />
                <p className="text-xs text-text-muted">How long a clicked link attributes a signup.</p>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Referral Expiry (Days)</label>
                <Input type="number" defaultValue={90} />
                <p className="text-xs text-text-muted">Time from signup to first order before expiring.</p>
              </div>
              
              <div className="space-y-2 col-span-2">
                <label className="text-sm font-medium">Qualification Trigger</label>
                <Select defaultValue="order_paid">
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="signup">On Signup</SelectItem>
                    <SelectItem value="order_placed">First Order Placed</SelectItem>
                    <SelectItem value="order_paid">First Order Paid</SelectItem>
                    <SelectItem value="order_delivered">First Order Delivered</SelectItem>
                  </SelectContent>
                </Select>
                <p className="text-xs text-text-muted">Mirrors the commission engine's trigger point.</p>
              </div>
            </div>
          </section>

          <section className="space-y-4 pt-4 border-t border-border">
            <h3 className="font-bold text-lg border-b border-border pb-2">Fraud Prevention</h3>
            <div className="grid grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Max Referrals / Day / User</label>
                <Input type="number" defaultValue={100} />
              </div>
              
              <div className="flex items-center justify-between p-4 bg-surface-2 rounded-lg border border-border col-span-2">
                <div>
                  <p className="font-medium text-sm">Block Same-Device Chains</p>
                  <p className="text-xs text-text-muted">Automatically flag if referrer and referred use the same device hash or IP.</p>
                </div>
                <Switch defaultChecked />
              </div>
            </div>
          </section>

        </div>
      </div>
    </div>
  );
}
