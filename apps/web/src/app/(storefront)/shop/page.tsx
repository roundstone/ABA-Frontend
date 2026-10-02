'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { Star, SlidersHorizontal, ChevronDown, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useQuery } from '@tanstack/react-query';
import { getShopProducts, getShopCategories, getShopMerchants } from '@/features/shop/api';
import { ProductCard } from '@/components/storefront/ProductCard';

export default function ProductListingPage() {
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [selectedMerchant, setSelectedMerchant] = useState<string | null>(null);

  const { data: productsData, isLoading: isLoadingProducts } = useQuery({
    queryKey: ['shop_products', selectedCategory, selectedMerchant],
    queryFn: async () => {
      const res = await getShopProducts({
        categorySlug: selectedCategory || undefined,
        merchantId: selectedMerchant || undefined,
      });
      return res.data;
    }
  });

  const { data: categoriesData } = useQuery({
    queryKey: ['shop_categories'],
    queryFn: async () => (await getShopCategories()).data
  });

  const { data: merchantsData } = useQuery({
    queryKey: ['shop_merchants'],
    queryFn: async () => (await getShopMerchants()).data
  });

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Breadcrumbs & Title */}
      <div className="mb-6">
        <nav className="text-sm text-text-muted mb-2">
          <Link href="/" className="hover:text-brand-600">Home</Link>
          <span className="mx-2">&rsaquo;</span>
          <span className="text-text">All Categories</span>
        </nav>
        <h1 className="text-3xl font-bold text-text">Shop {selectedCategory ? selectedCategory : 'All Categories'}</h1>
      </div>

      <div className="flex flex-col md:flex-row gap-8">
        {/* Filters Sidebar */}
        <aside className="w-full md:w-64 shrink-0 hidden md:block">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold text-lg flex items-center gap-2">
              <SlidersHorizontal className="w-5 h-5" />
              Filters
            </h2>
            <button
              className="text-xs text-brand-600 hover:underline"
              onClick={() => { setSelectedCategory(null); setSelectedMerchant(null); }}
            >
              Clear all
            </button>
          </div>

          <div className="space-y-6">
            {/* Category Filter */}
            <div className="border-t border-border pt-4">
              <h3 className="font-medium text-text mb-3">Categories</h3>
              <div className="space-y-2 text-sm text-text-muted">
                {categoriesData?.map(cat => (
                  <label key={cat.id} className="flex items-center gap-2 cursor-pointer hover:text-brand-600">
                    <input
                      type="radio"
                      name="category"
                      checked={selectedCategory === cat.slug}
                      onChange={() => setSelectedCategory(cat.slug)}
                      className="rounded text-brand-600 focus:ring-brand-500"
                    />
                    {cat.name}
                  </label>
                ))}
              </div>
            </div>

            {/* Price Filter (Mock) */}
            <div className="border-t border-border pt-4">
              <h3 className="font-medium text-text mb-3">Price Range</h3>
              <div className="flex items-center gap-2">
                <input type="text" placeholder="Min" className="w-full h-8 px-2 rounded border border-border text-sm" />
                <span>-</span>
                <input type="text" placeholder="Max" className="w-full h-8 px-2 rounded border border-border text-sm" />
              </div>
            </div>

            {/* Merchant Filter */}
            <div className="border-t border-border pt-4">
              <h3 className="font-medium text-text mb-3">Merchant</h3>
              <div className="space-y-2 text-sm text-text-muted">
                {merchantsData?.map(merch => (
                  <label key={merch.id} className="flex items-center gap-2 cursor-pointer hover:text-brand-600">
                    <input
                      type="radio"
                      name="merchant"
                      checked={selectedMerchant === merch.id}
                      onChange={() => setSelectedMerchant(merch.id)}
                      className="rounded text-brand-600 focus:ring-brand-500"
                    />
                    {merch.name}
                  </label>
                ))}
              </div>
            </div>

          </div>
        </aside>

        {/* Main Product Grid */}
        <div className="flex-1">
          {/* Top Bar */}
          <div className="flex justify-between items-center mb-6">
            <span className="text-sm text-text-muted">
              {isLoadingProducts ? 'Loading...' : `Showing ${productsData?.length || 0} results`}
            </span>

            <div className="flex items-center gap-2">
              <span className="text-sm text-text-muted">Sort by:</span>
              <select className="h-9 px-3 py-1 rounded-md border border-border bg-white text-sm focus:outline-none focus:ring-2 focus:ring-brand-500">
                <option>Relevance</option>
                <option>Newest Arrivals</option>
                <option>Price: Low to High</option>
                <option>Price: High to Low</option>
                <option>Highest Rated</option>
              </select>
            </div>
          </div>

          {/* Grid */}
          {isLoadingProducts ? (
            <div className="flex justify-center py-20">
              <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
            </div>
          ) : productsData?.length === 0 ? (
            <div className="text-center py-20 text-text-muted">No products found matching your filters.</div>
          ) : (
            <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {productsData?.map(product => (
                <ProductCard key={product.id} product={product} />
              ))}
            </div>
          )}

          {/* Pagination */}
          <div className="mt-12 flex justify-center">
            <div className="flex gap-2">
              <Button variant="ghost" className="w-10 h-10 p-0 rounded-md" disabled>&lt;</Button>
              <Button className="w-10 h-10 p-0 rounded-md">1</Button>
              <Button variant="ghost" className="w-10 h-10 p-0 rounded-md" disabled>&gt;</Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
