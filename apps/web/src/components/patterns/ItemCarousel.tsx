'use client';

import React, { useCallback, useEffect, useRef, useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { cn } from 'cn';

export interface ItemCarouselProps {
  /** Accessible name of the carousel region. */
  label: string;
  children: React.ReactNode;
  /** Off by default (Doc 06 §6.1). */
  autoplay?: boolean;
  autoplayIntervalMs?: number;
  className?: string;
}

/**
 * Responsive scroll-snap carousel with arrows, dots and native swipe.
 * Cards per view: 1 mobile, 2 tablet (md), 3 laptop (lg), 4 desktop (xl >= 1280px).
 */
export function ItemCarousel({ label, children, autoplay = false, autoplayIntervalMs = 6000, className }: ItemCarouselProps) {
  const trackRef = useRef<HTMLDivElement>(null);
  const [page, setPage] = useState(0);
  const [pageCount, setPageCount] = useState(1);
  const [paused, setPaused] = useState(false);
  const items = React.Children.toArray(children);

  const measure = useCallback(() => {
    const track = trackRef.current;
    const first = track?.firstElementChild as HTMLElement | null;
    if (!track || !first) return;
    const perView = Math.max(1, Math.round(track.clientWidth / first.offsetWidth));
    const pages = Math.max(1, Math.ceil(items.length / perView));
    setPageCount(pages);
    const max = track.scrollWidth - track.clientWidth;
    setPage(track.scrollLeft >= max - 2 ? pages - 1 : Math.min(pages - 1, Math.round(track.scrollLeft / track.clientWidth)));
  }, [items.length]);

  useEffect(() => {
    measure();
    const track = trackRef.current;
    if (!track) return;
    const ro = new ResizeObserver(measure);
    ro.observe(track);
    return () => ro.disconnect();
  }, [measure]);

  const goTo = useCallback((target: number) => {
    const track = trackRef.current;
    if (!track) return;
    track.scrollTo({ left: target * track.clientWidth, behavior: 'smooth' });
  }, []);

  useEffect(() => {
    if (!autoplay || paused || pageCount < 2) return;
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    const id = setInterval(() => goTo((page + 1) % pageCount), autoplayIntervalMs);
    return () => clearInterval(id);
  }, [autoplay, paused, pageCount, page, autoplayIntervalMs, goTo]);

  const arrow = 'absolute top-1/2 -translate-y-1/2 z-10 h-10 w-10 rounded-full bg-white border border-border shadow-md flex items-center justify-center text-text hover:text-brand-600 disabled:opacity-0 disabled:pointer-events-none transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-500';

  return (
    <div
      role="region"
      aria-roledescription="carousel"
      aria-label={label}
      className={cn('relative', className)}
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      onFocus={() => setPaused(true)}
      onBlur={() => setPaused(false)}
    >
      <button type="button" aria-label="Previous" className={cn(arrow, '-left-3 md:-left-5')} disabled={page === 0} onClick={() => goTo(page - 1)}>
        <ChevronLeft className="w-5 h-5" />
      </button>
      <button type="button" aria-label="Next" className={cn(arrow, '-right-3 md:-right-5')} disabled={page >= pageCount - 1} onClick={() => goTo(page + 1)}>
        <ChevronRight className="w-5 h-5" />
      </button>

      <div
        ref={trackRef}
        onScroll={measure}
        className="flex overflow-x-auto snap-x snap-mandatory scroll-smooth -mx-2 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden"
      >
        {items.map((item, i) => (
          <div
            key={i}
            role="group"
            aria-roledescription="slide"
            aria-label={`${i + 1} of ${items.length}`}
            className="shrink-0 snap-start basis-full md:basis-1/4 lg:basis-1/4 xl:basis-1/4 px-2"
          >
            {item}
          </div>
        ))}
      </div>

      {pageCount > 1 && (
        <div className="flex justify-center gap-2 mt-5" role="tablist" aria-label={`${label} pages`}>
          {Array.from({ length: pageCount }, (_, i) => (
            <button
              key={i}
              type="button"
              role="tab"
              aria-selected={i === page}
              aria-label={`Go to page ${i + 1}`}
              onClick={() => goTo(i)}
              className={cn('h-2 rounded-full transition-all', i === page ? 'w-6 bg-brand-600' : 'w-2 bg-border hover:bg-brand-300')}
            />
          ))}
        </div>
      )}
    </div>
  );
}
