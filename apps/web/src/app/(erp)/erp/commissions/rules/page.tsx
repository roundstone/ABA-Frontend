'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function CommissionRulesPage() {
  return (
    <div className="space-y-6 pb-20 max-w-5xl mx-auto">
      <PageHeader 
        title="Commission & Profit Sharing Rules" 
        description="Configure how margins are split between the company, referrers, and customers."
        action={<Button>Save Changes</Button>}
      />

      {/* Global Margin Split Card - Addressing User Specific Request */}
      <div className="bg-surface rounded-xl border border-border p-6 shadow-sm">
        <div className="border-b border-border pb-4 mb-6">
          <h2 className="text-lg font-bold">Global Split Configuration</h2>
          <p className="text-sm text-text-muted">Define the base distribution of the commissionable margin.</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {/* Company Share */}
          <div className="space-y-3 p-4 rounded-lg bg-surface-2 border border-border">
            <div className="flex justify-between items-center">
              <label className="font-bold text-primary">Company Share</label>
              <span className="text-2xl font-black">25%</span>
            </div>
            <p className="text-xs text-text-muted leading-relaxed">
              Retained by ABA for operational costs and corporate profit.
            </p>
            <Input type="number" defaultValue={25} className="font-mono" suffix="%" />
          </div>

          {/* Referrers Share */}
          <div className="space-y-3 p-4 rounded-lg bg-success-bg border border-success-border">
            <div className="flex justify-between items-center">
              <label className="font-bold text-success-dark">Referrer / Upline</label>
              <span className="text-2xl font-black text-success-dark">30%</span>
            </div>
            <p className="text-xs text-success-dark/80 leading-relaxed">
              Distributed across the network tree (Level 1, Level 2, etc.) based on network depth settings.
            </p>
            <Input type="number" defaultValue={30} className="font-mono border-success/30 focus-visible:ring-success" suffix="%" />
          </div>

          {/* Referee / Customer Share */}
          <div className="space-y-3 p-4 rounded-lg bg-warning-bg border border-warning-border">
            <div className="flex justify-between items-center">
              <label className="font-bold text-warning-dark">Referee (Buyer)</label>
              <span className="text-2xl font-black text-warning-dark">45%</span>
            </div>
            <p className="text-xs text-warning-dark/80 leading-relaxed">
              Instant discount or cashback awarded to the customer making the purchase.
            </p>
            <Input type="number" defaultValue={45} className="font-mono border-warning/30 focus-visible:ring-warning" suffix="%" />
          </div>
        </div>

        {/* Validation Warning */}
        <div className="mt-6 flex items-center justify-between p-3 rounded bg-surface-2 border border-border text-sm">
          <span className="font-medium">Total Allocation Check:</span>
          <span className="font-mono font-bold text-success">100% (Valid)</span>
        </div>
      </div>

      {/* Network Distribution Details */}
      <div className="bg-surface rounded-xl border border-border p-6 shadow-sm">
        <h3 className="font-medium mb-4">Upline Network Distribution (The 30% Pool)</h3>
        <p className="text-sm text-text-muted mb-6">
          Configure how the 30% allocated to Referrers is split among the upline tree.
        </p>
        
        <div className="space-y-4 max-w-md">
          <div className="flex items-center gap-4">
            <label className="w-24 text-sm font-medium">Level 1 (Direct)</label>
            <Input type="number" defaultValue={60} className="w-32" suffix="% of Pool" />
            <span className="text-xs text-text-muted">= 18% of Total Margin</span>
          </div>
          <div className="flex items-center gap-4">
            <label className="w-24 text-sm font-medium">Level 2</label>
            <Input type="number" defaultValue={30} className="w-32" suffix="% of Pool" />
            <span className="text-xs text-text-muted">= 9% of Total Margin</span>
          </div>
          <div className="flex items-center gap-4">
            <label className="w-24 text-sm font-medium">Level 3</label>
            <Input type="number" defaultValue={10} className="w-32" suffix="% of Pool" />
            <span className="text-xs text-text-muted">= 3% of Total Margin</span>
          </div>
        </div>
      </div>

    </div>
  );
}
