'use client';

import React from 'react';
import Link from 'next/link';
import { Star, MapPin, Store } from 'lucide-react';
import { SpotlightMerchant } from '../types';
import { AmountText } from '@/components/patterns/AmountText';
import { AddToCartButton } from '@/components/storefront/AddToCartButton';

interface SpotlightCardProps {
  merchant: SpotlightMerchant;
  onHover?: () => void;
}

export function SpotlightCard({ merchant, onHover }: SpotlightCardProps) {
  return (
    <div 
      className="group relative bg-white rounded-xl border border-border shadow-sm hover:shadow-lg transition-all duration-300 overflow-hidden"
      onMouseEnter={onHover}
      onTouchStart={onHover} // tap for touch devices
    >
      <Link href={`/merchants/${merchant.id}`}>
        <div className="absolute top-2 left-2 z-20 bg-brand-600 text-white text-[10px] font-bold px-2 py-0.5 rounded shadow">
          FEATURED
        </div>
        
        {/* Banner */}
        <div className="h-32 bg-surface-2 relative overflow-hidden">
          {merchant.bannerUrl ? (
            <img src={merchant.bannerUrl} alt={`${merchant.name} banner`} className="object-cover w-full h-full group-hover:scale-105 transition-transform duration-700" />
          ) : (
            <div className="w-full h-full bg-gradient-to-r from-brand-700 to-brand-900 group-hover:scale-105 transition-transform duration-700"></div>
          )}
        </div>

        {/* Content */}
        <div className="p-4 pt-12 relative h-40">
          {/* Logo (overlap banner) */}
          <div className="absolute -top-8 left-4 w-16 h-16 bg-white rounded-full border-4 border-white shadow-sm overflow-hidden flex items-center justify-center">
            {merchant.logoUrl ? (
              <img src={merchant.logoUrl} alt={merchant.name} className="w-full h-full object-cover" />
            ) : (
              <Store className="w-6 h-6 text-brand-600" />
            )}
          </div>
          
          <h3 className="font-bold text-lg text-text line-clamp-1">{merchant.name}</h3>
          
          <div className="flex items-center gap-2 mt-1 text-sm text-text-muted">
            <MapPin className="w-3.5 h-3.5" />
            <span className="line-clamp-1">{merchant.location}</span>
          </div>
          
          <div className="flex items-center gap-3 mt-2">
            <div className="flex items-center gap-1">
              <Star className="w-4 h-4 text-warning-main fill-warning-main" />
              <span className="text-sm font-medium text-text">{merchant.rating}</span>
            </div>
            <div className="w-1 h-1 rounded-full bg-border"></div>
            <span className="text-xs text-text-muted">{merchant.orderCount}+ orders</span>
          </div>
        </div>
      </Link>
      
      {/* Quick Buy Panel (reveals on hover/focus-within) */}
      <div className="absolute inset-x-0 bottom-0 bg-white border-t border-border translate-y-full opacity-0 group-hover:translate-y-0 group-hover:opacity-100 group-focus-within:translate-y-0 group-focus-within:opacity-100 transition-all duration-300 ease-out p-3 shadow-[0_-8px_20px_-10px_rgba(0,0,0,0.1)]">
        <div className="mb-2 text-xs font-semibold text-text-muted">Top Products</div>
        <div className="flex gap-2 mb-3">
          {merchant.topProducts.map(product => (
            <div key={product.id} className="w-16 group/prod relative flex-shrink-0 cursor-pointer" onClick={() => window.location.href=`/products/${product.slug || product.id}`}>
              <div className="aspect-square bg-surface-1 rounded overflow-hidden mb-1 border border-border">
                {product.images?.[0] ? (
                  <img src={product.images[0]} alt={product.name} className="w-full h-full object-cover" />
                ) : (
                  <div className="w-full h-full flex items-center justify-center bg-brand-50 text-brand-500 text-[8px] font-medium">No Image</div>
                )}
              </div>
              <p className="text-[9px] font-bold text-text truncate"><AmountText amountInKobo={product.price} /></p>
              
              <div className="absolute inset-0 bg-black/60 opacity-0 group-hover/prod:opacity-100 transition-opacity flex items-center justify-center rounded">
                <div onClick={(e) => { e.preventDefault(); e.stopPropagation(); }}>
                  <AddToCartButton product={product} variant="icon" className="h-6 w-6 [&>svg]:w-3 [&>svg]:h-3" />
                </div>
              </div>
            </div>
          ))}
          {merchant.topProducts.length === 0 && (
            <div className="text-xs text-text-subtle py-2">No products available</div>
          )}
        </div>
        <Link href={`/merchants/${merchant.id}`} className="block w-full text-center py-1.5 text-xs font-medium text-brand-600 hover:text-brand-700 bg-brand-50 hover:bg-brand-100 rounded transition-colors">
          Visit Store
        </Link>
      </div>
    </div>
  );
}
