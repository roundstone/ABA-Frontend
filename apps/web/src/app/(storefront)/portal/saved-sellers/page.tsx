'use client';

import React from 'react';
import Link from 'next/link';
import { Store, Star, MapPin, Loader2, HeartCrack } from 'lucide-react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getSavedSellers, unsaveSeller } from '@/features/merchant/api';
import { Button } from '@/components/ui/button';
import { toast } from 'sonner';

export default function SavedSellersPage() {
  const queryClient = useQueryClient();

  const { data: savedSellers, isLoading, error } = useQuery({
    queryKey: ['saved_sellers'],
    queryFn: async () => {
      const res = await getSavedSellers();
      return res.data;
    }
  });

  const { mutate: removeSeller } = useMutation({
    mutationFn: (merchantId: string) => unsaveSeller(merchantId),
    onSuccess: (_, merchantId) => {
      toast.success('Removed from saved sellers');
      queryClient.invalidateQueries({ queryKey: ['saved_sellers'] });
      queryClient.invalidateQueries({ queryKey: ['merchant', merchantId] });
    },
    onError: () => {
      toast.error('Failed to remove seller');
    }
  });

  return (
    <div className="max-w-5xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-text">Saved Sellers</h1>
          <p className="text-sm text-text-muted mt-1">Keep track of your favorite stores and merchants.</p>
        </div>
      </div>

      {isLoading ? (
        <div className="flex justify-center py-20">
          <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
        </div>
      ) : error ? (
        <div className="bg-error/10 border border-error text-error p-4 rounded-lg">
          Failed to load saved sellers. Please try again later.
        </div>
      ) : savedSellers && savedSellers.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {savedSellers.map(seller => (
            <div key={seller.id} className="bg-white rounded-xl border border-border p-4 shadow-sm flex flex-col h-full hover:shadow-md transition-shadow">
              <div className="flex items-start gap-4 mb-4">
                <div className="w-16 h-16 rounded-full border border-border overflow-hidden bg-surface-1 shrink-0 flex items-center justify-center">
                  {seller.logoUrl ? (
                    <img src={seller.logoUrl} alt={seller.name} className="w-full h-full object-cover" />
                  ) : (
                    <Store className="w-8 h-8 text-text-muted" />
                  )}
                </div>
                <div className="flex-1 min-w-0">
                  <Link href={`/merchants/${seller.id}`} className="font-semibold text-text hover:text-brand-600 truncate block">
                    {seller.name}
                  </Link>
                  <div className="flex items-center gap-1 text-xs text-text-muted mt-1">
                    <MapPin className="w-3 h-3" /> <span className="truncate">{seller.location}</span>
                  </div>
                  <div className="flex items-center gap-1 text-xs text-text-muted mt-1">
                    <Star className="w-3 h-3 text-warning-main fill-warning-main" /> {seller.rating}
                  </div>
                </div>
              </div>
              <p className="text-sm text-text-muted line-clamp-2 mb-4 flex-1">
                {seller.description}
              </p>
              <div className="flex items-center gap-2 mt-auto">
                <Button variant="primary" className="flex-1 bg-brand-600 hover:bg-brand-700">
                  <Link href={`/merchants/${seller.id}`}>Visit Store</Link>
                </Button>
                <Button 
                  variant="outline" 
                  size="icon"
                  className="text-error hover:text-error hover:bg-error/10 border-border"
                  onClick={() => removeSeller(seller.id)}
                  title="Remove from saved"
                >
                  <HeartCrack className="w-4 h-4" />
                </Button>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="text-center py-20 bg-white rounded-xl border border-border border-dashed">
          <Store className="w-12 h-12 text-text-muted mx-auto mb-4" />
          <h3 className="text-lg font-medium text-text mb-2">No saved sellers yet</h3>
          <p className="text-sm text-text-muted mb-6">When you follow stores, they will appear here.</p>
          <Button asChild variant="outline">
            <Link href="/shop">Discover Stores</Link>
          </Button>
        </div>
      )}
    </div>
  );
}
