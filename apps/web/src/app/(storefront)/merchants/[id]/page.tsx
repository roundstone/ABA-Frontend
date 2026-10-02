'use client';

import React from 'react';
import Link from 'next/link';
import { Store, Star, MapPin, Phone, Mail, Search, MessageSquare, Loader2, Globe } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useQuery } from '@tanstack/react-query';
import { getMerchantById } from '@/features/merchant/api';
import { getShopProducts } from '@/features/shop/api';
import { ProductCard } from '@/components/storefront/ProductCard';
import { ErrorState } from '@/components/patterns/ErrorState';

export default function MerchantProfilePage({ params }: { params: Promise<{ id: string }> }) {
  const unwrappedParams = React.use(params);
  const merchantId = unwrappedParams.id; // Could be slug or id

  const { data: merchant, isLoading: isMerchantLoading, error: merchantError } = useQuery({
    queryKey: ['merchant', merchantId],
    queryFn: async () => {
      // API currently uses slug, so we pass ID as slug, or mock treats them interchangeably if set up right.
      const res = await getMerchantById(merchantId);
      return res.data;
    }
  });

  const { data: products, isLoading: isProductsLoading } = useQuery({
    queryKey: ['merchant_products', merchantId],
    queryFn: async () => {
      // Mock logic in shop API uses merchant.id, we'll try it
      const res = await getShopProducts({ merchantId: merchant?.id || merchantId });
      return res.data;
    },
    enabled: !!merchant // Only fetch when merchant is loaded
  });

  if (isMerchantLoading) {
    return (
      <div className="flex justify-center items-center min-h-[60vh]">
        <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
      </div>
    );
  }

  if (merchantError || !merchant) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8">
        <ErrorState
          title={merchantError?.message || 'Merchant not found'}
          description="We couldn't load the requested merchant details. Please try again."
        />
      </div>
    );
  }

  return (
    <div className="bg-surface-1 min-h-screen pb-16 -mt-4">
      {/* Store Header Banner */}
      <div className="bg-brand-700 h-48 md:h-64 relative">
        {merchant.bannerImage ? (
          <img src={merchant.bannerImage} alt="Banner" className="absolute inset-0 w-full h-full object-cover mix-blend-overlay" />
        ) : (
          <div className="absolute inset-0 bg-linear-to-t from-black/60 to-transparent"></div>
        )}
        {merchant.bannerImage ?? "nO"}
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-full flex items-end pb-8 relative z-10">
          <div className="flex flex-col md:flex-row md:items-end gap-6 w-full">
            <div className="w-24 h-24 md:w-32 md:h-32 bg-white rounded-xl border-4 border-white shadow-lg flex items-center justify-center shrink-0 overflow-hidden">
              {merchant.logoUrl ? (
                <img src={merchant.logoUrl} alt={merchant.name} className="w-full h-full object-cover" />
              ) : (
                <Store className="w-12 h-12 text-brand-300" />
              )}
            </div>
            <div className="flex-1 text-white pb-2">
              <h1 className="text-3xl md:text-4xl font-bold mb-2">{merchant.name}</h1>
              <div className="flex flex-wrap items-center gap-4 text-sm md:text-base text-brand-50">
                <span className="flex items-center gap-1"><MapPin className="w-4 h-4" /> {merchant.address || 'Lagos, Nigeria'}</span>
                <span className="flex items-center gap-1">
                  <Star className="w-4 h-4 text-warning-main fill-warning-main" /> {merchant.rating} ({merchant.reviewCount} Reviews)
                </span>
                {merchant.isVerified && (
                  <span className="bg-white/20 px-2 py-0.5 rounded font-medium text-xs uppercase tracking-wide">Verified Merchant</span>
                )}
              </div>
            </div>
            <div className="flex gap-3 pb-2 hidden sm:flex">
              <Button className="bg-white text-brand-700 hover:bg-brand-50">Follow Store</Button>
              <Button variant="outline" className="text-white border-white hover:bg-white/10"><MessageSquare className="w-4 h-4 mr-2" /> Message</Button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">

          {/* Sidebar / Info */}
          <div className="lg:col-span-1 space-y-6">
            <div className="bg-white rounded-xl border border-border p-6 shadow-sm">
              <h3 className="font-semibold text-text mb-4">About the Store</h3>
              <p className="text-sm text-text-muted mb-4 leading-relaxed">
                {merchant.description}
              </p>

              <div className="space-y-3 text-sm text-text-muted">
                <div className="flex items-center gap-2">
                  <Mail className="w-4 h-4 text-brand-600" />
                  <span>{merchant.email}</span>
                </div>
                <div className="flex items-center gap-2">
                  <Phone className="w-4 h-4 text-brand-600" />
                  <span>{merchant.phone}</span>
                </div>
                <div className="flex items-center gap-2">
                  <MapPin className="w-4 h-4 text-brand-600" />
                  <span>{merchant.address}</span>
                </div>
                {/* website if exit */}
                {merchant.website && (
                  <div className="flex items-center gap-2">
                    <Link
                      href={merchant.website}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center gap-2 text-brand-600 hover:underline"
                    >
                      <Globe className="w-4 h-4" />
                      <span>{merchant.website}</span>
                    </Link>
                  </div>
                )}
              </div>
            </div>

            <div className="bg-white rounded-xl border border-border p-6 shadow-sm">
              <h3 className="font-semibold text-text mb-4">Store Stats</h3>
              <ul className="space-y-2 text-sm">
                <li className="flex justify-between text-text"><span>Products</span> <span className="font-medium">{products?.length || 0}</span></li>
                <li className="flex justify-between text-text"><span>Joined</span> <span className="font-medium">{merchant.onboardedAt ? new Date(merchant.onboardedAt).getFullYear() : 'N/A'}</span></li>
              </ul>
            </div>
          </div>

          {/* Main Products Area */}
          <div className="lg:col-span-3">
            {/* Store Toolbar */}
            <div className="bg-white rounded-xl border border-border p-4 mb-6 shadow-sm flex flex-col sm:flex-row justify-between items-center gap-4">
              <div className="relative w-full sm:w-72">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
                <input
                  type="text"
                  placeholder="Search in store..."
                  className="w-full h-10 pl-9 pr-4 rounded-md border border-border text-sm focus:ring-2 focus:ring-brand-500 outline-none"
                />
              </div>
              <div className="flex items-center gap-2 w-full sm:w-auto">
                <span className="text-sm text-text-muted whitespace-nowrap">Sort by:</span>
                <select className="h-10 w-full sm:w-auto px-3 py-1 rounded-md border border-border bg-white text-sm focus:outline-none">
                  <option>Recommended</option>
                  <option>New Arrivals</option>
                  <option>Price: Low to High</option>
                </select>
              </div>
            </div>

            {/* Products Grid */}
            {isProductsLoading ? (
              <div className="flex justify-center py-12"><Loader2 className="w-8 h-8 animate-spin text-brand-600" /></div>
            ) : (
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4 md:gap-6">
                {products?.map(product => (
                  <ProductCard key={product.id} product={product} />
                ))}

                {(!products || products.length === 0) && (
                  <div className="col-span-full py-12 text-center text-text-muted border-2 border-dashed border-border rounded-xl">
                    This merchant hasn't listed any products yet.
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
