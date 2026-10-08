import { brand } from '@/config/brand';
import React from 'react';
import Link from 'next/link';
import { ArrowRight, ShoppingBag, Store, TrendingUp } from 'lucide-react';
import { getPageBySlug } from '@/features/content/api';

export default async function StorefrontHome() {
  const page = await getPageBySlug('about');
  const sections = [...page.sections].sort((a, b) => a.order - b.order);
  const publishedSections = sections.filter(s => s.status === 'Published');

  const getSectionContent = (name: string, fallback: string) => {
    return publishedSections.find(s => s.name === name)?.content || fallback;
  };

  return (
    <div className="flex flex-col w-full font-sans pt-4 mt-20 animate-in fade-in duration-1000">
      <section className="py-16 border-b border-border">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto mb-12 animate-in fade-in slide-in-from-bottom-4 duration-1000">
            <h2 className="text-3xl md:text-4xl font-extrabold text-brand-900 mb-4">
              {page.title}
            </h2>
            <p className="text-lg text-text-muted whitespace-pre-wrap">
              {getSectionContent('Hero/Intro', `${brand.name} is a digital marketplace...`)}
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="group bg-brand-50 rounded-2xl p-8 border border-brand-100 flex flex-col h-full hover:-translate-y-2 hover:shadow-xl transition-all duration-300">
              <div className="w-12 h-12 bg-white rounded-xl flex items-center justify-center text-brand-600 mb-6 shadow-sm group-hover:scale-110 group-hover:rotate-3 transition-transform duration-300">
                <ShoppingBag className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-brand-900 mb-2">Shop</h3>
              <p className="text-sm font-semibold text-brand-600 mb-4 uppercase tracking-wider">For Customers</p>
              <p className="text-text-muted mb-8 flex-1 whitespace-pre-wrap">
                {getSectionContent('Shop (For Customers)', 'Discover products and services...')}
              </p>
              <Link href="/shop" className="text-brand-600 font-bold flex items-center gap-2 group-hover:gap-3 transition-all duration-300">
                Start Shopping <ArrowRight className="w-4 h-4" />
              </Link>
            </div>

            <div className="group bg-surface-2 rounded-2xl p-8 border border-border flex flex-col h-full hover:-translate-y-2 hover:shadow-xl transition-all duration-300">
              <div className="w-12 h-12 bg-white rounded-xl flex items-center justify-center text-brand-600 mb-6 shadow-sm group-hover:scale-110 group-hover:rotate-3 transition-transform duration-300">
                <Store className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-text mb-2">Sell</h3>
              <p className="text-sm font-semibold text-brand-600 mb-4 uppercase tracking-wider">For Merchants</p>
              <p className="text-text-muted mb-8 flex-1 whitespace-pre-wrap">
                {getSectionContent('Sell (For Merchants)', 'Put your business in front of more customers...')}
              </p>
              <Link href="/merchants/onboarding" className="text-brand-600 font-bold flex items-center gap-2 group-hover:gap-3 transition-all duration-300">
                Become a Merchant <ArrowRight className="w-4 h-4" />
              </Link>
            </div>

            <div className="group bg-[#fff9f0] rounded-2xl p-8 border border-[#f5e6d3] flex flex-col h-full hover:-translate-y-2 hover:shadow-xl transition-all duration-300">
              <div className="w-12 h-12 bg-white rounded-xl flex items-center justify-center text-copper mb-6 shadow-sm group-hover:scale-110 group-hover:-rotate-3 transition-transform duration-300">
                <TrendingUp className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-text mb-2">Earn</h3>
              <p className="text-sm font-semibold text-copper mb-4 uppercase tracking-wider">For Members</p>
              <p className="text-text-muted mb-8 flex-1 whitespace-pre-wrap">
                {getSectionContent('Earn (For Members)', 'Refer friends, participate in the community...')}
              </p>
              <Link href="/auth/login" className="text-copper font-bold flex items-center gap-2 group-hover:gap-3 transition-all duration-300">
                Join the Community <ArrowRight className="w-4 h-4" />
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
