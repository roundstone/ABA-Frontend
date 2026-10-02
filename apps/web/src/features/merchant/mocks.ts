import { Merchant } from '../merchants/types';
import { MerchantProfile, MerchantReview } from './types';

export const MOCK_MERCHANTS: Merchant[] = [
  {
    id: 'mer-1',
    merchantNo: 'MER-1001',
    name: 'Ikeja Flagship Store',
    legalName: 'ABA Retail Ltd',
    logoUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?q=80&w=2304&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    bannerImage: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=1200&q=80',
    type: 'Own outlet',
    description: "We sell everything!",
    ownerName: 'Admin Team',
    phone: '+2348000000001',
    email: 'ikeja@aba.com',
    address: '123 Retail Avenue',
    city: 'Ikeja',
    state: 'Lagos',
    settlementBank: { bankName: 'GTBank', accountNumber: '0123456789', accountName: 'ABA Retail Ltd' },
    settlementFrequency: 'Weekly',
    priceList: 'Default',
    discountLimit: 10,
    creditLimit: 0,
    status: 'Active',
    onboardedAt: '2026-09-01T10:00:00Z',
    salesPeriod: 450000000, // 4.5m NGN
    ordersCount: 342,
    stockValue: 1200000000,
    outstandingBalance: 0,
  },
  {
    id: 'mer-2',
    merchantNo: 'MER-1002',
    name: 'Mainland Distributors',
    legalName: 'Mainland Dist. Nig Ltd',
    logoUrl: "https://images.unsplash.com/photo-1542838132-92c53300491e",
    bannerImage: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    type: 'Partner',
    description: "We sell everything!",
    ownerName: 'Samuel Okoro',
    phone: '+2348098765432',
    email: 'samuel@mainland.com',
    address: '45 Distributor Road',
    city: 'Surulere',
    state: 'Lagos',
    settlementBank: { bankName: 'Zenith Bank', accountNumber: '9876543210', accountName: 'Mainland Dist. Nig Ltd' },
    settlementFrequency: 'Weekly',
    priceList: 'Wholesale',
    discountLimit: 0,
    creditLimit: 500000000, // 5m NGN
    status: 'Pending',
    onboardedAt: '2026-09-28T14:30:00Z',
    salesPeriod: 0,
    ordersCount: 0,
    stockValue: 0,
    outstandingBalance: 0,
  }
];

export const mockMerchantReviews: Record<string, MerchantReview[]> = {
  'mer-1': [
    {
      id: 'rev-1',
      authorName: 'John D.',
      rating: 5,
      comment: 'Excellent service and authentic products. Highly recommend!',
      date: '2026-09-20'
    },
    {
      id: 'rev-2',
      authorName: 'Sarah K.',
      rating: 4,
      comment: 'Fast delivery, but packaging could be slightly better.',
      date: '2026-09-15'
    }
  ]
};
