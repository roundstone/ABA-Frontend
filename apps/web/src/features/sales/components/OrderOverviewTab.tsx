import { Order } from '../types';

interface OrderOverviewTabProps {
  order: Order;
}

export function OrderOverviewTab({ order }: OrderOverviewTabProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div className="bg-surface p-6 rounded-xl border border-border">
        <h3 className="font-medium text-lg mb-4">Customer & Merchant</h3>
        <dl className="space-y-4 text-sm">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <dt className="text-text-muted text-xs mb-1">Customer</dt>
              <dd className="font-medium">{order.customerName}</dd>
            </div>
            <div>
              <dt className="text-text-muted text-xs mb-1">Contact</dt>
              <dd className="font-medium">{order.customerPhone || 'N/A'}</dd>
            </div>
          </div>
          <div>
            <dt className="text-text-muted text-xs mb-1">Fulfilling Merchant</dt>
            <dd className="font-medium">{order.merchantName}</dd>
          </div>
          <div>
            <dt className="text-text-muted text-xs mb-1">Referral / Commission</dt>
            <dd className="font-medium text-primary cursor-pointer hover:underline">View referral chain →</dd>
          </div>
        </dl>
      </div>

      <div className="bg-surface p-6 rounded-xl border border-border">
        <h3 className="font-medium text-lg mb-4">Delivery Info</h3>
        <dl className="space-y-4 text-sm">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <dt className="text-text-muted text-xs mb-1">Method</dt>
              <dd className="font-medium">{order.deliveryMethod || 'Not specified'}</dd>
            </div>
            <div>
              <dt className="text-text-muted text-xs mb-1">Expected Date</dt>
              <dd className="font-medium text-primary">{order.expectedDeliveryDate || 'ASAP'}</dd>
            </div>
          </div>
          <div>
            <dt className="text-text-muted text-xs mb-1">Address</dt>
            <dd className="font-medium">{order.deliveryAddress || 'Store Pickup'}</dd>
          </div>
          <div>
            <dt className="text-text-muted text-xs mb-1">Notes</dt>
            <dd className="font-medium text-text-muted italic">{order.notes || 'No delivery notes provided.'}</dd>
          </div>
        </dl>
      </div>
    </div>
  );
}
