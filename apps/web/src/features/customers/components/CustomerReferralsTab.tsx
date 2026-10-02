import { Customer } from '../types';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

interface Props {
  customer: Customer;
}

export function CustomerReferralsTab({ customer }: Props) {
  const mockReferrals = [
    { id: 'REF-001', name: 'John Doe', phone: '08012345678', status: 'Qualified', date: '2023-10-20', firstOrderValue: 1500000, commission: 75000 },
    { id: 'REF-002', name: 'Jane Smith', phone: '08123456789', status: 'Pending', date: '2023-11-05', firstOrderValue: 0, commission: 0 },
  ];

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-surface p-6 rounded-xl border border-border md:col-span-1 space-y-4">
          <div>
            <h3 className="text-text-muted text-xs mb-1">Referral Code</h3>
            <div className="font-mono bg-surface-2 p-2 rounded border border-border inline-block">
              {customer.referralCode}
            </div>
          </div>
          <div>
            <h3 className="text-text-muted text-xs mb-1">Total Referrals</h3>
            <p className="font-medium text-lg">{customer.referralsCount}</p>
          </div>
          <div>
            <h3 className="text-text-muted text-xs mb-1">Qualified Referrals</h3>
            <p className="font-medium text-lg">1</p>
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border md:col-span-2 overflow-hidden flex flex-col">
          <div className="p-4 border-b border-border bg-surface-2/30 flex justify-between items-center">
            <h3 className="font-medium">Referred Customers</h3>
            <Button variant="outline" size="sm">List / Tree View</Button>
          </div>
          
          <div className="overflow-x-auto flex-1">
            <table className="w-full text-sm text-left whitespace-nowrap">
              <thead className="bg-surface-2 text-text-muted">
                <tr>
                  <th className="px-6 py-3 font-medium">Customer</th>
                  <th className="px-6 py-3 font-medium">Status</th>
                  <th className="px-6 py-3 font-medium">Joined Date</th>
                  <th className="px-6 py-3 font-medium">First Order Value</th>
                  <th className="px-6 py-3 font-medium">Commission</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {mockReferrals.map(ref => (
                  <tr key={ref.id} className="hover:bg-surface-2/50">
                    <td className="px-6 py-4">
                      <p className="font-medium">{ref.name}</p>
                      <p className="text-xs text-text-muted">{ref.phone}</p>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`px-2 py-1 rounded text-xs border ${
                        ref.status === 'Qualified' ? 'border-success-border bg-success-bg text-success' : 'border-warning-border bg-warning-light text-warning-dark'
                      }`}>
                        {ref.status}
                      </span>
                    </td>
                    <td className="px-6 py-4">{new Date(ref.date).toLocaleDateString()}</td>
                    <td className="px-6 py-4">{ref.firstOrderValue > 0 ? <AmountText amountInKobo={ref.firstOrderValue} /> : '-'}</td>
                    <td className="px-6 py-4">{ref.commission > 0 ? <AmountText amountInKobo={ref.commission} className="text-success font-medium" /> : '-'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
