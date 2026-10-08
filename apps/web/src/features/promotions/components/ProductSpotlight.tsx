'use client';

import React from 'react';
import { ProductCard } from '@/components/storefront/ProductCard';
import { Button } from '@/components/ui/button';
import { mockShopProducts } from '@/features/shop/mocks';
// import { mockProducts } from '@/features/products/mocks';

// In a real implementation, this would fetch from the active promotions API
export function ProductSpotlight() {
  // Let's just mock 4 sponsored products from the standard catalog for the spotlight
  const sponsoredProducts = mockShopProducts.slice(0, 4);

  if (!sponsoredProducts || sponsoredProducts.length === 0) {
    return null;
  }

  return (
    <section className="py-12 bg-surface">
      <div className="container mx-auto">
        <div className="flex flex-col md:flex-row items-center justify-between mb-8">
          <div>
            <h2 className="text-2xl font-bold text-text">Featured Products</h2>
            <p className="text-text-muted mt-1">Discover top picks sponsored by our merchants</p>
          </div>
          <Button variant="outline" className="hidden md:flex">
            View All Promoted
          </Button>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
          {sponsoredProducts.map(product => (
            <ProductCard 
              key={product.id} 
              product={product} 
              isSponsored={true} 
            />
          ))}
        </div>
        
        <div className="mt-8 text-center md:hidden">
          <Button variant="outline" className="w-full">
            View All Promoted
          </Button>
        </div>
      </div>
    </section>
  );
}
