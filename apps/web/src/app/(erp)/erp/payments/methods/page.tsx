'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Switch } from '@/components/ui/switch';

export default function PaymentMethodsPage() {
  const methods = [
    { id: 1, name: 'Bank Transfer (NIBSS)', type: 'Transfer', active: true, fee: 'Flat ₦50', provider: 'Internal' },
    { id: 2, name: 'Paystack Checkout', type: 'Gateway', active: true, fee: '1.5% + ₦100 (capped at ₦2,000)', provider: 'Paystack' },
    { id: 3, name: 'Flutterwave Card', type: 'Gateway', active: false, fee: '1.4%', provider: 'Flutterwave' },
    { id: 4, name: 'ABA Wallet', type: 'Wallet', active: true, fee: 'Free', provider: 'Internal' },
    { id: 5, name: 'Cash', type: 'Cash', active: true, fee: 'Free', provider: 'Internal' },
  ];

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-5xl">
      <PageHeader 
        title="Payment Methods & Gateways" 
        description="Configure accepted payment methods, gateways, and routing rules."
        backHref="/erp/payments"
        action={<Button>Add Method</Button>}
      />
      
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-surface-2 border-b border-border text-sm">
              <th className="p-4 font-semibold text-text-muted">Method Name</th>
              <th className="p-4 font-semibold text-text-muted">Type</th>
              <th className="p-4 font-semibold text-text-muted">Provider</th>
              <th className="p-4 font-semibold text-text-muted">Customer Fee Structure</th>
              <th className="p-4 font-semibold text-text-muted">Status</th>
              <th className="p-4 font-semibold text-text-muted text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {methods.map(m => (
              <tr key={m.id} className="border-b border-border hover:bg-surface-2/50">
                <td className="p-4 font-medium">{m.name}</td>
                <td className="p-4"><Badge variant="outline">{m.type}</Badge></td>
                <td className="p-4 text-sm">{m.provider}</td>
                <td className="p-4 text-sm">{m.fee}</td>
                <td className="p-4">
                  <div className="flex items-center gap-2">
                    <Switch checked={m.active} />
                    <span className="text-sm">{m.active ? 'Active' : 'Disabled'}</span>
                  </div>
                </td>
                <td className="p-4 text-right">
                  <Button variant="ghost" size="sm">Configure</Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
