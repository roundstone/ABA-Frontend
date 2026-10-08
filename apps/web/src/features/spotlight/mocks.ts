import { SpotlightSettings, SpotlightHistoryLog } from './types';

export const mockSpotlightSettings: SpotlightSettings = {
  id: 'global-spotlight',
  slots: 4,
  mode: 'Automatic',
  scoreWeights: {
    sales: 40,
    rating: 30,
    fulfilment: 10,
    returnRateInverse: 10,
    responseTime: 10,
  },
  eligibilityThresholds: {
    minOrders: 10,
    minRating: 4.0,
    minProducts: 5,
  },
  refreshInterval: 'Weekly',
  rotationOption: 'TopN',
  pinnedMerchants: [],
  exclusions: [],
};

export const mockSpotlightHistory: SpotlightHistoryLog[] = [
  {
    id: 'l1',
    timestamp: new Date(Date.now() - 86400000 * 2).toISOString(),
    actor: 'System',
    action: 'Auto-Refresh',
    details: 'Rotated 4 merchants based on performance scores.',
  }
];
