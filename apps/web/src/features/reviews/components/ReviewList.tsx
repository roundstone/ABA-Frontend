"use client";

import React, { useState } from 'react';
import { useProductReviews } from '../queries';
import { ReviewHistogram } from './ReviewHistogram';
import { ReviewCard } from './ReviewCard';
import { ReviewForm } from './ReviewForm';
import { ReviewFilters } from '../api';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Checkbox } from '@/components/ui/checkbox';
import { Skeleton } from '@/components/ui/skeleton';
import { MessageSquarePlus } from 'lucide-react';

interface ReviewListProps {
  productId: string;
  isEligibleToReview: boolean; // Computed by parent based on order history
  variantBought?: string;      // If they bought a specific variant
}

export function ReviewList({ productId, isEligibleToReview, variantBought }: ReviewListProps) {
  const [page, setPage] = useState(1);
  const [filters, setFilters] = useState<ReviewFilters>({});
  const [sort, setSort] = useState('helpful'); // Most helpful, Newest, Highest, Lowest
  const [showForm, setShowForm] = useState(false);

  const { data: response, isLoading, isError, refetch } = useProductReviews(productId, filters, page, 10);

  const handleFilterChange = (key: keyof ReviewFilters, value: ReviewFilters[keyof ReviewFilters]) => {
    setFilters(prev => ({ ...prev, [key]: value }));
    setPage(1);
  };

  const handleRatingFilter = (rating: number) => {
    handleFilterChange('rating', filters.rating === rating ? undefined : rating);
  };

  if (isError) {
    return (
      <div className="py-8 text-center text-red-500">
        <p>Failed to load reviews.</p>
        <Button variant="outline" onClick={() => refetch()} className="mt-4">Try Again</Button>
      </div>
    );
  }

  // Handle empty state (no reviews at all for this product)
  const isTrulyEmpty = !isLoading && response?.data.total === 0 && Object.keys(filters).length === 0;

  return (
    <div className="space-y-8 py-8" id="reviews">
      <h2 className="text-2xl font-bold tracking-tight">Customer Reviews</h2>

      {isTrulyEmpty ? (
        <div className="bg-gray-50 border border-dashed rounded-lg p-12 flex flex-col items-center justify-center text-center space-y-4">
          <div className="w-16 h-16 bg-white rounded-full flex items-center justify-center shadow-sm">
            <MessageSquarePlus className="w-8 h-8 text-gray-400" />
          </div>
          <div>
            <h3 className="font-semibold text-lg">No reviews yet</h3>
            <p className="text-muted-foreground">Be the first to review this product!</p>
          </div>
          {isEligibleToReview && !showForm && (
            <Button onClick={() => setShowForm(true)} className="mt-2">
              Write a Review
            </Button>
          )}
        </div>
      ) : (
        <>
          {/* Summary and Histogram */}
          {isLoading ? (
            <div className="flex gap-8"><Skeleton className="w-32 h-32" /><Skeleton className="flex-1 h-32" /></div>
          ) : (
            response?.data.summary && (
              <ReviewHistogram 
                summary={response.data.summary} 
                onFilterByRating={handleRatingFilter} 
              />
            )
          )}

          {/* Form Trigger or Form itself */}
          {!showForm && isEligibleToReview && (
            <div className="flex justify-end">
              <Button onClick={() => setShowForm(true)}>Write a Review</Button>
            </div>
          )}

          {showForm && (
            <div className="max-w-2xl mx-auto">
              <ReviewForm 
                productId={productId} 
                variantBought={variantBought} 
                onSuccess={() => setShowForm(false)} 
                onCancel={() => setShowForm(false)} 
              />
            </div>
          )}

          <div className="border-t pt-8 space-y-6">
            {/* Toolbar: Filters and Sort */}
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <div className="flex flex-wrap items-center gap-4">
                <div className="flex items-center space-x-2">
                  <Checkbox 
                    id="withPhotos" 
                    checked={filters.withPhotos || false}
                    onCheckedChange={(c) => handleFilterChange('withPhotos', !!c)}
                  />
                  <label htmlFor="withPhotos" className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
                    With photos
                  </label>
                </div>
                <div className="flex items-center space-x-2">
                  <Checkbox 
                    id="verified" 
                    checked={filters.verified || false}
                    onCheckedChange={(c) => handleFilterChange('verified', !!c)}
                  />
                  <label htmlFor="verified" className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
                    Verified purchases only
                  </label>
                </div>
                {filters.rating && (
                  <Button variant="outline" size="sm" onClick={() => handleFilterChange('rating', undefined)} className="h-8">
                    {filters.rating} Stars ✕
                  </Button>
                )}
              </div>

              <div className="flex items-center gap-2">
                <span className="text-sm text-muted-foreground">Sort by:</span>
                <Select value={sort} onValueChange={(v: string | null) => setSort(v || 'helpful')}>
                  <SelectTrigger className="w-[160px] h-9">
                    <SelectValue placeholder="Sort reviews" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="helpful">Most helpful</SelectItem>
                    <SelectItem value="newest">Newest</SelectItem>
                    <SelectItem value="highest">Highest rated</SelectItem>
                    <SelectItem value="lowest">Lowest rated</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            {/* List */}
            {isLoading ? (
              <div className="space-y-4">
                <Skeleton className="w-full h-48" />
                <Skeleton className="w-full h-48" />
              </div>
            ) : response?.data.data.length === 0 ? (
              <div className="py-12 text-center text-muted-foreground">
                No reviews match your current filters.
              </div>
            ) : (
              <div className="space-y-4">
                {/* Simplified client side sort for mock purposes */}
                {[...(response?.data.data || [])].sort((a, b) => {
                  if (sort === 'newest') return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
                  if (sort === 'highest') return b.rating - a.rating;
                  if (sort === 'lowest') return a.rating - b.rating;
                  return b.helpfulVotes - a.helpfulVotes;
                }).map(review => (
                  <ReviewCard key={review.id} review={review} />
                ))}
              </div>
            )}

            {/* Pagination Placeholder */}
            {response && response.data.total > response.data.limit && (
              <div className="flex justify-center pt-4">
                <Button variant="outline" disabled={page === 1} onClick={() => setPage(p => p - 1)} className="mr-2">Previous</Button>
                <Button variant="outline" disabled={page * response.data.limit >= response.data.total} onClick={() => setPage(p => p + 1)}>Next</Button>
              </div>
            )}
          </div>
        </>
      )}
    </div>
  );
}
