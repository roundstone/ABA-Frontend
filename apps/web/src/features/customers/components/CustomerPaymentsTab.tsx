import { Customer } from '../types';
import { AmountText } from '@/components/patterns/AmountText';

interface Props {
  customer: Customer;
}

export function CustomerPaymentsTab({ customer }: Props) {
  const mockPayments = [
    { id: 'PAY-1001', date: '2023-11-01', method: 'Bank Transfer', amount: 4500000, status: 'Success', orderId: 'ORD-892' },
    { id: 'PAY-1002', date: '2023-11-15', method: 'Card', amount: 600000, status: 'Success', orderId: 'ORD-893' },
  ];

  return (
    <div className="bg-surface rounded-xl border border-border overflow-hidden">
      <div className="p-4 border-b border-border bg-surface-2/30">
        <h3 className="font-medium">Payment History</h3>
      </div>
      
      <div className="overflow-x-auto">
        <table className="w-full text-sm text-left whitespace-nowrap">
          <thead className="bg-surface-2 text-text-muted">
            <tr>
              <th className="px-6 py-3 font-medium">Ref</th>
              <th className="px-6 py-3 font-medium">Date</th>
              <th className="px-6 py-3 font-medium">Method</th>
              <th className="px-6 py-3 font-medium">Amount</th>
              <th className="px-6 py-3 font-medium">Order</th>
              <th className="px-6 py-3 font-medium">Status</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border">
            {mockPayments.map(payment => (
              <tr key={payment.id} className="hover:bg-surface-2/50 cursor-pointer">
                <td className="px-6 py-4 font-mono text-text-muted">{payment.id}</td>
                <td className="px-6 py-4">{new Date(payment.date).toLocaleDateString()}</td>
                <td className="px-6 py-4">{payment.method}</td>
                <td className="px-6 py-4 font-medium"><AmountText amountInKobo={payment.amount} /></td>
                <td className="px-6 py-4 font-mono text-primary">{payment.orderId}</td>
                <td className="px-6 py-4">
                  <span className="px-2 py-1 rounded text-xs border border-success-border bg-success-bg text-success">
                    {payment.status}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
