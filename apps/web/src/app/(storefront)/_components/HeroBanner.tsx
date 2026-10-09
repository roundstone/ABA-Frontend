'use client';
import { brand } from '@/config/brand';
import React from 'react';
import { BannerCarousel } from '@/components/patterns/BannerCarousel';

export function HeroBanner() {
  const banners = [
    { id: 1, src: '/banners/Aba Online_ Shop Local, Shop Aba.png', alt: brand.tagline },
    { id: 2, src: '/banners/AbaOnline_ Shop Local, Grow Together.png', alt: `Shop Local, Grow Together` },
    { id: 3, src: '/banners/Shop Local, Support Aba.png', alt: `Shop Local, Support Nigeria` },
  ];

  return (
    <section className="md:py-10 py-4 animate-in fade-in duration-700 mt-20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <BannerCarousel banners={banners} />
      </div>
    </section>
  );
}
