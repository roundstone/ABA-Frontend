'use client';

import React, { useState, useEffect } from 'react';
import { Search, SlidersHorizontal, ChevronDown } from 'lucide-react';
import { useRouter, useSearchParams, usePathname } from 'next/navigation';
import { cn } from 'cn';
import { Button } from '@/components/ui/button';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from '@/components/ui/sheet';
import { StoreCategoryMenu } from './StoreCategoryMenu';
import { Product } from '@/features/products/types';

interface StoreFilterBarProps {
  products: Product[]; // Used for category menu on mobile/sheet
}

export function StoreFilterBar({ products }: StoreFilterBarProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const pathname = usePathname();

  const [isSticky, setIsSticky] = useState(false);
  const [searchTerm, setSearchTerm] = useState(searchParams.get('q') || '');

  // Detect scroll to make it sticky and show collapsed items
  useEffect(() => {
    const handleScroll = () => {
      // Threshold could be the height of the banner + some offset
      if (window.scrollY > 300) {
        setIsSticky(true);
      } else {
        setIsSticky(false);
      }
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const updateParam = (key: string, value: string | null) => {
    const newParams = new URLSearchParams(searchParams.toString());
    if (value) {
      newParams.set(key, value);
    } else {
      newParams.delete(key);
    }
    router.push(`${pathname}?${newParams.toString()}`);
  };

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    updateParam('q', searchTerm);
  };

  const currentSort = searchParams.get('sort') || 'recommended';
  const minRating = searchParams.get('minRating');
  const inStockOnly = searchParams.get('inStockOnly') === 'true';
  const onSaleOnly = searchParams.get('onSaleOnly') === 'true';

  return (
    <div 
      className={cn(
        "transition-all duration-200 z-40 bg-surface-1",
        isSticky ? "sticky top-16 md:top-20 py-2 border-b border-border shadow-sm mx-[-1rem] px-[1rem] sm:mx-0 sm:px-0" : "mb-6"
      )}
    >
      <div className="bg-white rounded-xl border border-border p-3 shadow-sm flex flex-col sm:flex-row justify-between items-center gap-3">
        
        {/* Left Side: Categories button (shows when sticky or on mobile) & Search */}
        <div className="flex w-full sm:w-auto items-center gap-2">
          {/* Mobile or Sticky Categories Sheet */}
          <div className={cn("sm:hidden", isSticky && "hidden sm:block")}>
            <Sheet>
              <SheetTrigger render={<Button variant="outline" className="shrink-0" size="sm" />}>
                <SlidersHorizontal className="w-4 h-4 mr-2" /> Categories
              </SheetTrigger>
              <SheetContent side="left" className="w-[300px] sm:w-[350px]">
                <SheetHeader className="mb-4">
                  <SheetTitle>Filters</SheetTitle>
                </SheetHeader>
                <div className="py-2">
                  <StoreCategoryMenu products={products} />
                  {/* Additional filters can go here in the sheet */}
                </div>
              </SheetContent>
            </Sheet>
          </div>

          <form onSubmit={handleSearch} className="relative w-full sm:w-64">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
            <input
              type="text"
              placeholder="Search in store..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full h-9 pl-9 pr-4 rounded-md border border-border text-sm focus:ring-2 focus:ring-brand-500 outline-none"
            />
          </form>
        </div>

        {/* Right Side: Filters & Sort */}
        <div className="flex items-center gap-2 w-full sm:w-auto overflow-x-auto pb-1 sm:pb-0 hide-scrollbar">
          
          {/* Quick Filters */}
          <Button 
            variant={inStockOnly ? "primary" : "outline"} 
            size="sm" 
            className="shrink-0 text-xs h-8"
            onClick={() => updateParam('inStockOnly', inStockOnly ? null : 'true')}
          >
            In Stock
          </Button>
          
          <Button 
            variant={onSaleOnly ? "primary" : "outline"} 
            size="sm" 
            className="shrink-0 text-xs h-8"
            onClick={() => updateParam('onSaleOnly', onSaleOnly ? null : 'true')}
          >
            On Sale
          </Button>

          <Popover>
            <PopoverTrigger render={<Button variant={minRating ? "primary" : "outline"} size="sm" className="shrink-0 text-xs h-8" />}>
              Rating <ChevronDown className="w-3 h-3 ml-1" />
            </PopoverTrigger>
            <PopoverContent className="w-40 p-2" align="end">
              <div className="space-y-1">
                <Button variant="ghost" size="sm" className="w-full justify-start text-xs" onClick={() => updateParam('minRating', null)}>All Ratings</Button>
                <Button variant="ghost" size="sm" className="w-full justify-start text-xs" onClick={() => updateParam('minRating', '4')}>4+ Stars</Button>
                <Button variant="ghost" size="sm" className="w-full justify-start text-xs" onClick={() => updateParam('minRating', '3')}>3+ Stars</Button>
              </div>
            </PopoverContent>
          </Popover>

          <div className="h-6 w-px bg-border mx-1 shrink-0" />

          {/* Sort */}
          <div className="flex items-center gap-2 shrink-0">
            <span className="text-xs text-text-muted hidden md:inline">Sort:</span>
            <select 
              value={currentSort}
              onChange={(e) => updateParam('sort', e.target.value)}
              className="h-8 px-2 py-1 rounded-md border border-border bg-white text-xs focus:outline-none focus:ring-1 focus:ring-brand-500"
            >
              <option value="recommended">Recommended</option>
              <option value="newest">New Arrivals</option>
              <option value="price-asc">Price: Low to High</option>
              <option value="price-desc">Price: High to Low</option>
              <option value="rating">Top Rated</option>
            </select>
          </div>
        </div>

      </div>
    </div>
  );
}
