'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getMerchantPromotionAnalytics } from '../api';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { Loader2 } from 'lucide-react';

export function MerchantPromotionsReport({ merchantId }: { merchantId: string }) {
  const { data, isLoading } = useQuery({
    queryKey: ['promotionAnalytics', merchantId],
    queryFn: () => getMerchantPromotionAnalytics(merchantId)
  });

  if (isLoading) return <div className="flex justify-center p-12"><Loader2 className="w-8 h-8 animate-spin text-brand-600" /></div>;
  if (!data?.data) return <div>No data available</div>;

  const stats = data.data;

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <KpiCard title="Impressions" value={stats.totalImpressions.toLocaleString()} />
      <KpiCard title="Clicks" value={stats.totalClicks.toLocaleString()} />
      <KpiCard title="Click-Through Rate" value={`${stats.ctr.toFixed(2)}%`} />
      <KpiCard title="Add to Cart" value={stats.totalAddToCart.toLocaleString()} />
      <KpiCard title="Attributed Orders" value={stats.totalOrders.toLocaleString()} />
      <KpiCard title="Total Spend" value={<AmountText amountInKobo={stats.totalSpendInKobo} />} />
    </div>
  );
}
