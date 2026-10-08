"use client";

import React from 'react';
import { ReviewSummary } from '../types';
import { Star } from 'lucide-react';
import { Progress } from '@/components/ui/progress';

interface ReviewHistogramProps {
  summary: ReviewSummary;
  onFilterByRating?: (rating: number) => void;
}

export function ReviewHistogram({ summary, onFilterByRating }: ReviewHistogramProps) {
  const { averageRating, totalReviews, histogram } = summary;

  return (
    <div className="flex flex-col md:flex-row gap-8 items-start">
      <div className="flex flex-col items-center justify-center min-w-[150px] space-y-2">
        <h3 className="text-4xl font-bold">{averageRating.toFixed(1)}</h3>
        <div className="flex items-center">
          {Array.from({ length: 5 }).map((_, i) => (
            <Star
              key={i}
              className={`w-5 h-5 ${i < Math.round(averageRating) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`}
            />
          ))}
        </div>
        <p className="text-sm text-muted-foreground">{totalReviews} {totalReviews === 1 ? 'review' : 'reviews'}</p>
      </div>

      <div className="flex-1 w-full space-y-2">
        {[5, 4, 3, 2, 1].map((star) => {
          const count = histogram[star as keyof typeof histogram] || 0;
          const percentage = totalReviews > 0 ? (count / totalReviews) * 100 : 0;
          return (
            <div 
              key={star} 
              className="flex items-center gap-3 cursor-pointer group"
              onClick={() => onFilterByRating && onFilterByRating(star)}
            >
              <div className="flex items-center gap-1 w-12 text-sm text-muted-foreground group-hover:text-primary">
                <span>{star}</span>
                <Star className="w-3 h-3 fill-current" />
              </div>
              <Progress value={percentage} className="h-2 flex-1" />
              <div className="w-8 text-xs text-right text-muted-foreground">{count}</div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
