import type { RewardRule, RewardLedgerEntry, RewardSummary } from './types';
import { ApiError } from '@/lib/api';

const mockRules: RewardRule[] = [
  {
    id: 'rule-1',
    key: 'review_published',
    triggeringEvent: 'review.published',
    points: 50,
    needsVerifiedPurchase: true,
    active: true,
  },
  {
    id: 'rule-2',
    key: 'first_purchase',
    triggeringEvent: 'order.completed',
    points: 200,
    lifetimeCap: 200,
    needsVerifiedPurchase: true,
    active: false,
  },
  {
    id: 'rule-3',
    key: 'profile_completed',
    triggeringEvent: 'profile.completed',
    points: 100,
    lifetimeCap: 100,
    needsVerifiedPurchase: false,
    active: false,
  },
  {
    id: 'rule-4',
    key: 'referral_qualified',
    triggeringEvent: 'referral.qualified',
    points: 500,
    needsVerifiedPurchase: false,
    active: false,
  },
];

const mockLedger: RewardLedgerEntry[] = [
  {
    id: 'led-1',
    userId: 'user-1',
    type: 'earn',
    points: 50,
    sourceEvent: 'review.published',
    reference: 'REV-1001',
    balanceAfter: 50,
    status: 'available',
    createdAt: new Date(Date.now() - 86400000 * 10).toISOString(),
  },
  {
    id: 'led-2',
    userId: 'user-1',
    type: 'earn',
    points: 50,
    sourceEvent: 'review.published',
    reference: 'REV-1002',
    balanceAfter: 100,
    status: 'pending',
    createdAt: new Date(Date.now() - 86400000 * 2).toISOString(),
  },
  {
    id: 'led-3',
    userId: 'user-1',
    type: 'adjust',
    points: 100,
    sourceEvent: 'manual.adjustment',
    reference: 'Apology for delay',
    balanceAfter: 200,
    status: 'available',
    createdAt: new Date(Date.now() - 86400000 * 5).toISOString(),
  },
  {
    id: 'led-4',
    userId: 'user-1',
    type: 'reverse',
    points: -50,
    sourceEvent: 'review.removed',
    reference: 'REV-1001',
    balanceAfter: 150,
    status: 'available',
    createdAt: new Date().toISOString(),
  },
  {
    id: 'led-5',
    userId: 'user-2',
    type: 'earn',
    points: 500,
    sourceEvent: 'referral.qualified',
    reference: 'REF-2001',
    balanceAfter: 500,
    status: 'available',
    createdAt: new Date(Date.now() - 86400000 * 30).toISOString(),
  },
];

export async function getMockRewardRules(): Promise<RewardRule[]> {
  await new Promise((resolve) => setTimeout(resolve, 400));
  return [...mockRules];
}

export async function updateMockRewardRule(id: string, updates: Partial<RewardRule>): Promise<RewardRule> {
  await new Promise((resolve) => setTimeout(resolve, 400));
  const idx = mockRules.findIndex((r) => r.id === id);
  if (idx === -1) throw new ApiError(404, 'Rule not found');
  
  mockRules[idx] = { ...mockRules[idx], ...updates };
  return { ...mockRules[idx] };
}

export async function getMockRewardLedger(userId: string): Promise<{ data: RewardLedgerEntry[]; total: number }> {
  await new Promise((resolve) => setTimeout(resolve, 400));
  const data = mockLedger
    .filter((entry) => !userId || entry.userId === userId)
    .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  return { data, total: data.length };
}

export async function getMockRewardSummary(userId: string): Promise<RewardSummary> {
  await new Promise((resolve) => setTimeout(resolve, 400));
  const userEntries = mockLedger.filter((e) => e.userId === userId);
  
  const available = userEntries
    .filter((e) => e.status === 'available')
    .reduce((sum, e) => sum + e.points, 0);
    
  const pending = userEntries
    .filter((e) => e.status === 'pending')
    .reduce((sum, e) => sum + e.points, 0);
    
  const lifetime = userEntries
    .filter((e) => e.type === 'earn')
    .reduce((sum, e) => sum + e.points, 0);

  return { available, pending, lifetime };
}

export async function adjustMockRewardPoints(data: { userId: string; points: number; reason: string }): Promise<RewardLedgerEntry> {
  await new Promise((resolve) => setTimeout(resolve, 400));
  
  const userEntries = mockLedger.filter((e) => e.userId === data.userId);
  const currentBalance = userEntries
    .filter((e) => e.status === 'available')
    .reduce((sum, e) => sum + e.points, 0);
    
  const newBalance = currentBalance + data.points;
  if (newBalance < 0) {
    throw new ApiError(400, 'Balance cannot be negative');
  }

  const entry: RewardLedgerEntry = {
    id: `led-${Date.now()}`,
    userId: data.userId,
    type: 'adjust',
    points: data.points,
    sourceEvent: 'manual.adjustment',
    reference: data.reason,
    balanceAfter: newBalance,
    status: 'available',
    createdAt: new Date().toISOString(),
  };

  mockLedger.push(entry);
  return entry;
}
