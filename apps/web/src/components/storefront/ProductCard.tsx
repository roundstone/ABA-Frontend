'use client';

import React from 'react';
import Link from 'next/link';
import { Star } from 'lucide-react';
import { AmountText } from '@/components/patterns/AmountText';
import { AddToCartButton } from '@/components/storefront/AddToCartButton';
import { Product } from '@/features/products/types';

interface ProductCardProps {
  product: Product;
}

export function ProductCard({ product }: ProductCardProps) {
  const merchantName = product.merchant?.name || 'Aba Merchant';
  const price = product.price ?? 0;

  return (
    <Link href={`/products/${product.slug || product.id}`} className="bg-white rounded-xl border border-border overflow-hidden hover:shadow-lg transition-shadow group flex flex-col h-full">
      <div className="aspect-square bg-surface-2 relative overflow-hidden flex items-center justify-center group-hover:bg-surface-1 transition-colors duration-500">
        {(product.images && product.images.length > 0) ? (
          <img src={product.images[0]} alt={product.name} className="object-cover w-full h-full group-hover:scale-105 transition-transform" />
        ) : (
          <span className="text-brand-600 font-bold opacity-30">Image</span>
        )}
        {product.originalPrice && product.originalPrice > price && (
          <div className="absolute top-2 right-2 px-2 py-1 bg-error text-white text-[10px] font-bold rounded shadow-sm z-10">
            -{Math.round((1 - price / product.originalPrice) * 100)}%
          </div>
        )}
      </div>
      <div className="p-4 flex flex-col flex-1">
        <p className="text-xs text-text-muted mb-1">{merchantName}</p>
        <h3 className="font-medium text-text mb-2 line-clamp-2 group-hover:text-brand-600 transition-colors">{product.name}</h3>
        <div className="flex items-center gap-1 mb-3">
          <Star className="w-4 h-4 text-warning-main fill-warning-main" />
          <span className="text-sm font-medium">{product.rating || '4.0'}</span>
          <span className="text-xs text-text-muted">({product.reviewCount || '0'})</span>
        </div>
        <div className="mt-auto flex justify-between items-end">
          <div>
            {product.originalPrice && product.originalPrice > price ? (
              <>
                <p className="text-xs text-text-subtle line-through"><AmountText amountInKobo={product.originalPrice} /></p>
                <p className="text-lg font-bold text-text"><AmountText amountInKobo={price} /></p>
              </>
            ) : (
              <p className="text-lg font-bold text-text"><AmountText amountInKobo={price} /></p>
            )}
          </div>
          <div onClick={(e) => {
            // Prevents the Link navigation when clicking the add to cart button
            e.preventDefault();
            e.stopPropagation();
          }}>
            <AddToCartButton product={product} variant="icon" className="relative z-10" />
          </div>
        </div>
      </div>
    </Link>
  );
}
