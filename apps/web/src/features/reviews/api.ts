import { Review, ReviewListResponse, ModerationReviewListResponse, SellerRating, ReviewSummary } from './types';
import { mockReviews, mockReviewSummary, mockSellerRating } from './mocks';
import { ReviewFormValues, RejectReviewFormValues, ReplyReviewFormValues, ReportReviewFormValues, SellerRatingFormValues } from './schemas';

// --- Types for mock API simulation ---
interface ApiError {
  message: string;
  status: number;
}

export type ReviewFilters = {
  productId?: string;
  merchantId?: string;
  status?: string;
  rating?: number;
  withPhotos?: boolean;
  verified?: boolean;
};

// --- Mock implementations ---

export async function getProductReviews(productId: string, filters?: ReviewFilters, page = 1, limit = 10): Promise<{ data: ReviewListResponse }> {
  // Simulate delay
  await new Promise(resolve => setTimeout(resolve, 600));

  let filtered = mockReviews.filter(r => r.status === 'Published');
  const exactMatch = filtered.filter(r => r.productId === productId || r.merchantId === productId);
  if (exactMatch.length > 0) {
    filtered = exactMatch;
  }

  if (filters?.rating) {
    filtered = filtered.filter(r => r.rating === filters.rating);
  }
  if (filters?.withPhotos) {
    filtered = filtered.filter(r => r.photos && r.photos.length > 0);
  }
  if (filters?.verified) {
    filtered = filtered.filter(r => r.verifiedPurchase);
  }

  // Generate dynamic summary for this product (mock)
  const summary: ReviewSummary = { ...mockReviewSummary };
  
  const paginated = filtered.slice((page - 1) * limit, page * limit);
  return {
    data: {
      data: paginated,
      total: filtered.length,
      page,
      limit,
      summary
    }
  };
}

export async function submitProductReview(productId: string, data: ReviewFormValues): Promise<{ data: Review }> {
  await new Promise(resolve => setTimeout(resolve, 800));
  
  const newReview: Review = {
    id: `rev-${Date.now()}`,
    productId,
    merchantId: 'M-123', // Hardcoded mock
    authorId: 'C-005',
    authorAlias: 'Current User',
    verifiedPurchase: true,
    rating: data.rating,
    title: data.title,
    body: data.body,
    photos: data.photos || [],
    status: 'Pending',
    helpfulVotes: 0,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  mockReviews.unshift(newReview);
  return { data: newReview };
}

export async function submitSellerRating(merchantId: string, orderId: string, data: SellerRatingFormValues): Promise<{ data: SellerRating }> {
  await new Promise(resolve => setTimeout(resolve, 600));
  return { data: mockSellerRating };
}

export async function voteReviewHelpful(reviewId: string): Promise<{ data: Review }> {
  await new Promise(resolve => setTimeout(resolve, 300));
  const review = mockReviews.find(r => r.id === reviewId);
  if (!review) throw new Error('Review not found');
  
  review.helpfulVotes += 1;
  return { data: review };
}

export async function reportReview(reviewId: string, data: ReportReviewFormValues): Promise<{ data: Review }> {
  await new Promise(resolve => setTimeout(resolve, 600));
  const review = mockReviews.find(r => r.id === reviewId);
  if (!review) throw new Error('Review not found');
  
  review.status = 'Reported';
  review.reportReason = data.reason;
  return { data: review };
}

// --- Admin / Moderation API ---

export async function getModerationReviews(filters?: { status?: string }, page = 1, limit = 10): Promise<{ data: ModerationReviewListResponse }> {
  await new Promise(resolve => setTimeout(resolve, 600));
  
  let filtered = [...mockReviews];
  if (filters?.status && filters.status !== 'All') {
    filtered = filtered.filter(r => r.status === filters.status);
  }

  const paginated = filtered.slice((page - 1) * limit, page * limit);
  
  return {
    data: {
      data: paginated,
      total: filtered.length,
      page,
      limit
    }
  };
}

export async function approveReview(reviewId: string): Promise<{ data: Review }> {
  await new Promise(resolve => setTimeout(resolve, 600));
  const review = mockReviews.find(r => r.id === reviewId);
  if (!review) throw new Error('Review not found');
  
  review.status = 'Published';
  return { data: review };
}

export async function rejectReview(reviewId: string, data: RejectReviewFormValues): Promise<{ data: Review }> {
  await new Promise(resolve => setTimeout(resolve, 600));
  const review = mockReviews.find(r => r.id === reviewId);
  if (!review) throw new Error('Review not found');
  
  review.status = 'Rejected';
  review.rejectReason = data.reason;
  return { data: review };
}

export async function replyToReview(reviewId: string, data: ReplyReviewFormValues): Promise<{ data: Review }> {
  await new Promise(resolve => setTimeout(resolve, 600));
  const review = mockReviews.find(r => r.id === reviewId);
  if (!review) throw new Error('Review not found');
  
  review.merchantReply = {
    body: data.body,
    createdAt: new Date().toISOString()
  };
  return { data: review };
}
