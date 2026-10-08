'use client';

import React, { useEffect } from 'react';
import { useStorefrontSpotlight } from '../queries';
import { SpotlightCard } from './SpotlightCard';
import { trackSpotlightEvent } from '../api';
import { Loader2 } from 'lucide-react';

export function SpotlightSection() {
  const { data: merchants, isLoading, error } = useStorefrontSpotlight();

  useEffect(() => {
    if (merchants && merchants.length > 0) {
      // Mock impression tracking
      merchants.forEach(m => trackSpotlightEvent({ event: 'impression', merchantId: m.id, timestamp: new Date().toISOString() }));
    }
  }, [merchants]);

  if (isLoading) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="h-6 w-48 bg-surface-2 animate-pulse rounded mb-8"></div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {[1, 2, 3, 4].map(i => (
            <div key={i} className="h-72 bg-surface-2 animate-pulse rounded-xl"></div>
          ))}
        </div>
      </div>
    );
  }

  if (error || !merchants || merchants.length === 0) {
    return null; // Hidden when empty or on error
  }

  return (
    <section className="bg-brand-50/30 border-y border-border overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-10">
          <div>
            <h2 className="text-3xl font-bold text-text mb-3">Merchant Spotlight</h2>
            <p className="text-text-muted max-w-2xl text-lg">
              Discover top-rated sellers providing exceptional service and quality products.
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 pb-4">
          {merchants.map(merchant => (
            <SpotlightCard 
              key={merchant.id} 
              merchant={merchant} 
              onHover={() => {
                trackSpotlightEvent({ event: 'open', merchantId: merchant.id, timestamp: new Date().toISOString() });
              }}
            />
          ))}
        </div>
      </div>
    </section>
  );
}
