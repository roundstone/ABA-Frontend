import { Product } from '@/features/products/types';

export type SpotlightMode = 'Automatic' | 'Manual' | 'Mixed';
export type RefreshInterval = 'Daily' | 'Weekly' | 'Custom';
export type RotationOption = 'TopN' | 'WeightedRandom';

export interface SpotlightSettings {
  id: string;
  slots: number;
  mode: SpotlightMode;
  scoreWeights: {
    sales: number;
    rating: number;
    fulfilment: number;
    returnRateInverse: number;
    responseTime: number;
  };
  eligibilityThresholds: {
    minOrders: number;
    minRating: number;
    minProducts: number;
  };
  refreshInterval: RefreshInterval;
  rotationOption: RotationOption;
  pinnedMerchants: string[]; // Merchant IDs
  exclusions: string[]; // Merchant IDs
}

export interface SpotlightHistoryLog {
  id: string;
  timestamp: string;
  actor: string;
  action: string;
  details: string;
}

export interface SpotlightMerchant {
  id: string;
  name: string;
  logoUrl?: string;
  bannerUrl?: string;
  location: string;
  rating: number;
  orderCount: number;
  topProducts: Product[];
}

export interface AnalyticsEvent {
  event: 'impression' | 'open' | 'click' | 'add_to_cart';
  merchantId: string;
  productId?: string;
  timestamp: string;
}
