import { z } from 'zod';

export const reviewSchema = z.object({
  rating: z.number().min(1).max(5),
  title: z.string().max(80).optional(),
  body: z.string().min(20, 'Review body must be at least 20 characters').max(2000, 'Review body must not exceed 2000 characters'),
  photos: z.array(z.string().url()).max(3).optional(),
});

export type ReviewFormValues = z.infer<typeof reviewSchema>;

export const sellerRatingSchema = z.object({
  itemAsDescribed: z.number().min(1).max(5),
  communication: z.number().min(1).max(5),
  deliverySpeed: z.number().min(1).max(5),
});

export type SellerRatingFormValues = z.infer<typeof sellerRatingSchema>;

export const rejectReviewSchema = z.object({
  reason: z.string().min(10, 'Reason must be at least 10 characters'),
});

export type RejectReviewFormValues = z.infer<typeof rejectReviewSchema>;

export const replyReviewSchema = z.object({
  body: z.string().min(10, 'Reply must be at least 10 characters').max(1000),
});

export type ReplyReviewFormValues = z.infer<typeof replyReviewSchema>;

export const reportReviewSchema = z.object({
  reason: z.string().min(10, 'Reason must be at least 10 characters').max(500),
});

export type ReportReviewFormValues = z.infer<typeof reportReviewSchema>;
