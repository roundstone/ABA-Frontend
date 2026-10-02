import { Customer } from '../types';

interface Props {
  customer: Customer;
}

export function CustomerActivityTab({ customer }: Props) {
  const mockActivity = [
    { id: 1, action: 'Order Placed', details: 'Placed order ORD-893 for ₦1,200,000', date: '2023-11-15T14:30:00Z', user: customer.firstName },
    { id: 2, action: 'Wallet Topup', details: 'Added ₦5,000,000 to wallet', date: '2023-11-10T09:15:00Z', user: customer.firstName },
    { id: 3, action: 'Customer Registered', details: 'Account created via Web', date: customer.registeredAt, user: 'System' },
  ];

  return (
    <div className="bg-surface rounded-xl border border-border p-6">
      <h3 className="font-medium mb-6">Activity Timeline</h3>
      
      <div className="relative border-l border-border ml-3 space-y-8">
        {mockActivity.map((activity) => (
          <div key={activity.id} className="relative pl-6">
            <div className="absolute -left-1.5 top-1.5 w-3 h-3 rounded-full bg-border border-2 border-surface" />
            <div className="mb-1">
              <span className="font-medium text-text">{activity.action}</span>
              <span className="mx-2 text-text-muted">•</span>
              <span className="text-xs text-text-muted">
                {new Date(activity.date).toLocaleString()}
              </span>
            </div>
            <p className="text-sm text-text-muted mb-1">{activity.details}</p>
            <p className="text-xs text-text-muted">By: {activity.user}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
