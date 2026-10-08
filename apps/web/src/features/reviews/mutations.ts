import { useMutation, useQueryClient } from '@tanstack/react-query';
import {
  submitProductReview,
  submitSellerRating,
  voteReviewHelpful,
  reportReview,
  approveReview,
  rejectReview,
  replyToReview,
} from './api';
import { reviewKeys } from './queries';
import { 
  ReviewFormValues, 
  SellerRatingFormValues, 
  ReportReviewFormValues, 
  RejectReviewFormValues, 
  ReplyReviewFormValues 
} from './schemas';
import { toast } from 'sonner';

export function useSubmitProductReview() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ productId, data }: { productId: string; data: ReviewFormValues & { variantBought?: string } }) =>
      submitProductReview(productId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: reviewKeys.all });
      toast.success('Review submitted successfully', {
        description: 'Your review has been submitted and is pending moderation.',
      });
    },
    onError: (err: Error) => {
      toast.error('Failed to submit review', {
        description: err.message,
      });
    },
  });
}

export function useSubmitSellerRating() {
  return useMutation({
    mutationFn: ({ merchantId, orderId, data }: { merchantId: string; orderId: string; data: SellerRatingFormValues }) =>
      submitSellerRating(merchantId, orderId, data),
    onSuccess: () => {
      toast.success('Rating submitted successfully', {
        description: 'Thank you for your feedback.',
      });
    },
    onError: (err: Error) => {
      toast.error('Failed to submit rating', {
        description: err.message,
      });
    },
  });
}

export function useVoteReviewHelpful() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: voteReviewHelpful,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: reviewKeys.all });
    },
    onError: (err: Error) => {
      toast.error('Failed to vote', {
        description: err.message,
      });
    },
  });
}

export function useReportReview() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ reviewId, data }: { reviewId: string; data: ReportReviewFormValues }) =>
      reportReview(reviewId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: reviewKeys.all });
      toast.success('Review reported', {
        description: 'Thank you for bringing this to our attention.',
      });
    },
    onError: (err: Error) => {
      toast.error('Failed to report review', {
        description: err.message,
      });
    },
  });
}

export function useApproveReview() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: approveReview,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: reviewKeys.all });
      toast.success('Review approved');
    },
    onError: (err: Error) => {
      toast.error('Failed to approve review', {
        description: err.message,
      });
    },
  });
}

export function useRejectReview() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ reviewId, data }: { reviewId: string; data: RejectReviewFormValues }) =>
      rejectReview(reviewId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: reviewKeys.all });
      toast.success('Review rejected');
    },
    onError: (err: Error) => {
      toast.error('Failed to reject review', {
        description: err.message,
      });
    },
  });
}

export function useReplyToReview() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ reviewId, data }: { reviewId: string; data: ReplyReviewFormValues }) =>
      replyToReview(reviewId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: reviewKeys.all });
      toast.success('Reply posted');
    },
    onError: (err: Error) => {
      toast.error('Failed to post reply', {
        description: err.message,
      });
    },
  });
}
