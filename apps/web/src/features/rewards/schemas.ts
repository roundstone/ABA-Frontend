import { z } from 'zod';

export const rewardRuleSchema = z.object({
  id: z.string(),
  key: z.string(),
  triggeringEvent: z.string(),
  points: z.number().int().nonnegative(),
  dailyCap: z.number().int().nonnegative().optional(),
  lifetimeCap: z.number().int().nonnegative().optional(),
  needsVerifiedPurchase: z.boolean(),
  active: z.boolean(),
});

export const rewardLedgerEntrySchema = z.object({
  id: z.string(),
  userId: z.string(),
  type: z.enum(['earn', 'redeem', 'adjust', 'expire', 'reverse']),
  points: z.number().int(),
  sourceEvent: z.string().optional(),
  reference: z.string().optional(),
  balanceAfter: z.number().int().nonnegative(),
  status: z.enum(['pending', 'available']),
  optionalExpiry: z.string().datetime().optional(),
  createdAt: z.string().datetime(),
});

export const rewardSummarySchema = z.object({
  available: z.number().int().nonnegative(),
  pending: z.number().int().nonnegative(),
  lifetime: z.number().int().nonnegative(),
});
