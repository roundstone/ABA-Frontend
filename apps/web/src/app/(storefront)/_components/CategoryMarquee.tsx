import React from 'react';
import Link from 'next/link';
import { getShopCategories } from '@/features/shop/api';

export async function CategoryMarquee() {
  const { data: categories } = await getShopCategories();

  return (
    <section className="py-16 bg-gradient-to-b from-[#fdfaf1] to-bg">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-end mb-8">
          <div>
            <h2 className="text-2xl font-bold text-brand-900 mb-2">Discover what Aba has to offer</h2>
            <p className="text-text-muted">Shop products from businesses across Aba and Abia.</p>
          </div>
          <Link href="/shop" className="text-brand-600 font-semibold hover:underline hidden sm:block">
            View All Categories &rarr;
          </Link>
        </div>
      </div>

      <div className="relative overflow-hidden w-full">
        <div className="flex gap-6 animate-marquee w-max py-4 px-4">
          {[...categories, ...categories].map((cat, i) => (
            <Link key={i} href={`/category/${cat.slug}`} className="group cursor-pointer w-36 sm:w-48 shrink-0">
              <div className="aspect-square bg-white rounded-xl mb-3 flex items-center justify-center border border-border group-hover:border-brand-300 group-hover:shadow-lg group-hover:-translate-y-1 transition-all duration-300 overflow-hidden relative">
                {cat.image ? (
                   <img src={cat.image} alt={cat.name} className="absolute inset-0 w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" />
                ) : (
                   <span className="text-text-muted/50 font-medium text-sm group-hover:scale-110 transition-transform duration-300 relative z-10">Image</span>
                )}
                <div className="absolute inset-0 bg-brand-900/0 group-hover:bg-brand-900/10 transition-colors duration-300 z-10"></div>
              </div>
              <h3 className="font-medium text-text text-center group-hover:text-brand-600 transition-colors">{cat.name}</h3>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}
