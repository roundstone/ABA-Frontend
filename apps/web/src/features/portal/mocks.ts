import { PortalOrder, PortalWalletTransaction, PortalReferralStat } from './types';

export const mockPortalOrders: PortalOrder[] = [
  {
    id: 'ORD-2026-X8F9A',
    date: '2026-10-01T10:42:00Z',
    status: 'Processing',
    total: 4670000,
    paymentMethod: 'wallet',
    shippingAddress: {
      fullName: 'Jane Doe',
      street: '123 Market Street, Victoria Island',
      city: 'Lagos',
      zipCode: '101241',
      phone: '+234 801 234 5678'
    },
    items: [
      {
        id: 'item-1',
        productId: 'prod-1',
        productName: 'Apple Watch Series 9 GPS 45mm',
        price: 4520000,
        quantity: 1
      }
    ]
  }
];

export const mockPortalTransactions: PortalWalletTransaction[] = [
  {
    id: 'TRX-9823471',
    type: 'commission',
    title: 'Commission Deposit',
    date: '2026-10-01T14:30:00Z',
    amount: 500000,
    status: 'Completed'
  },
  {
    id: 'TRX-9823470',
    type: 'purchase',
    title: 'Order Payment (ORD-2026-X8F9A)',
    date: '2026-10-01T10:42:00Z',
    amount: -4670000,
    status: 'Completed'
  }
];

export const mockPortalReferrals: PortalReferralStat[] = [
  {
    referredUserId: 'usr-432',
    referredUserName: 'Michael Smith',
    joinedDate: '2026-10-01T09:00:00Z',
    status: 'Active',
    earnings: 500000
  },
  {
    referredUserId: 'usr-445',
    referredUserName: 'David Okafor',
    joinedDate: '2026-09-10T11:00:00Z',
    status: 'Pending Purchase',
    earnings: 0
  }
];
