'use client';

import Link from 'next/link';
import { useRewardSummary } from '../queries';
import { useAuthStore } from '@/features/auth/store';
import { Star } from 'lucide-react';

export function PointsChip() {
  const isAuthenticated = useAuthStore(state => state.isAuthenticated);
  // Using user-1 as mock since we're in mock mode and auth might not be fully hooked up with IDs
  const userId = 'user-1'; 
  const { data, isLoading } = useRewardSummary(userId);

  if (!isAuthenticated) return null;

  return (
    <Link 
      href="/portal/rewards" 
      className="flex items-center gap-1.5 px-3 py-1.5 bg-yellow-50 hover:bg-yellow-100 text-yellow-700 border border-yellow-200 rounded-full transition-colors font-medium text-sm"
    >
      <Star className="w-4 h-4 fill-yellow-500 text-yellow-500" />
      {isLoading ? '...' : (data?.available ?? 0)} pts
    </Link>
  );
}
