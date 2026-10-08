'use client';

import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { ChevronLeft, ChevronRight, Maximize2, Heart, X, Play } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import { Dialog, DialogTrigger, DialogContent, DialogClose } from '@/components/ui/dialog';

export type GalleryMedia =
  | string
  | { type: 'image' | 'video'; src: string; poster?: string };

interface ProductGalleryProps {
  images: GalleryMedia[];
  productName: string;
}

interface MediaItem {
  type: 'image' | 'video';
  src: string;
  poster?: string;
}

/* Round white play badge: sm for thumbnails, lg for the main view */
function PlayBadge({ size = 'sm' }: { size?: 'sm' | 'lg' }) {
  return (
    <span
      className={cn(
        'absolute inset-0 m-auto flex items-center justify-center rounded-full bg-surface/95 text-text shadow-sm pointer-events-none',
        size === 'sm' ? 'w-10 h-10' : 'w-16 h-16'
      )}
    >
      <Play className={cn('fill-current', size === 'sm' ? 'w-4 h-4' : 'w-7 h-7')} />
    </span>
  );
}

/* Thumbnail visual (image, video poster, or first video frame) */
function ThumbMedia({ item }: { item: MediaItem }) {
  if (item.type === 'video' && !item.poster) {
    return (
      <video
        src={`${item.src}#t=0.1`}
        preload="metadata"
        muted
        playsInline
        className="w-full h-full object-cover"
      />
    );
  }
  return (
    <img
      src={item.type === 'video' ? item.poster : item.src}
      alt=""
      className="w-full h-full object-cover"
    />
  );
}

/* Plain button (no <Button>) so nothing overrides positioning */
function ArrowButton({
  direction,
  onClick,
  className,
}: {
  direction: 'prev' | 'next';
  onClick: (e: React.MouseEvent) => void;
  className?: string;
}) {
  const Icon = direction === 'prev' ? ChevronLeft : ChevronRight;
  return (
    <button
      type="button"
      aria-label={direction === 'prev' ? 'Previous' : 'Next'}
      onClick={onClick}
      className={cn(
        'absolute top-1/2 -translate-y-1/2 z-20 w-12 h-12 bg-bg border flex items-center justify-center',
        'bg-surface text-text hover:bg-surface-2 transition-colors',
        className
      )}
    >
      <Icon className="w-6 h-6" />
    </button>
  );
}

export function ProductGallery({ images, productName }: ProductGalleryProps) {
  const [activeIndex, setActiveIndex] = useState(0);
  const [isLightboxOpen, setIsLightboxOpen] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);

  const items: MediaItem[] = useMemo(
    () =>
      (images ?? []).map((m) =>
        typeof m === 'string' ? { type: 'image' as const, src: m } : m
      ),
    [images]
  );

  const count = items.length;

  // Keep index valid if the image list changes (e.g. variant switch)
  useEffect(() => {
    setActiveIndex((i) => (i >= count ? 0 : i));
  }, [count]);

  const handleNext = useCallback(
    (e?: React.MouseEvent) => {
      e?.stopPropagation();
      setActiveIndex((prev) => (prev === count - 1 ? 0 : prev + 1));
    },
    [count]
  );

  const handlePrev = useCallback(
    (e?: React.MouseEvent) => {
      e?.stopPropagation();
      setActiveIndex((prev) => (prev === 0 ? count - 1 : prev - 1));
    },
    [count]
  );

  // Stop video when switching slides
  useEffect(() => {
    setIsPlaying(false);
  }, [activeIndex]);

  useEffect(() => {
    if (!isLightboxOpen) return;
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'ArrowRight') handleNext();
      if (e.key === 'ArrowLeft') handlePrev();
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isLightboxOpen, handleNext, handlePrev]);

  if (count === 0) {
    return (
      <div className="aspect-[4/3] bg-surface-2 rounded-3xl flex items-center justify-center">
        <span className="text-text-muted">No image available</span>
      </div>
    );
  }

  const active = items[activeIndex] ?? items[0];

  /* Active media. Always absolutely fills its (relative) parent. */
  const renderActive = () => {
    const fill = 'absolute inset-0 w-full h-full object-contain';

    if (active.type === 'video') {
      if (isPlaying) {
        return (
          <video
            src={active.src}
            poster={active.poster}
            controls
            autoPlay
            playsInline
            className={cn(fill, 'bg-black')}
          />
        );
      }
      return (
        <>
          {active.poster ? (
            <img src={active.poster} alt={productName} className={fill} />
          ) : (
            <video
              src={`${active.src}#t=0.1`}
              preload="metadata"
              muted
              playsInline
              className={fill}
            />
          )}
          <button
            type="button"
            aria-label="Play video"
            onClick={() => setIsPlaying(true)}
            className="absolute inset-0 z-10"
          >
            <PlayBadge size="lg" />
          </button>
        </>
      );
    }
    return <img src={active.src} alt={productName} className={fill} />;
  };

  return (
    <div className="flex flex-col-reverse lg:flex-row gap-4 w-full min-w-0 lg:h-[600px]">
      {/* Thumbnails (left on desktop, bottom on mobile) */}
      {count > 1 && (
        <div className="flex lg:flex-col gap-3 shrink-0 min-h-0 overflow-x-auto lg:overflow-x-hidden lg:overflow-y-auto lg:w-[100px] lg:h-full snap-x lg:snap-y hide-scrollbar">
          {items.map((item, idx) => (
            <button
              key={idx}
              type="button"
              onClick={() => setActiveIndex(idx)}
              aria-label={`${productName} ${item.type} ${idx + 1}`}
              className={cn(
                'relative aspect-square w-20 lg:w-full shrink-0 snap-center rounded-2xl overflow-hidden transition-all bg-surface',
                activeIndex === idx
                  ? 'border-2 border-text p-1'
                  : 'border border-border p-0 hover:border-text-muted'
              )}
            >
              <div className="relative w-full h-full rounded-xl overflow-hidden bg-surface-2">
                <ThumbMedia item={item} />
                {item.type === 'video' && <PlayBadge size="sm" />}
              </div>
            </button>
          ))}
        </div>
      )}

      {/* Main media container */}
      <div className="relative flex-1 min-w-0 aspect-[4/3] lg:aspect-auto lg:h-full bg-surface-2 rounded-3xl overflow-hidden">
        {renderActive()}

        {/* Top-right actions */}
        <div className="absolute top-4 right-4 flex gap-3 z-20">
          <Dialog open={isLightboxOpen} onOpenChange={setIsLightboxOpen}>
            <DialogTrigger
              render={
                <Button
                  variant="secondary"
                  size="icon"
                  aria-label="Open gallery"
                  className="w-12 h-12 bg-bg border shadow-sm hover:bg-surface-2 text-text"
                >
                  <Maximize2 className="w-5 h-5" />
                </Button>
              }
            />
            <DialogContent
              showCloseButton={false}
              className="w-[95vw] max-w-[95vw] sm:max-w-[95vw] h-[95vh] max-h-[1000px] flex flex-col p-0 gap-0 overflow-hidden bg-surface rounded-3xl"
            >
              {/* Header */}
              <div className="relative flex items-center justify-center px-6 py-4 shrink-0">
                <h2 className="text-lg font-bold text-text">
                  Gallery ({activeIndex + 1} of {count})
                </h2>
                <DialogClose
                  render={
                    <button
                      type="button"
                      aria-label="Close gallery"
                      className="absolute right-4 top-1/2 -translate-y-1/2 w-10 h-10 flex items-center justify-center rounded-full bg-surface-2 hover:bg-border text-text transition-colors"
                    >
                      <X className="w-5 h-5" />
                    </button>
                  }
                />
              </div>

              {/* Content */}
              <div className="flex flex-1 min-h-0 min-w-0 flex-col lg:flex-row gap-4 lg:gap-6 px-4 lg:px-6 pb-4 lg:pb-6">
                {/* Left: main media */}
                <div className="relative flex-1 min-w-0 min-h-0 bg-surface-2 rounded-3xl overflow-hidden">
                  {renderActive()}

                  {count > 1 && (
                    <>
                      <ArrowButton direction="prev" onClick={handlePrev} className="left-4 lg:left-6" />
                      <ArrowButton direction="next" onClick={handleNext} className="right-4 lg:right-6" />
                    </>
                  )}
                </div>

                {/* Right: thumbnail grid */}
                <div className="w-full lg:w-[300px] xl:w-[400px] shrink-0 max-h-40 lg:max-h-none lg:h-full min-h-0 overflow-y-auto hide-scrollbar">
                  <div className="grid grid-cols-2 gap-3">
                    {items.map((item, idx) => (
                      <button
                        key={idx}
                        type="button"
                        onClick={() => setActiveIndex(idx)}
                        aria-label={`${productName} ${item.type} ${idx + 1}`}
                        className={cn(
                          'relative rounded-3xl overflow-hidden border-2 transition-all bg-surface-2',
                          idx % 3 === 0 ? 'col-span-2 aspect-[4/5]' : 'col-span-1 aspect-square',
                          activeIndex === idx ? 'border-text p-1.5' : 'border-transparent p-0'
                        )}
                      >
                        <div className="relative w-full h-full rounded-[20px] overflow-hidden">
                          <ThumbMedia item={item} />
                          {item.type === 'video' && <PlayBadge size="sm" />}
                        </div>
                      </button>
                    ))}
                  </div>
                </div>
              </div>
            </DialogContent>
          </Dialog>

          <Button
            variant="secondary"
            className="h-12 bg-bg border shadow-sm hover:bg-surface-2 text-text px-4 font-medium flex items-center gap-2"
          >
            <span className="text-sm">5.9K</span>
            <Heart className="w-5 h-5" />
          </Button>
        </div>

        {/* Navigation arrows, inside the image area */}
        {count > 1 && (
          <>
            <ArrowButton direction="prev" onClick={handlePrev} className="left-4" />
            <ArrowButton direction="next" onClick={handleNext} className="right-4" />
          </>
        )}
      </div>
    </div>
  );
}