import { useMutation, useQueryClient } from '@tanstack/react-query';
import { updateRewardRule, adjustRewardPoints } from './api';
import { rewardKeys } from './queries';
import type { RewardRule } from './types';

export function useUpdateRewardRule() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, updates }: { id: string; updates: Partial<RewardRule> }) => updateRewardRule(id, updates),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: rewardKeys.rules() });
    },
  });
}

export function useAdjustRewardPoints() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: adjustRewardPoints,
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: rewardKeys.ledger(variables.userId) });
      queryClient.invalidateQueries({ queryKey: rewardKeys.summary(variables.userId) });
    },
  });
}
