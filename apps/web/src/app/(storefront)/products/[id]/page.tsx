'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { Star, Heart, Share2, ShieldCheck, Truck, Store, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useQuery } from '@tanstack/react-query';
import { getProductDetailBySlug } from '@/features/product/api';
import { AmountText } from '@/components/patterns/AmountText';
import { Alert } from '@/components/ui/alert';
import { ErrorState } from '@/components/patterns/ErrorState';
import { AddToCartButton } from '@/components/storefront/AddToCartButton';

export default function ProductDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const unwrappedParams = React.use(params);
  const [quantity, setQuantity] = useState(1);

  const { data: product, isLoading, error } = useQuery({
    queryKey: ['product_detail', unwrappedParams.id],
    queryFn: async () => {
      const res = await getProductDetailBySlug(unwrappedParams.id);
      return res.data;
    }
  });

  if (isLoading) {
    return (
      <div className="flex justify-center items-center min-h-[60vh]">
        <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
      </div>
    );
  }

  if (error || !product) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8">
        <ErrorState
          title={error?.message || 'Product not found'}
          description="We couldn't load the requested product details. Please try again."
        />
      </div>
    );
  }



  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Breadcrumbs */}
      <nav className="text-sm text-text-muted mb-6">
        <Link href="/" className="hover:text-brand-600">Home</Link>
        <span className="mx-2">&rsaquo;</span>
        <Link href="/shop" className="hover:text-brand-600">{product.categoryName}</Link>
        <span className="mx-2">&rsaquo;</span>
        <span className="text-text line-clamp-1 max-w-sm inline-block align-bottom">{product.name}</span>
      </nav>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
        {/* Left: Gallery */}
        <div className="flex flex-col gap-4">
          <div className="aspect-square bg-surface-2 rounded-2xl border border-border overflow-hidden flex items-center justify-center relative">
            {product.image ? (
              <img src={product.image} alt={product.name} className="object-cover w-full h-full" />
            ) : (
              <span className="text-brand-600 font-bold opacity-30 text-2xl">Image</span>
            )}
          </div>
          {product.images && product.images.length > 1 && (
            <div className="grid grid-cols-4 gap-4">
              {product.images.slice(0, 4).map((url, i) => (
                <div key={i} className={`aspect-square bg-surface-2 rounded-lg border ${i === 0 ? 'border-brand-500' : 'border-border'} flex items-center justify-center cursor-pointer hover:border-brand-300 overflow-hidden`}>
                  <img src={url} alt={`Thumb ${i + 1}`} className="object-cover w-full h-full" />
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Right: Details */}
        <div className="flex flex-col">
          <div className="mb-6 border-b border-border pb-6">
            <Link href={`/merchants/${product.merchantId}`} className="text-sm font-medium text-brand-600 hover:underline mb-2 inline-flex items-center gap-1">
              <Store className="w-4 h-4" /> {product.merchantName}
            </Link>
            <h1 className="text-3xl sm:text-4xl font-bold text-text tracking-tight mb-4">{product.name}</h1>

            <div className="flex flex-wrap items-center gap-4 mb-4">
              <div className="flex items-center gap-1">
                <Star className="w-5 h-5 text-warning-main fill-warning-main" />
                <span className="text-sm font-medium ml-1">{product.rating}</span>
                <span className="text-sm text-text-muted underline ml-1">({product.reviewCount} Reviews)</span>
              </div>
              <span className={`text-sm px-2 py-1 rounded font-medium ${product.inStock || product.stockQuantity > 0 ? 'text-success-dark bg-success-bg' : 'text-error-dark bg-error/10'}`}>
                {product.inStock || product.stockQuantity > 0 ? `In Stock ${product.stockQuantity ? `(${product.stockQuantity} left)` : ''}` : 'Out of Stock'}
              </span>
            </div>

            <div className="flex items-end gap-3 mb-2">
              <span className="text-3xl font-bold text-text"><AmountText amountInKobo={product.price} /></span>
              {product.originalPrice && product.originalPrice > product.price && (
                <>
                  <span className="text-lg text-text-subtle line-through mb-1"><AmountText amountInKobo={product.originalPrice} /></span>
                  <span className="text-sm font-bold text-error bg-error/10 px-2 py-1 rounded mb-1">
                    -{Math.round((1 - product.price / product.originalPrice) * 100)}%
                  </span>
                </>
              )}
            </div>
            <p className="text-sm text-text-muted">Prices include VAT. Delivery calculated at checkout.</p>
          </div>

          {/* Attributes */}
          {product.attributes && product.attributes.length > 0 && (
            <div className="mb-6 space-y-2">
              <h3 className="text-sm font-semibold text-text mb-2">Specifications</h3>
              <div className="grid grid-cols-2 gap-2 text-sm">
                {product.attributes.map((attr, idx) => (
                  <div key={idx} className="flex gap-2">
                    <span className="text-text-muted">{attr.name}:</span>
                    <span className="font-medium text-text">{attr.value}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Actions */}
          <div className="flex flex-col sm:flex-row gap-4 mb-8">
            <div className="flex items-center border border-border rounded-lg bg-surface-1 h-12 w-32 shrink-0">
              <button onClick={() => setQuantity(Math.max(1, quantity - 1))} className="flex-1 h-full text-xl hover:text-brand-600 transition-colors">-</button>
              <span className="flex-1 text-center font-medium">{quantity}</span>
              <button onClick={() => setQuantity(Math.min(product.stockQuantity || 99, quantity + 1))} className="flex-1 h-full text-xl hover:text-brand-600 transition-colors">+</button>
            </div>
            <AddToCartButton product={product} quantity={quantity} />
            <Button variant="ghost" size="lg" className="h-12 w-12 p-0 shrink-0 border-border">
              <Heart className="w-5 h-5 text-text-muted" />
            </Button>
          </div>

          {/* Guarantees */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 bg-surface-1 rounded-xl p-4 border border-border">
            <div className="flex items-start gap-3">
              <Truck className="w-5 h-5 text-brand-600 shrink-0 mt-0.5" />
              <div>
                <p className="text-sm font-semibold text-text">Nationwide Delivery</p>
                <p className="text-xs text-text-muted mt-1">2-5 working days depending on location.</p>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <ShieldCheck className="w-5 h-5 text-brand-600 shrink-0 mt-0.5" />
              <div>
                <p className="text-sm font-semibold text-text">ABA Buyer Protection</p>
                <p className="text-xs text-text-muted mt-1">Full refund if item is not as described.</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Tabs Section */}
      <div className="mt-16">
        <div className="border-b border-border flex gap-8">
          <button className="pb-3 border-b-2 border-brand-600 text-brand-600 font-semibold text-lg">Description</button>
          <button className="pb-3 border-b-2 border-transparent text-text-muted hover:text-text font-medium text-lg">Specifications</button>
          <button className="pb-3 border-b-2 border-transparent text-text-muted hover:text-text font-medium text-lg">Reviews ({product.reviewCount})</button>
        </div>
        <div className="py-8 prose max-w-none text-text-muted text-sm sm:text-base leading-relaxed">{product.description}</div>
      </div>
    </div>
  );
}
