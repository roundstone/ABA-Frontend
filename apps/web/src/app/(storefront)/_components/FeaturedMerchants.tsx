import React from 'react';
import Link from 'next/link';
import { Star, MapPin } from 'lucide-react';
import { getMerchants } from '@/features/merchant/api';

export async function FeaturedMerchants() {
  // Fetch from our API
  const merchants = await getMerchants();

  // We'll take the first two for the featured section
  const featured = merchants.data?.slice(0, 2);

  return (
    <section className="bg-white border-b border-border py-20 relative overflow-hidden animate-in fade-in slide-in-from-bottom-4 duration-700">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="flex flex-col md:flex-row justify-between items-end mb-12 gap-6">
          <div className="max-w-2xl">
            <h2 className="text-3xl md:text-4xl font-extrabold text-brand-900 tracking-tight mb-4">
              Meet Aba's Businesses
            </h2>
            <p className="text-lg text-text-muted">
              Every product has a story. Connect directly with the master craftspeople and visionary entrepreneurs driving the local economy.
            </p>
          </div>
          <Link href="/merchant" className="shrink-0 flex items-center gap-2 text-brand-600 font-semibold hover:text-brand-700 transition-colors group px-6 py-3 bg-brand-50 rounded-full shadow-sm hover:shadow-md border border-brand-100 hover:scale-105">
            View All Businesses <span className="group-hover:translate-x-1 transition-transform">&rarr;</span>
          </Link>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {featured.map((merchant, i) => (
            <div key={merchant.id} className="group flex flex-col bg-white rounded-3xl border border-border overflow-hidden shadow-sm hover:shadow-2xl hover:-translate-y-1 transition-all duration-500">
              <div className={`h-48 md:h-64 relative overflow-hidden ${i % 2 === 0 ? 'bg-gradient-to-br from-brand-600 to-brand-900' : 'bg-gradient-to-tr from-[#bd8939] to-[#7f4522]'}`}>
                {merchant.bannerImage ? (
                  <img src={merchant.bannerImage} alt={`${merchant.name} banner`} className="absolute inset-0 w-full h-full object-cover group-hover:scale-110 transition-transform duration-700 mix-blend-overlay opacity-80" />
                ) : (
                  <div className="absolute inset-0 opacity-20 mix-blend-overlay bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] group-hover:scale-110 transition-transform duration-700"></div>
                )}
                <div className="absolute inset-0 bg-black/30 group-hover:bg-black/10 transition-colors duration-500"></div>
                <div className="absolute top-4 right-6 flex items-center gap-2">
                  <span className="px-3 py-1 bg-white/90 backdrop-blur-sm text-text-dark text-xs font-bold rounded-full shadow-lg flex items-center gap-1 group-hover:bg-white transition-colors duration-300">
                    <Star className="w-3 h-3 text-warning-main fill-warning-main group-hover:scale-110 transition-transform" /> 4.9 (128 reviews)
                  </span>
                  <span className="px-3 py-1 bg-black/50 backdrop-blur-md text-white text-xs font-bold rounded-full shadow-lg border border-white/20 flex items-center gap-1">
                    <MapPin className="w-3 h-3" /> {merchant.city}, {merchant.state}
                  </span>
                </div>
              </div>
              <div className="p-8 flex flex-col flex-1 relative">
                <div className={`w-20 h-20 bg-white rounded-2xl shadow-lg border-4 border-white flex items-center justify-center absolute -top-10 left-8 text-2xl font-extrabold group-hover:scale-110 group-hover:-translate-y-1 transition-all duration-300 overflow-hidden z-10 ${i % 2 === 0 ? 'text-brand-600' : 'text-[#7f4522]'}`}>
                  {merchant.logoUrl ? (
                    <img src={merchant.logoUrl} alt={merchant.name} className="w-full h-full object-cover" />
                  ) : (
                    merchant.name.substring(0, 2).toUpperCase()
                  )}
                </div>
                <div className="mt-8 mb-4">
                  <h3 className="text-2xl font-bold text-text group-hover:text-brand-600 transition-colors duration-300">{merchant.name}</h3>
                  <p className="text-sm text-text-muted mt-1 font-medium">Joined {new Date(merchant.onboardedAt).getFullYear()} • {merchant.ordersCount}+ Orders</p>
                </div>
                <p className="text-text-muted line-clamp-3 mb-8 leading-relaxed">
                  Local business delivering top quality products directly from {merchant.city}. Connect directly with {merchant.ownerName} to build a lasting business relationship.
                </p>
                <div className="mt-auto pt-6 border-t border-border flex justify-between items-center">
                  <Link href={`/merchants/${merchant.id}`} className="px-5 py-2.5 bg-surface-2 text-text font-semibold rounded-full border border-border hover:border-brand-600 hover:bg-brand-50 hover:text-brand-600 transition-all shadow-sm w-full text-center">
                    Visit Store
                  </Link>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
