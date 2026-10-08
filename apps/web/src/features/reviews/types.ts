export type ReviewStatus = 'Pending' | 'Published' | 'Rejected' | 'Reported';

export interface MerchantReply {
  body: string;
  createdAt: string;
}

export interface Review {
  id: string;
  productId: string;
  merchantId: string;
  authorId: string;
  authorAlias: string;
  authorAvatar?: string;
  verifiedPurchase: boolean;
  rating: number; // 1 to 5
  title?: string;
  body: string;
  photos: string[]; // URLs
  variantBought?: string;
  status: ReviewStatus;
  helpfulVotes: number;
  createdAt: string;
  updatedAt: string;
  rejectReason?: string;
  reportReason?: string;
  merchantReply?: MerchantReply;
}

export interface ReviewSummary {
  averageRating: number;
  totalReviews: number;
  histogram: {
    1: number;
    2: number;
    3: number;
    4: number;
    5: number;
  };
}

export interface SellerRating {
  merchantId: string;
  itemAsDescribed: number;
  communication: number;
  deliverySpeed: number;
  totalRatings: number;
  averageScore: number;
  isNewSeller: boolean;
}

export interface ReviewListResponse {
  data: Review[];
  total: number;
  page: number;
  limit: number;
  summary: ReviewSummary;
}

export interface ModerationReviewListResponse {
  data: Review[];
  total: number;
  page: number;
  limit: number;
}
