import { useQuery } from '@tanstack/react-query';
import { getRewardRules, getRewardLedger, getRewardSummary } from './api';

export const rewardKeys = {
  all: ['rewards'] as const,
  rules: () => [...rewardKeys.all, 'rules'] as const,
  ledger: (userId: string) => [...rewardKeys.all, 'ledger', userId] as const,
  summary: (userId: string) => [...rewardKeys.all, 'summary', userId] as const,
};

export function useRewardRules() {
  return useQuery({
    queryKey: rewardKeys.rules(),
    queryFn: getRewardRules,
  });
}

export function useRewardLedger(userId: string) {
  return useQuery({
    queryKey: rewardKeys.ledger(userId),
    queryFn: () => getRewardLedger(userId),
    enabled: !!userId,
  });
}

export function useRewardSummary(userId: string) {
  return useQuery({
    queryKey: rewardKeys.summary(userId),
    queryFn: () => getRewardSummary(userId),
    enabled: !!userId,
  });
}
