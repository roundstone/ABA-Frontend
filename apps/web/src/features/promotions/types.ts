export type PromotionStatus = 'Pending payment' | 'Pending approval' | 'Scheduled' | 'Active' | 'Paused' | 'Expired' | 'Rejected' | 'Cancelled';

export type PromotionPlacement = 'Shop home' | 'Category page' | 'Store page';

export interface PromotionPackage {
  id: string;
  name: string;
  placement: PromotionPlacement;
  durationDays: number;
  priceInKobo: number;
  maxSlots: number;
  status: 'Active' | 'Inactive';
}

export interface Promotion {
  id: string;
  reference: string; // PRM-...
  merchantId: string;
  productId: string;
  packageId: string;
  startDate: string;
  endDate: string;
  status: PromotionStatus;
  amountPaidInKobo: number;
  paymentReference: string;
  
  // Stats
  impressions: number;
  clicks: number;
  addToCart: number;
  attributedOrders: number;
  spendInKobo: number; // for merchant reporting
}

export interface PromotionAnalytics {
  totalImpressions: number;
  totalClicks: number;
  ctr: number;
  totalAddToCart: number;
  totalOrders: number;
  totalSpendInKobo: number;
}
