import { useQuery } from '@tanstack/react-query';
import { getProductReviews, getModerationReviews, ReviewFilters } from './api';

export const reviewKeys = {
  all: ['reviews'] as const,
  product: (productId: string, filters?: ReviewFilters, page?: number) => ['reviews', 'product', productId, filters, page] as const,
  moderation: (filters?: { status?: string }, page?: number) => ['reviews', 'moderation', filters, page] as const,
};

export function useProductReviews(productId: string, filters?: ReviewFilters, page = 1, limit = 10) {
  return useQuery({
    queryKey: reviewKeys.product(productId, filters, page),
    queryFn: () => getProductReviews(productId, filters, page, limit),
  });
}

export function useModerationReviews(filters?: { status?: string }, page = 1, limit = 10) {
  return useQuery({
    queryKey: reviewKeys.moderation(filters, page),
    queryFn: () => getModerationReviews(filters, page, limit),
  });
}
