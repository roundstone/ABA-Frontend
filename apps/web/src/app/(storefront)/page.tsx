import React from 'react';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import {
  ShoppingBag, Star, TrendingUp, Store,
  Users, CheckCircle2, ArrowRight, Heart
} from 'lucide-react';

import { HeroBanner } from './_components/HeroBanner';
import { FeaturedMerchants } from './_components/FeaturedMerchants';
import { TrendingProducts } from './_components/TrendingProducts';
import { CategoryMarquee } from './_components/CategoryMarquee';
import Image from 'next/image';

export default function StorefrontHome() {
  return (
    <div className="flex flex-col w-full font-sans pt-4 animate-in fade-in duration-1000 bg-[#fdfaf1]">

      {/* 1. Slide Banner Section (Hero) */}
      <HeroBanner />

      {/* 2. What is ABA Online? (The 3 Audiences) */}
      <section className="py-16 border-b border-border">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto mb-12 animate-in fade-in slide-in-from-bottom-4 duration-1000">
            <h2 className="text-3xl md:text-4xl font-extrabold text-brand-900 mb-4">
              What is ABA Online?
            </h2>
            <p className="text-lg text-text-muted">
              ABA Online is a digital marketplace connecting shoppers, merchants, and communities across Aba and Abia State. Discover local products, grow your business, and earn rewards for helping the ecosystem thrive.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="group bg-brand-50 rounded-2xl p-8 border border-brand-100 flex flex-col h-full hover:-translate-y-2 hover:shadow-xl transition-all duration-300">
              <div className="w-12 h-12 bg-white rounded-xl flex items-center justify-center text-brand-600 mb-6 shadow-sm group-hover:scale-110 group-hover:rotate-3 transition-transform duration-300">
                <ShoppingBag className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-brand-900 mb-2">Shop</h3>
              <p className="text-sm font-semibold text-brand-600 mb-4 uppercase tracking-wider">For Customers</p>
              <p className="text-text-muted mb-8 flex-1">
                Discover products and services from businesses around Aba and beyond. Quality local goods, delivered to you.
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
              <p className="text-text-muted mb-8 flex-1">
                Put your business in front of more customers, manage your digital storefront, and scale your operations.
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
              <p className="text-text-muted mb-8 flex-1">
                Refer friends, participate in the community, and earn commissions through our rewards program.
              </p>
              <Link href="/auth/login" className="text-copper font-bold flex items-center gap-2 group-hover:gap-3 transition-all duration-300">
                Join the Community <ArrowRight className="w-4 h-4" />
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* 3. Shop Aba (Categories) */}
      <CategoryMarquee />

      {/* 4. Made in Aba */}
      <section className="py-20 bg-brand-900 text-white relative overflow-hidden">
        <div className="absolute top-0 right-0 w-96 h-96 bg-brand-700 rounded-full mix-blend-multiply filter blur-3xl opacity-50 -translate-y-1/2 translate-x-1/2 pointer-events-none animate-pulse duration-[10000ms]"></div>
        <div className="absolute bottom-0 left-0 w-96 h-96 bg-brand-600 rounded-full mix-blend-multiply filter blur-3xl opacity-50 translate-y-1/2 -translate-x-1/2 pointer-events-none animate-pulse duration-[8000ms]"></div>

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 flex flex-col md:flex-row items-center gap-12">
          <div className="flex-1 space-y-6">
            <h2 className="text-3xl md:text-5xl font-extrabold tracking-tight text-brand-50">
              Made in Aba
            </h2>
            <p className="text-lg text-brand-100 max-w-lg">
              Discover authentic products crafted by the people and businesses that make Aba the manufacturing hub of West Africa.
              From premium leather shoes to expertly tailored garments.
            </p>
            <div className="pt-4">
              <Button size="lg" className="bg-white text-brand-900 hover:bg-brand-50 rounded-full font-bold px-8 hover:scale-105 transition-transform duration-300">
                Explore Made in Aba &rarr;
              </Button>
            </div>
          </div>
          <div className="flex-1 grid grid-cols-2 gap-4 w-full">
            {['Premium Leather Shoes', 'Tailored Clothing', 'Handcrafted Bags', 'Local Furniture'].map((item, i) => (
              <div key={i} className="group bg-white/10 backdrop-blur-sm border border-white/20 rounded-xl p-6 aspect-square flex flex-col items-center justify-center text-center hover:bg-white/20 hover:scale-105 hover:shadow-xl hover:shadow-brand-900/50 transition-all duration-300 cursor-pointer">
                <div className="w-16 h-16 bg-white/20 rounded-full mb-4 flex items-center justify-center group-hover:rotate-12 transition-transform duration-300">
                  <Star className="w-8 h-8 text-brand-50" />
                </div>
                <h4 className="font-bold text-white group-hover:text-brand-100 transition-colors">{item}</h4>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* 5. Featured Merchants (API Integration) */}
      <React.Suspense fallback={<div className="h-96 flex items-center justify-center">Loading Merchants...</div>}>
        <FeaturedMerchants />
      </React.Suspense>

      {/* 6. Trending Products (API Integration) */}
      <React.Suspense fallback={<div className="h-96 flex items-center justify-center">Loading Products...</div>}>
        <TrendingProducts />
      </React.Suspense>

      {/* 7. MLM / Earning Opportunity */}
      <section className="py-20 bg-white border-y border-border">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row items-center gap-16">
            <div className="flex-1 space-y-8">
              <div className="space-y-4 animate-in slide-in-from-left-4 duration-700">
                <span className="inline-block py-1 px-3 rounded-full bg-[#fff9f0] text-copper text-xs font-bold tracking-widest uppercase border border-[#f5e6d3]">
                  Rewards Program
                </span>
                <h2 className="text-3xl md:text-4xl font-extrabold text-brand-900 tracking-tight">
                  Shop. Refer. Earn. Grow.
                </h2>
                <p className="text-lg text-text-muted">
                  Turn your network into an opportunity. Refer people to ABA Online, help local businesses reach more customers, and earn commissions through our community-driven rewards program.
                </p>
              </div>

              <div className="space-y-6">
                {[
                  { step: '01', title: 'Join', desc: 'Create your free ABA Online account.' },
                  { step: '02', title: 'Share', desc: 'Invite customers, businesses, or members to the platform.' },
                  { step: '03', title: 'Earn', desc: 'Receive eligible commissions on sales generated by your network.' },
                  { step: '04', title: 'Grow', desc: 'Build your network and unlock more leadership opportunities.' },
                ].map((s, i) => (
                  <div key={i} className="flex gap-4 group cursor-default">
                    <div className="w-10 h-10 rounded-full bg-brand-50 flex items-center justify-center text-brand-600 font-bold shrink-0 group-hover:bg-brand-600 group-hover:text-white group-hover:scale-110 transition-all duration-300">{s.step}</div>
                    <div>
                      <h4 className="font-bold text-text text-lg group-hover:text-brand-600 transition-colors duration-300">{s.title}</h4>
                      <p className="text-text-muted group-hover:text-text transition-colors duration-300">{s.desc}</p>
                    </div>
                  </div>
                ))}
              </div>

              <Button size="lg" className="bg-copper hover:bg-[#a67732] text-white rounded-full font-bold px-8 hover:scale-105 hover:shadow-lg hover:shadow-copper/20 transition-all duration-300">
                Learn How It Works &rarr;
              </Button>
            </div>

            <div className="flex-1 w-full relative">
              <div className="aspect-square bg-surface-2 border border-border overflow-hidden relative shadow-inner flex items-center justify-center ">
                <Image width={500} height={500} src="/aba-illustration.png" alt="" className='w-full h-full' />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 8. For Merchants */}
      <section className="py-16 bg-brand-50 border-b border-brand-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center max-w-3xl">
          <h2 className="text-3xl font-extrabold text-brand-900 mb-4 animate-in slide-in-from-bottom-4 duration-700">Take Your Business Online</h2>
          <p className="text-lg text-text-muted mb-8">
            Whether you run a shop, workshop, fashion business, restaurant, or growing brand, ABA Online gives you a digital storefront to reach millions of buyers nationwide.
          </p>
          <div className="flex flex-wrap justify-center gap-x-8 gap-y-4 mb-8 text-sm font-medium text-brand-700">
            <span className="flex items-center gap-2 hover:text-brand-900 transition-colors cursor-default"><CheckCircle2 className="w-4 h-4" /> Create your storefront</span>
            <span className="flex items-center gap-2 hover:text-brand-900 transition-colors cursor-default"><CheckCircle2 className="w-4 h-4" /> List your products</span>
            <span className="flex items-center gap-2 hover:text-brand-900 transition-colors cursor-default"><CheckCircle2 className="w-4 h-4" /> Manage orders</span>
          </div>
          <Link href="/merchants/signup">
            <Button size="lg" className="bg-brand-600 hover:bg-brand-700 text-white rounded-full font-bold px-8 hover:scale-105 hover:shadow-lg transition-all duration-300">
              Become a Merchant
            </Button>
          </Link>
        </div>
      </section>

      {/* 9. Community Stories */}
      <section className="py-20 bg-white border-b border-border">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-extrabold text-brand-900 mb-4">Built by Aba. Growing with Aba.</h2>
            <p className="text-lg text-text-muted">What the ABA Online community is saying.</p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="group bg-surface-1 p-8 rounded-2xl border border-border hover:shadow-xl hover:-translate-y-2 hover:border-brand-200 transition-all duration-300">
              <div className="flex text-warning-main mb-4 group-hover:scale-105 origin-left transition-transform duration-300">
                {[1, 2, 3, 4, 5].map(i => <Star key={i} className="w-4 h-4 fill-current" />)}
              </div>
              <p className="text-text-muted italic mb-6">
                "I found a fantastic shoemaker in Aba and ordered directly through the platform. The quality is unmatched and delivery was seamless."
              </p>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-brand-100 rounded-full flex items-center justify-center text-brand-700 font-bold group-hover:bg-brand-600 group-hover:text-white transition-colors duration-300">CO</div>
                <div>
                  <p className="font-bold text-text text-sm">Chijioke O.</p>
                  <p className="text-xs text-text-muted">Customer in Abuja</p>
                </div>
              </div>
            </div>

            <div className="group bg-surface-1 p-8 rounded-2xl border border-border hover:shadow-xl hover:-translate-y-2 hover:border-copper/30 transition-all duration-300">
              <div className="flex text-warning-main mb-4 group-hover:scale-105 origin-left transition-transform duration-300">
                {[1, 2, 3, 4, 5].map(i => <Star key={i} className="w-4 h-4 fill-current" />)}
              </div>
              <p className="text-text-muted italic mb-6">
                "ABA Online helped us put our handcrafted bags in front of customers way outside our physical store in Ariaria. Our sales have doubled."
              </p>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-copper/20 rounded-full flex items-center justify-center text-copper font-bold group-hover:bg-copper group-hover:text-white transition-colors duration-300">NE</div>
                <div>
                  <p className="font-bold text-text text-sm">Ngozi E.</p>
                  <p className="text-xs text-text-muted">Merchant</p>
                </div>
              </div>
            </div>

            <div className="group bg-surface-1 p-8 rounded-2xl border border-border hover:shadow-xl hover:-translate-y-2 hover:border-brand-200 transition-all duration-300">
              <div className="flex text-warning-main mb-4 group-hover:scale-105 origin-left transition-transform duration-300">
                {[1, 2, 3, 4, 5].map(i => <Star key={i} className="w-4 h-4 fill-current" />)}
              </div>
              <p className="text-text-muted italic mb-6">
                "I joined the community as a promoter, shared links with my network, and started earning commissions every week. It's a real game changer."
              </p>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-brand-100 rounded-full flex items-center justify-center text-brand-700 font-bold group-hover:bg-brand-600 group-hover:text-white transition-colors duration-300">EK</div>
                <div>
                  <p className="font-bold text-text text-sm">Emeka K.</p>
                  <p className="text-xs text-text-muted">Community Member</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 10. Final CTA */}
      <section className="py-24 bg-brand-900 text-white relative overflow-hidden text-center group">
        <div className="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] group-hover:scale-105 transition-transform duration-1000"></div>
        <div className="relative z-10 max-w-3xl mx-auto px-4">
          <h2 className="text-4xl md:text-5xl font-extrabold mb-6 tracking-tight group-hover:-translate-y-1 transition-transform duration-500">Taking Aba's Marketplace Online</h2>
          <p className="text-xl text-brand-100 mb-10 leading-relaxed">
            Aba has always been known for its entrepreneurs, manufacturers, traders, and makers. ABA Online brings that energy into one digital marketplace — connecting local businesses with customers while creating new opportunities for people to participate and grow.
          </p>
          <div className="flex flex-col sm:flex-row justify-center gap-4">
            <Link href="/shop">
              <Button size="lg" className="bg-white text-brand-900 hover:bg-brand-50 w-full sm:w-auto rounded-full font-bold px-8 hover:scale-105 transition-transform duration-300 shadow-xl shadow-black/20">
                Start Shopping
              </Button>
            </Link>
            <Link href="/portal">
              <Button size="lg" variant="outline" className=" w-full sm:w-auto rounded-full font-bold px-8 hover:scale-105 transition-transform duration-300">
                Join ABA Online
              </Button>
            </Link>
          </div>
        </div>
      </section>

    </div>
  );
}
