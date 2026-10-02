'use client';

import React from 'react';
import Link from 'next/link';
import { Store, Star, MapPin, Search, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useQuery } from '@tanstack/react-query';
import { getShopMerchants } from '@/features/shop/api';
import { Alert } from '@/components/ui/alert';
import { ErrorState } from '@/components/patterns/ErrorState';
import Image from 'next/image';

export default function MerchantDirectoryPage() {
  const { data: merchants, isLoading, error } = useQuery({
    queryKey: ['merchants'],
    queryFn: async () => {
      const res = await getShopMerchants();
      return res.data;
    }
  });

  return (
    <div className="bg-surface-1 min-h-screen -mt-4">
      {/* Header Banner */}
      <div className="bg-brand-600 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-3xl md:text-5xl font-bold mb-4">Discover Top Merchants</h1>
          <p className="text-lg text-brand-100 max-w-2xl mx-auto mb-8">
            Shop directly from verified vendors on the ABA Marketplace. Quality products, trusted sellers.
          </p>

          <div className="max-w-xl mx-auto relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-text-muted" />
            <input
              type="text"
              placeholder="Search for a store or merchant..."
              className="w-full h-12 pl-12 pr-4 rounded-full border-2 border-white/30 focus:ring-2 focus:ring-brand-300 shadow-lg"
            />
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {/* Filter Bar */}
        <div className="flex flex-col sm:flex-row justify-between items-center mb-8 gap-4">
          <div className="flex gap-2 overflow-x-auto w-full sm:w-auto pb-2 sm:pb-0">
            <Button variant="outline" className="rounded-full bg-brand-50 border-brand-200 text-brand-700">All Stores</Button>
            <Button variant="outline" className="rounded-full bg-white border-border text-text-muted">Electronics</Button>
            <Button variant="outline" className="rounded-full bg-white border-border text-text-muted">Fashion</Button>
            <Button variant="outline" className="rounded-full bg-white border-border text-text-muted">Groceries</Button>
          </div>
          <select className="h-10 px-4 rounded-full border border-border bg-white text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 shrink-0">
            <option>Sort: Top Rated</option>
            <option>Sort: Newest</option>
            <option>Sort: A-Z</option>
          </select>
        </div>

        {/* State Handling */}
        {isLoading && (
          <div className="flex justify-center items-center py-20">
            <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
          </div>
        )}

        {error && (
          <ErrorState
            title={error?.message || "Failed to load merchants."}
            description="Please try again later."
          />
        )}

        {/* Merchant Grid */}
        {!isLoading && !error && merchants && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {merchants.map(merchant => (
              <Link href={`/merchants/${merchant.id}`} key={merchant.id} className="bg-white rounded-xl border border-border overflow-hidden hover:shadow-lg transition-all group flex flex-col">
                <div className="h-24 bg-brand-100 relative">
                  {merchant.bannerImage && (
                    <>
                      <img src={merchant.bannerImage} alt={`${merchant.name} banner`} className="absolute inset-0 w-full h-full object-cover opacity-50" />
                      <div className="absolute inset-0 bg-black/40" />
                    </>
                  )}
                  {/* Cover Image Placeholder */}
                  <div className="absolute -bottom-8 left-6 w-16 h-16 bg-white rounded-lg border border-border shadow-sm flex items-center justify-center overflow-hidden z-10">
                    {merchant.logoUrl ? (
                      <img src={merchant.logoUrl} alt={merchant.name} className="w-full h-full object-cover relative z-10" />
                    ) : (
                      <Store className="w-8 h-8 text-brand-300 relative z-10" />
                    )}
                  </div>
                </div>
                <div className="pt-10 px-6 pb-6 flex flex-col flex-1">
                  <h3 className="font-bold text-lg text-text group-hover:text-brand-600 transition-colors">{merchant.name}</h3>
                  <p className="text-sm text-text-muted mt-1 mb-4 line-clamp-2">
                    {merchant.description || 'Verified seller on the ABA Marketplace.'}
                  </p>

                  <div className="flex items-center gap-1 mb-2">
                    <Star className="w-4 h-4 text-warning-main fill-warning-main" />
                    <span className="text-sm font-medium">{merchant.rating}</span>
                  </div>

                  <div className="mt-auto pt-4 border-t border-border flex justify-between items-center">
                    <span className="text-sm font-medium text-brand-600 group-hover:underline">Visit Store &rarr;</span>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
