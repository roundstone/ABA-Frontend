import { Order } from '../types';
import { AmountText } from '@/components/patterns/AmountText';

interface OrderItemsTabProps {
  order: Order;
}

export function OrderItemsTab({ order }: OrderItemsTabProps) {
  return (
    <div className="bg-surface rounded-xl border border-border overflow-hidden">
      <div className="overflow-x-auto">
        <table className="w-full text-sm text-left whitespace-nowrap min-w-[800px]">
          <thead className="bg-surface-2 text-text-muted">
            <tr>
              <th className="px-6 py-3 font-medium">Product / SKU</th>
              <th className="px-6 py-3 font-medium text-center">Qty</th>
              <th className="px-6 py-3 font-medium text-right">Unit Price</th>
              <th className="px-6 py-3 font-medium text-right">Discount</th>
              <th className="px-6 py-3 font-medium text-right">Tax</th>
              <th className="px-6 py-3 font-medium text-right">Line Total</th>
              <th className="px-6 py-3 font-medium text-center">Status</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border">
            {order.lines.map(line => (
              <tr key={line.id}>
                <td className="px-6 py-4">
                  <p className="font-medium text-text">{line.productName}</p>
                  <p className="text-xs text-text-muted font-mono mt-0.5">{line.sku}</p>
                </td>
                <td className="px-6 py-4 text-center font-medium">{line.quantity}</td>
                <td className="px-6 py-4 text-right"><AmountText amountInKobo={line.unitPrice} /></td>
                <td className="px-6 py-4 text-right"><AmountText amountInKobo={line.discount} /></td>
                <td className="px-6 py-4 text-right"><AmountText amountInKobo={line.tax} /></td>
                <td className="px-6 py-4 text-right font-medium"><AmountText amountInKobo={line.lineTotal} /></td>
                <td className="px-6 py-4 text-center">
                  <span className={`px-2 py-0.5 rounded text-xs font-medium border ${
                    line.status === 'Fulfilled' ? 'bg-success/10 text-success border-success/20' :
                    line.status === 'Returned' ? 'bg-error/10 text-error border-error/20' :
                    'bg-surface-2 text-text-muted border-border'
                  }`}>
                    {line.status || 'Pending'}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="bg-surface-2 p-6 border-t border-border flex justify-end">
        <div className="w-full max-w-xs space-y-3">
          <div className="flex justify-between text-sm">
            <span className="text-text-muted">Subtotal</span>
            <span className="font-medium"><AmountText amountInKobo={order.subtotal} /></span>
          </div>
          {order.discountTotal > 0 && (
            <div className="flex justify-between text-sm">
              <span className="text-text-muted">Order Discount</span>
              <span className="text-error font-medium">-<AmountText amountInKobo={order.discountTotal} /></span>
            </div>
          )}
          <div className="flex justify-between text-sm">
            <span className="text-text-muted">Tax (VAT/Consumption)</span>
            <span className="font-medium"><AmountText amountInKobo={order.taxTotal} /></span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-text-muted">Delivery Fee</span>
            <span className="font-medium"><AmountText amountInKobo={order.deliveryFee} /></span>
          </div>
          <div className="flex justify-between items-center font-medium text-lg pt-4 border-t border-border">
            <span>Total</span>
            <span className="text-primary font-bold"><AmountText amountInKobo={order.totalAmount} /></span>
          </div>
        </div>
      </div>
    </div>
  );
}
