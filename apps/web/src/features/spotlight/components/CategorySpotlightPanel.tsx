'use client';

import React from 'react';
import { useCategorySpotlight } from '../queries';
import Link from 'next/link';
import { Star, Store } from 'lucide-react';
import { trackSpotlightEvent } from '../api';

interface CategorySpotlightPanelProps {
  categorySlug: string;
  categoryName: string;
  onClose: () => void;
}

export function CategorySpotlightPanel({ categorySlug, categoryName, onClose }: CategorySpotlightPanelProps) {
  const { data: merchants, isLoading } = useCategorySpotlight(categorySlug);

  React.useEffect(() => {
    if (merchants && merchants.length > 0) {
      merchants.forEach(m => trackSpotlightEvent({ event: 'impression', merchantId: m.id, timestamp: new Date().toISOString() }));
    }
  }, [merchants]);

  if (isLoading || !merchants || merchants.length === 0) {
    return (
      <div className="flex-1 min-h-[260px] rounded-2xl bg-gradient-to-br from-brand-600 to-brand-800 p-8 flex items-center justify-between relative overflow-hidden">
        <div className="relative z-10 max-w-xs flex flex-col gap-3">
          <h3 className="text-3xl font-bold text-white">{categoryName}</h3>
          <p className="text-lg text-white/90">Shop trusted Nigerian sellers, always with you.</p>
          <Link
            href={`/c/${categorySlug}`}
            onClick={onClose}
            className="mt-8 self-start rounded-full border border-white px-6 py-2.5 text-sm font-semibold text-white hover:bg-white hover:text-brand-700 transition-colors"
          >
            Explore now
          </Link>
        </div>
        <div aria-hidden="true" className="hidden xl:block absolute -right-10 -top-10 h-72 w-72 rounded-3xl bg-white/15 rotate-12" />
        <div aria-hidden="true" className="hidden xl:block absolute right-24 -bottom-16 h-56 w-56 rounded-3xl bg-white/10 -rotate-12" />
      </div>
    );
  }

  return (
    <div className="flex-1 min-h-[260px] rounded-2xl bg-surface-1 p-6 flex flex-col relative overflow-hidden border border-border">
      <div className="flex justify-between items-center mb-4">
        <h3 className="text-sm font-bold text-text">Featured in {categoryName}</h3>
        <Link href={`/c/${categorySlug}`} onClick={onClose} className="text-xs font-semibold text-brand-600 hover:underline">
          View all
        </Link>
      </div>
      
      <div className="grid grid-cols-2 gap-4 h-full">
        {merchants.map(merchant => (
          <Link 
            key={merchant.id} 
            href={`/merchants/${merchant.id}`}
            onClick={() => {
              trackSpotlightEvent({ event: 'click', merchantId: merchant.id, timestamp: new Date().toISOString() });
              onClose();
            }}
            className="flex flex-col bg-white p-3 rounded-xl border border-border hover:border-brand-300 hover:shadow-sm transition-all group"
          >
            <div className="flex items-center gap-3 mb-2">
              <div className="w-10 h-10 rounded-full bg-surface-2 flex items-center justify-center overflow-hidden shrink-0">
                {merchant.logoUrl ? (
                  <img src={merchant.logoUrl} alt={merchant.name} className="w-full h-full object-cover" />
                ) : (
                  <Store className="w-4 h-4 text-text-muted" />
                )}
              </div>
              <div>
                <p className="text-sm font-semibold text-text line-clamp-1 group-hover:text-brand-600">{merchant.name}</p>
                <div className="flex items-center gap-1">
                  <Star className="w-3 h-3 text-warning-main fill-warning-main" />
                  <span className="text-xs font-medium text-text">{merchant.rating}</span>
                </div>
              </div>
            </div>
            
            <div className="flex gap-1 mt-auto">
              {merchant.topProducts.slice(0, 3).map((p, i) => (
                <div key={p.id} className="w-1/3 aspect-square bg-surface-2 rounded overflow-hidden">
                  {p.images?.[0] && <img src={p.images[0]} alt="" className="w-full h-full object-cover" />}
                </div>
              ))}
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
