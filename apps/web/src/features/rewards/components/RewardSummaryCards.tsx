'use client';

import { useRewardSummary } from '../queries';
import { KpiCard } from '@/components/patterns/KpiCard';

export function RewardSummaryCards({ userId }: { userId: string }) {
  const { data, isLoading } = useRewardSummary(userId);

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
      <KpiCard
        title="Available Points"
        value={isLoading ? '...' : (data?.available ?? 0)}
      />
      <KpiCard
        title="Pending Points"
        value={isLoading ? '...' : (data?.pending ?? 0)}
      />
      <KpiCard
        title="Lifetime Points"
        value={isLoading ? '...' : (data?.lifetime ?? 0)}
      />
    </div>
  );
}
