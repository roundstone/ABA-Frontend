'use client';

import React from 'react';
import { Product } from '@/features/products/types';
import { ProductCard } from '@/components/storefront/ProductCard';

interface RelatedProductsRailProps {
  title: string;
  products: Product[];
}

export function RelatedProductsRail({ title, products }: RelatedProductsRailProps) {
  if (!products || products.length === 0) return null;

  return (
    <section className="mt-16">
      <h2 className="text-2xl font-bold text-text mb-6">{title}</h2>
      <div className="flex overflow-x-auto gap-4 lg:gap-6 pb-4 snap-x hide-scrollbar">
        {products.map((product) => (
          <div key={product.id} className="min-w-[240px] md:min-w-[280px] lg:w-[calc(20%)] lg:min-w-0 snap-start shrink-0">
            <ProductCard product={product} />
          </div>
        ))}
      </div>
    </section>
  );
}
