import { Order } from '../types';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

interface OrderPaymentsTabProps {
  order: Order;
}

export function OrderPaymentsTab({ order }: OrderPaymentsTabProps) {
  // Mock payment records for UI preview
  const mockPayments = [
    { id: 'PAY-1001', date: order.createdAt, method: 'Bank Transfer', amount: order.amountPaid, status: 'Completed', ref: 'TRX-998877' }
  ];

  return (
    <div className="space-y-6">
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-4 border-b border-border flex items-center justify-between">
          <h3 className="font-medium">Payment Records</h3>
          <Button size="sm" variant={order.balanceDue > 0 ? 'primary' : 'outline'} disabled={order.balanceDue === 0}>
            Record Payment
          </Button>
        </div>
        
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left whitespace-nowrap min-w-[800px]">
            <thead className="bg-surface-2 text-text-muted">
              <tr>
                <th className="px-6 py-3 font-medium">Payment ID</th>
                <th className="px-6 py-3 font-medium">Date</th>
                <th className="px-6 py-3 font-medium">Method</th>
                <th className="px-6 py-3 font-medium">Reference</th>
                <th className="px-6 py-3 font-medium">Status</th>
                <th className="px-6 py-3 font-medium text-right">Amount</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {mockPayments.length > 0 ? mockPayments.map(payment => (
                <tr key={payment.id}>
                  <td className="px-6 py-4 font-mono font-medium">{payment.id}</td>
                  <td className="px-6 py-4 text-text-muted">{new Date(payment.date).toLocaleString()}</td>
                  <td className="px-6 py-4">{payment.method}</td>
                  <td className="px-6 py-4 font-mono text-text-muted">{payment.ref}</td>
                  <td className="px-6 py-4">
                    <span className="px-2 py-0.5 rounded text-xs font-medium bg-success/10 text-success border border-success/20">
                      {payment.status}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right font-medium">
                    <AmountText amountInKobo={payment.amount} />
                  </td>
                </tr>
              )) : (
                <tr>
                  <td colSpan={6} className="px-6 py-8 text-center text-text-muted">
                    No payment records found.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
      
      {order.amountRefunded > 0 && (
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="p-4 border-b border-border">
            <h3 className="font-medium text-error">Refunds</h3>
          </div>
          <div className="p-6 flex justify-between items-center bg-error/5">
            <div>
              <p className="text-sm font-medium text-error">Total Refunded</p>
              <p className="text-xs text-text-muted mt-1">Amount returned to customer</p>
            </div>
            <div className="text-xl font-bold text-error">
              <AmountText amountInKobo={order.amountRefunded} />
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
