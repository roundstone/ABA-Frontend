import { Customer } from '../types';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

interface Props {
  customer: Customer;
}

export function CustomerWalletTab({ customer }: Props) {
  const mockLedger = [
    { id: 'WL-901', date: '2023-11-10', type: 'Credit', source: 'Topup', amount: 5000000, balance: 5000000, ref: 'TXN-BANK-1' },
    { id: 'WL-902', date: '2023-11-15', type: 'Debit', source: 'Order', amount: 1500000, balance: 3500000, ref: 'ORD-893' },
  ];

  return (
    <div className="space-y-6">
      <div className="bg-surface rounded-xl border border-border p-6 flex items-center justify-between">
        <div>
          <h3 className="text-text-muted text-sm mb-1">Available Balance</h3>
          <p className="text-3xl font-bold text-success"><AmountText amountInKobo={customer.walletBalance} /></p>
        </div>
        <div className="space-x-3">
          <Button variant="outline">Adjust Balance</Button>
          <Button>Top Up Wallet</Button>
        </div>
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border bg-surface-2/30">
          <h3 className="font-medium">Wallet Ledger</h3>
        </div>
        
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left whitespace-nowrap">
            <thead className="bg-surface-2 text-text-muted">
              <tr>
                <th className="px-6 py-3 font-medium">Date</th>
                <th className="px-6 py-3 font-medium">Type</th>
                <th className="px-6 py-3 font-medium">Source</th>
                <th className="px-6 py-3 font-medium">Ref</th>
                <th className="px-6 py-3 font-medium text-right">Amount</th>
                <th className="px-6 py-3 font-medium text-right">Balance After</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {mockLedger.map(entry => (
                <tr key={entry.id} className="hover:bg-surface-2/50">
                  <td className="px-6 py-4">{new Date(entry.date).toLocaleDateString()}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2 py-1 rounded text-xs border ${
                      entry.type === 'Credit' ? 'border-success-border bg-success-bg text-success' : 'border-error-border bg-error-bg text-error'
                    }`}>
                      {entry.type}
                    </span>
                  </td>
                  <td className="px-6 py-4">{entry.source}</td>
                  <td className="px-6 py-4 font-mono text-xs">{entry.ref}</td>
                  <td className={`px-6 py-4 text-right font-medium ${entry.type === 'Credit' ? 'text-success' : 'text-error'}`}>
                    {entry.type === 'Credit' ? '+' : '-'}<AmountText amountInKobo={entry.amount} />
                  </td>
                  <td className="px-6 py-4 text-right font-medium"><AmountText amountInKobo={entry.balance} /></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
