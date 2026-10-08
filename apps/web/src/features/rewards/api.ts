import { fetchApi } from '@/lib/api';
import type { RewardRule, RewardLedgerEntry, RewardSummary } from './types';
import { getMockRewardRules, getMockRewardLedger, getMockRewardSummary, updateMockRewardRule, adjustMockRewardPoints } from './mocks';
import { API_MODE } from '@/lib/api';

export async function getRewardRules(): Promise<RewardRule[]> {
  if (API_MODE === 'mock') {
    return getMockRewardRules();
  }
  return fetchApi<RewardRule[]>('/api/rewards/rules');
}

export async function updateRewardRule(id: string, updates: Partial<RewardRule>): Promise<RewardRule> {
  if (API_MODE === 'mock') {
    return updateMockRewardRule(id, updates);
  }
  return fetchApi<RewardRule>(`/api/rewards/rules/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(updates),
  });
}

export async function getRewardLedger(userId: string): Promise<{ data: RewardLedgerEntry[]; total: number }> {
  if (API_MODE === 'mock') {
    return getMockRewardLedger(userId);
  }
  return fetchApi<{ data: RewardLedgerEntry[]; total: number }>(`/api/rewards/ledger?userId=${userId}`);
}

export async function getRewardSummary(userId: string): Promise<RewardSummary> {
  if (API_MODE === 'mock') {
    return getMockRewardSummary(userId);
  }
  return fetchApi<RewardSummary>(`/api/rewards/summary?userId=${userId}`);
}

export async function adjustRewardPoints(data: { userId: string; points: number; reason: string }): Promise<RewardLedgerEntry> {
  if (API_MODE === 'mock') {
    return adjustMockRewardPoints(data);
  }
  return fetchApi<RewardLedgerEntry>('/api/rewards/adjust', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
}
