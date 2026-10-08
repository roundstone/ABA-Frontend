'use client';

import React, { useState, useEffect } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { cn } from '@/lib/utils';

export interface BannerSlide {
  id: string | number;
  src: string;
  alt: string;
  link?: string;
}

export interface BannerCarouselProps {
  banners: BannerSlide[];
  autoPlayIntervalMs?: number;
  className?: string;
  imageContainerClassName?: string;
}

export function BannerCarousel({
  banners,
  autoPlayIntervalMs = 5000,
  className,
  imageContainerClassName,
}: BannerCarouselProps) {
  const [currentSlide, setCurrentSlide] = useState(0);

  useEffect(() => {
    if (banners.length <= 1) return;
    
    const timer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % banners.length);
    }, autoPlayIntervalMs);
    
    return () => clearInterval(timer);
  }, [banners.length, autoPlayIntervalMs]);

  if (!banners || banners.length === 0) return null;

  return (
    <div className={cn("relative group", className)}>
      <div className={cn("relative w-full aspect-21/6 md:aspect-24/5 rounded-xl overflow-hidden shadow-sm bg-surface-2", imageContainerClassName)}>
        {banners.map((banner, index) => (
          <div
            key={banner.id}
            className={`absolute inset-0 transition-all duration-1000 ease-in-out ${index === currentSlide ? 'opacity-100 scale-100 z-10' : 'opacity-0 scale-105 z-0'}`}
          >
            {banner.link ? (
              <a href={banner.link} className="block w-full h-full">
                <img
                  src={banner.src}
                  alt={banner.alt}
                  className="object-cover w-full h-full"
                />
              </a>
            ) : (
              <img
                src={banner.src}
                alt={banner.alt}
                className="object-cover w-full h-full"
              />
            )}
          </div>
        ))}

        {/* Navigation Arrows */}
        {banners.length > 1 && (
          <>
            <button
              onClick={() => setCurrentSlide((prev) => (prev === 0 ? banners.length - 1 : prev - 1))}
              className="absolute left-4 top-1/2 -translate-y-1/2 z-20 w-10 h-10 rounded-full bg-white/70 hover:bg-white flex items-center justify-center text-text shadow-md opacity-0 group-hover:opacity-100 hover:scale-110 transition-all duration-300"
              aria-label="Previous slide"
            >
              <ChevronLeft className="w-6 h-6" />
            </button>
            <button
              onClick={() => setCurrentSlide((prev) => (prev + 1) % banners.length)}
              className="absolute right-4 top-1/2 -translate-y-1/2 z-20 w-10 h-10 rounded-full bg-white/70 hover:bg-white flex items-center justify-center text-text shadow-md opacity-0 group-hover:opacity-100 hover:scale-110 transition-all duration-300"
              aria-label="Next slide"
            >
              <ChevronRight className="w-6 h-6" />
            </button>

            {/* Dots */}
            <div className="absolute bottom-4 right-8 z-20 flex space-x-2">
              {banners.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setCurrentSlide(index)}
                  className={`w-2.5 h-2.5 rounded-full transition-all duration-300 ${index === currentSlide ? 'bg-white scale-125 w-6' : 'bg-white/50 hover:bg-white/80'}`}
                  aria-label={`Go to slide ${index + 1}`}
                />
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  );
}
