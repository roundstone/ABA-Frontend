import React from 'react';
import Link from 'next/link';
import { Store, TrendingUp, Camera, Lock, Truck } from 'lucide-react';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';

/**
 * "Sell" and "Earn" calls to action (Doc 06 §2.3). Uses the amber `--store-warm` accent (Doc 06 §12).
 * Shared by the storefront header utility strip and the /dev/theme preview.
 */
export function SellEarnCtas() {
  return (
    <div className="flex w-full md:w-auto gap-2 text-xs md:text-sm">
      <Popover>
        <PopoverTrigger className="flex-1 md:flex-none flex items-center justify-center gap-2 px-3 py-1.5 rounded-full bg-white border border-border hover:border-brand-300 hover:text-brand-700 transition-colors">
          <Store className="w-3.5 h-3.5 text-brand-600" />
          <span className="hidden md:inline font-medium">Sell: Start your store</span>
          <span className="md:hidden font-medium">Sell</span>
        </PopoverTrigger>
        <PopoverContent align="start" className="w-[360px] p-6 rounded-3xl shadow-xl mt-2 border-border/50">
          <h2 className="text-2xl font-bold text-brand-950 mb-1">Start selling in a snap</h2>
          <p className="text-[15px] text-text-muted mb-6">Turn your pre-loved items into extra cash.</p>

          <div className="space-y-5 mb-8">
            <div className="flex gap-4 items-start">
              <Camera className="w-6 h-6 text-brand-950 shrink-0 mt-0.5" strokeWidth={1.5} />
              <p className="text-[15px] font-medium text-brand-950 leading-snug">Listing is easy, and faster than ever in the app</p>
            </div>
            <div className="flex gap-4 items-start">
              <Lock className="w-6 h-6 text-brand-950 shrink-0 mt-0.5" strokeWidth={1.5} />
              <p className="text-[15px] font-medium text-brand-950 leading-snug">Seller protections and secure payments</p>
            </div>
            <div className="flex gap-4 items-start">
              <Truck className="w-6 h-6 text-brand-950 shrink-0 mt-0.5" strokeWidth={1.5} />
              <p className="text-[15px] font-medium text-brand-950 leading-snug">Easy shipping and local pickup</p>
            </div>
          </div>

          <Link href="/merchants/onboarding" className="flex items-center justify-center w-full bg-brand-500 text-white rounded-full py-3.5 font-bold text-base hover:bg-brand-500/90 transition-colors mb-3">
            List an item
          </Link>
          <Link href="#" className="flex items-center justify-center w-full bg-white text-brand-950 rounded-full py-3.5 font-bold text-base border border-border hover:bg-gray-50 transition-colors">
            Download the app
          </Link>
        </PopoverContent>
      </Popover>
      <Link href="/community" className="flex-1 md:flex-none flex items-center justify-center gap-2 px-3 py-1.5 rounded-full bg-white border border-border hover:border-copper/30 hover:text-copper transition-colors">
        <TrendingUp className="w-3.5 h-3.5 text-copper" />
        <span className="hidden md:inline font-medium">Earn: Refer & get paid</span>
        <span className="md:hidden font-medium">Earn</span>
      </Link>
    </div>
  );
}
