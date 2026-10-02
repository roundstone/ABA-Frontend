import { Customer } from '../types';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

interface Props {
  customer: Customer;
}

export function CustomerOrdersTab({ customer }: Props) {
  const mockOrders = [
    { id: 'ORD-892', date: '2023-11-01', items: 3, total: 4500000, paid: 4500000, balance: 0, status: 'Completed' },
    { id: 'ORD-893', date: '2023-11-15', items: 1, total: 1200000, paid: 600000, balance: 600000, status: 'Processing' },
  ];

  return (
    <div className="bg-surface rounded-xl border border-border overflow-hidden">
      <div className="p-4 border-b border-border flex justify-between items-center bg-surface-2/30">
        <h3 className="font-medium">Order History</h3>
        <Button variant="outline" size="sm">New Order</Button>
      </div>
      
      {customer.ordersCount === 0 ? (
        <div className="p-12 text-center">
          <p className="text-text-muted text-sm mb-4">No orders found for this customer.</p>
        </div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left whitespace-nowrap">
            <thead className="bg-surface-2 text-text-muted">
              <tr>
                <th className="px-6 py-3 font-medium">Order #</th>
                <th className="px-6 py-3 font-medium">Date</th>
                <th className="px-6 py-3 font-medium">Items</th>
                <th className="px-6 py-3 font-medium">Total</th>
                <th className="px-6 py-3 font-medium">Paid</th>
                <th className="px-6 py-3 font-medium">Balance</th>
                <th className="px-6 py-3 font-medium">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {mockOrders.map(order => (
                <tr key={order.id} className="hover:bg-surface-2/50 cursor-pointer">
                  <td className="px-6 py-4 font-mono font-medium text-primary">{order.id}</td>
                  <td className="px-6 py-4">{new Date(order.date).toLocaleDateString()}</td>
                  <td className="px-6 py-4">{order.items}</td>
                  <td className="px-6 py-4"><AmountText amountInKobo={order.total} /></td>
                  <td className="px-6 py-4"><AmountText amountInKobo={order.paid} /></td>
                  <td className="px-6 py-4 text-error"><AmountText amountInKobo={order.balance} /></td>
                  <td className="px-6 py-4">
                    <span className="px-2 py-1 rounded text-xs border border-border bg-surface-2">
                      {order.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
