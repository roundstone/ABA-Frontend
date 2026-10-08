import { Promotion, PromotionPackage } from './types';

export const mockPackages: PromotionPackage[] = [
  {
    id: 'pkg_1',
    name: 'Homepage Spotlight - 1 Week',
    placement: 'Shop home',
    durationDays: 7,
    priceInKobo: 5000000, // 50,000 NGN
    maxSlots: 8,
    status: 'Active'
  },
  {
    id: 'pkg_2',
    name: 'Category Boost - 1 Week',
    placement: 'Category page',
    durationDays: 7,
    priceInKobo: 2500000, // 25,000 NGN
    maxSlots: 10,
    status: 'Active'
  },
  {
    id: 'pkg_3',
    name: 'Store Highlight - 1 Month',
    placement: 'Store page',
    durationDays: 30,
    priceInKobo: 10000000, // 100,000 NGN
    maxSlots: 5,
    status: 'Active'
  }
];

export const mockPromotions: Promotion[] = [
  {
    id: 'prm_1',
    reference: 'PRM-2026-0001',
    merchantId: 'mch_1',
    productId: 'prod_1',
    packageId: 'pkg_1',
    startDate: '2026-10-01T00:00:00Z',
    endDate: '2026-10-08T00:00:00Z',
    status: 'Active',
    amountPaidInKobo: 5000000,
    paymentReference: 'PAY-12345',
    impressions: 4500,
    clicks: 320,
    addToCart: 45,
    attributedOrders: 12,
    spendInKobo: 5000000
  },
  {
    id: 'prm_2',
    reference: 'PRM-2026-0002',
    merchantId: 'mch_2',
    productId: 'prod_2',
    packageId: 'pkg_2',
    startDate: '2026-10-15T00:00:00Z',
    endDate: '2026-10-22T00:00:00Z',
    status: 'Scheduled',
    amountPaidInKobo: 2500000,
    paymentReference: 'PAY-12346',
    impressions: 0,
    clicks: 0,
    addToCart: 0,
    attributedOrders: 0,
    spendInKobo: 2500000
  },
  {
    id: 'prm_3',
    reference: 'PRM-2026-0003',
    merchantId: 'mch_3',
    productId: 'prod_3',
    packageId: 'pkg_3',
    startDate: '2026-11-01T00:00:00Z',
    endDate: '2026-11-30T00:00:00Z',
    status: 'Pending payment',
    amountPaidInKobo: 10000000,
    paymentReference: 'PENDING',
    impressions: 0,
    clicks: 0,
    addToCart: 0,
    attributedOrders: 0,
    spendInKobo: 0
  },
  {
    id: 'prm_4',
    reference: 'PRM-2026-0004',
    merchantId: 'mch_1',
    productId: 'prod_4',
    packageId: 'pkg_1',
    startDate: '2026-10-10T00:00:00Z',
    endDate: '2026-10-17T00:00:00Z',
    status: 'Pending approval',
    amountPaidInKobo: 5000000,
    paymentReference: 'PAY-12347',
    impressions: 0,
    clicks: 0,
    addToCart: 0,
    attributedOrders: 0,
    spendInKobo: 5000000
  },
  {
    id: 'prm_5',
    reference: 'PRM-2026-0005',
    merchantId: 'mch_2',
    productId: 'prod_5',
    packageId: 'pkg_2',
    startDate: '2026-09-01T00:00:00Z',
    endDate: '2026-09-08T00:00:00Z',
    status: 'Expired',
    amountPaidInKobo: 2500000,
    paymentReference: 'PAY-12348',
    impressions: 8900,
    clicks: 612,
    addToCart: 89,
    attributedOrders: 25,
    spendInKobo: 2500000
  },
  {
    id: 'prm_6',
    reference: 'PRM-2026-0006',
    merchantId: 'mch_3',
    productId: 'prod_6',
    packageId: 'pkg_1',
    startDate: '2026-10-01T00:00:00Z',
    endDate: '2026-10-08T00:00:00Z',
    status: 'Paused',
    amountPaidInKobo: 5000000,
    paymentReference: 'PAY-12349',
    impressions: 1200,
    clicks: 45,
    addToCart: 3,
    attributedOrders: 1,
    spendInKobo: 5000000
  },
  {
    id: 'prm_7',
    reference: 'PRM-2026-0007',
    merchantId: 'mch_1',
    productId: 'prod_7',
    packageId: 'pkg_2',
    startDate: '2026-12-01T00:00:00Z',
    endDate: '2026-12-08T00:00:00Z',
    status: 'Rejected',
    amountPaidInKobo: 2500000,
    paymentReference: 'PAY-12350',
    impressions: 0,
    clicks: 0,
    addToCart: 0,
    attributedOrders: 0,
    spendInKobo: 0 // Refunded or not recognized
  },
  {
    id: 'prm_8',
    reference: 'PRM-2026-0008',
    merchantId: 'mch_2',
    productId: 'prod_8',
    packageId: 'pkg_3',
    startDate: '2026-10-20T00:00:00Z',
    endDate: '2026-11-19T00:00:00Z',
    status: 'Cancelled',
    amountPaidInKobo: 10000000,
    paymentReference: 'PAY-12351',
    impressions: 0,
    clicks: 0,
    addToCart: 0,
    attributedOrders: 0,
    spendInKobo: 0
  }
];
