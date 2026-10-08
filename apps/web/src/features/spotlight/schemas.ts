import { z } from 'zod';

export const spotlightSettingsSchema = z.object({
  slots: z.number().min(1).max(20),
  mode: z.enum(['Automatic', 'Manual', 'Mixed']),
  scoreWeights: z.object({
    sales: z.number().min(0).max(100),
    rating: z.number().min(0).max(100),
    fulfilment: z.number().min(0).max(100),
    returnRateInverse: z.number().min(0).max(100),
    responseTime: z.number().min(0).max(100),
  }),
  eligibilityThresholds: z.object({
    minOrders: z.number().min(0),
    minRating: z.number().min(0).max(5),
    minProducts: z.number().min(0),
  }),
  refreshInterval: z.enum(['Daily', 'Weekly', 'Custom']),
  rotationOption: z.enum(['TopN', 'WeightedRandom']),
  pinnedMerchants: z.array(z.string()),
  exclusions: z.array(z.string()),
});

export type SpotlightSettingsFormData = z.infer<typeof spotlightSettingsSchema>;
