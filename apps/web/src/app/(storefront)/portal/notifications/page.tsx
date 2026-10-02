import React from 'react';
import { Bell, Package, Wallet, Tag, CreditCard, ArrowUpRight } from 'lucide-react';
import { Button } from '@/components/ui/button';

export default function PortalNotifications() {
  const notifications = [
    {
      id: 1,
      type: 'order',
      title: 'Order Shipped',
      message: 'Your order ORD-2026-X8F9A has been shipped and is on its way.',
      time: '2 hours ago',
      read: false,
      icon: Package,
      iconBg: 'bg-brand-100',
      iconColor: 'text-brand-600',
    },
    {
      id: 2,
      type: 'wallet',
      title: 'Commission Received',
      message: 'You have received a ₦5,000 commission from your referral.',
      time: 'Yesterday',
      read: false,
      icon: Wallet,
      iconBg: 'bg-success-bg',
      iconColor: 'text-success-main',
    },
    {
      id: 3,
      type: 'promo',
      title: 'Flash Sale Starts Tomorrow!',
      message: 'Get ready for up to 50% off on all electronics starting tomorrow at 10 AM.',
      time: 'Oct 1, 2026',
      read: true,
      icon: Tag,
      iconBg: 'bg-warning-light',
      iconColor: 'text-warning-dark',
    },
    {
      id: 4,
      type: 'system',
      title: 'Account Verification Required',
      message: 'Please complete your KYC to unlock full withdrawal limits.',
      time: 'Sep 28, 2026',
      read: true,
      icon: CreditCard,
      iconBg: 'bg-error-100',
      iconColor: 'text-error',
    },
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <h1 className="text-2xl font-bold text-text">Notifications</h1>
        <Button variant="outline" size="sm">Mark all as read</Button>
      </div>

      <div className="bg-white rounded-xl border border-border shadow-sm overflow-hidden">
        <div className="divide-y divide-border">
          {notifications.map((notification) => {
            const Icon = notification.icon;
            return (
              <div 
                key={notification.id} 
                className={`p-4 sm:p-6 flex items-start gap-4 transition-colors hover:bg-surface-1 ${!notification.read ? 'bg-brand-50/30' : ''}`}
              >
                <div className={`w-12 h-12 rounded-full flex items-center justify-center shrink-0 ${notification.iconBg}`}>
                  <Icon className={`w-6 h-6 ${notification.iconColor}`} />
                </div>
                
                <div className="flex-1">
                  <div className="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-1 mb-1">
                    <h3 className={`text-base font-semibold ${!notification.read ? 'text-text' : 'text-text-muted'}`}>
                      {notification.title}
                    </h3>
                    <span className="text-xs font-medium text-text-muted whitespace-nowrap">
                      {notification.time}
                    </span>
                  </div>
                  <p className="text-sm text-text-muted mb-3">
                    {notification.message}
                  </p>
                  
                  {notification.type === 'order' && (
                    <Button variant="outline" size="sm" className="h-8 text-xs font-semibold">
                      Track Order
                    </Button>
                  )}
                  {notification.type === 'wallet' && (
                    <Button variant="outline" size="sm" className="h-8 text-xs font-semibold">
                      View Wallet
                    </Button>
                  )}
                  {notification.type === 'system' && (
                    <Button size="sm" className="h-8 text-xs font-semibold bg-error text-white hover:bg-error-hover">
                      Verify Now
                    </Button>
                  )}
                </div>
                
                {!notification.read && (
                  <div className="w-2.5 h-2.5 rounded-full bg-brand-600 shrink-0 mt-2"></div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
