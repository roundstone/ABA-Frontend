import { Order } from '../types';
import { Button } from '@/components/ui/button';

interface OrderTimelineTabProps {
  order: Order;
}

export function OrderTimelineTab({ order }: OrderTimelineTabProps) {
  const events = [
    {
      id: 1,
      title: 'Order Created',
      description: `Order placed by ${order.customerName} via ${order.channel}.`,
      actor: 'System',
      date: new Date(order.createdAt),
      type: 'creation'
    }
  ];

  if (order.paymentStatus !== 'Unpaid') {
    events.unshift({
      id: 2,
      title: 'Payment Received',
      description: `Payment of ₦${(order.amountPaid / 100).toLocaleString()} recorded.`,
      actor: 'Admin User',
      date: new Date(new Date(order.createdAt).getTime() + 1000 * 60 * 60), // +1 hour mock
      type: 'payment'
    });
  }

  if (order.fulfilmentStatus === 'Fulfilled') {
    events.unshift({
      id: 3,
      title: 'Order Fulfilled',
      description: 'Items were packed and marked as delivered.',
      actor: 'Merchant Staff',
      date: new Date(order.updatedAt),
      type: 'fulfilment'
    });
  }

  return (
    <div className="space-y-6">
      <div className="bg-surface rounded-xl border border-border p-6">
        <h3 className="font-medium text-lg mb-6">Activity Timeline</h3>
        
        <div className="relative border-l-2 border-border ml-3 space-y-8 pb-4">
          {events.map((event) => (
            <div key={event.id} className="relative pl-6">
              <div className={`absolute w-3 h-3 rounded-full border-2 border-surface -left-[7px] top-1.5 ${
                event.type === 'creation' ? 'bg-primary' : 
                event.type === 'payment' ? 'bg-success' : 
                event.type === 'fulfilment' ? 'bg-info' : 'bg-surface-2'
              }`} />
              
              <div className="flex flex-col sm:flex-row sm:items-baseline justify-between gap-2 mb-1">
                <h4 className="font-medium text-sm">{event.title}</h4>
                <time className="text-xs text-text-muted font-mono">{event.date.toLocaleString()}</time>
              </div>
              
              <div className="bg-surface-2 p-3 rounded-lg text-sm border border-border mt-2">
                <p>{event.description}</p>
                <p className="text-xs text-text-muted mt-2 pt-2 border-t border-border/50">
                  By: {event.actor}
                </p>
              </div>
            </div>
          ))}
        </div>
        
        <div className="mt-8 pt-6 border-t border-border">
          <label className="block text-sm font-medium mb-2">Add Comment</label>
          <div className="flex gap-3">
            <textarea 
              className="flex-1 min-h-[80px] bg-surface border border-border rounded-lg p-3 text-sm focus:ring-primary focus:border-primary resize-none"
              placeholder="Leave an internal note on this order..."
            ></textarea>
          </div>
          <div className="flex justify-end mt-3">
            <Button size="sm">Add Note</Button>
          </div>
        </div>
      </div>
    </div>
  );
}
