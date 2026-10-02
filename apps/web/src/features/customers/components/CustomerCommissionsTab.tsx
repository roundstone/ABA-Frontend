import { Customer } from '../types';
import { AmountText } from '@/components/patterns/AmountText';

interface Props {
  customer: Customer;
}

export function CustomerCommissionsTab({ customer }: Props) {
  const mockCommissions = [
    { id: 'COM-501', orderId: 'ORD-1042', level: 1, amount: 75000, status: 'Paid', payoutRef: 'PAYOUT-902', date: '2023-10-25' },
    { id: 'COM-502', orderId: 'ORD-1099', level: 2, amount: 25000, status: 'Pending', payoutRef: '-', date: '2023-11-12' },
  ];

  return (
    <div className="bg-surface rounded-xl border border-border overflow-hidden">
      <div className="p-4 border-b border-border bg-surface-2/30">
        <h3 className="font-medium">Commissions Earned</h3>
      </div>
      
      <div className="overflow-x-auto">
        <table className="w-full text-sm text-left whitespace-nowrap">
          <thead className="bg-surface-2 text-text-muted">
            <tr>
              <th className="px-6 py-3 font-medium">Ref</th>
              <th className="px-6 py-3 font-medium">Date</th>
              <th className="px-6 py-3 font-medium">Source Order</th>
              <th className="px-6 py-3 font-medium">Level</th>
              <th className="px-6 py-3 font-medium">Amount</th>
              <th className="px-6 py-3 font-medium">Status</th>
              <th className="px-6 py-3 font-medium">Payout Ref</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border">
            {mockCommissions.map(comm => (
              <tr key={comm.id} className="hover:bg-surface-2/50">
                <td className="px-6 py-4 font-mono text-text-muted">{comm.id}</td>
                <td className="px-6 py-4">{new Date(comm.date).toLocaleDateString()}</td>
                <td className="px-6 py-4 font-mono text-primary">{comm.orderId}</td>
                <td className="px-6 py-4">Level {comm.level}</td>
                <td className="px-6 py-4 font-medium text-success"><AmountText amountInKobo={comm.amount} /></td>
                <td className="px-6 py-4">
                  <span className={`px-2 py-1 rounded text-xs border ${
                    comm.status === 'Paid' ? 'border-success-border bg-success-bg text-success' : 'border-warning-border bg-warning-light text-warning-dark'
                  }`}>
                    {comm.status}
                  </span>
                </td>
                <td className="px-6 py-4 font-mono text-xs">{comm.payoutRef}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
