import { Review, SellerRating, ReviewSummary } from './types';

export const mockReviewSummary: ReviewSummary = {
  averageRating: 4.2,
  totalReviews: 12,
  histogram: {
    1: 1,
    2: 0,
    3: 2,
    4: 3,
    5: 6,
  }
};

export const mockReviews: Review[] = [
  {
    id: 'rev-1',
    productId: 'prod-1',
    merchantId: 'M-123',
    authorId: 'C-001',
    authorAlias: 'Alex D.',
    authorAvatar: 'https://i.pravatar.cc/150?u=a042581f4e29026024d',
    verifiedPurchase: true,
    rating: 5,
    title: 'Excellent product!',
    body: 'I am really impressed with the quality. It exceeded my expectations. Delivery was also very prompt and packaging was secure.',
    photos: [
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=400&q=80'
    ],
    variantBought: 'Color: Black, Size: L',
    status: 'Published',
    helpfulVotes: 14,
    createdAt: new Date(Date.now() - 86400000 * 5).toISOString(),
    updatedAt: new Date(Date.now() - 86400000 * 5).toISOString(),
    merchantReply: {
      body: 'Thank you for your feedback! We are glad you liked it.',
      createdAt: new Date(Date.now() - 86400000 * 4).toISOString(),
    }
  },
  {
    id: 'rev-2',
    productId: 'prod-1',
    merchantId: 'M-123',
    authorId: 'C-002',
    authorAlias: 'Sam K.',
    verifiedPurchase: true,
    rating: 3,
    title: 'Decent, but could be better',
    body: 'The product works fine, but the material feels a bit cheap. For the price, I expected slightly better build quality.',
    photos: [],
    variantBought: 'Color: Silver, Size: M',
    status: 'Published',
    helpfulVotes: 2,
    createdAt: new Date(Date.now() - 86400000 * 12).toISOString(),
    updatedAt: new Date(Date.now() - 86400000 * 12).toISOString(),
  },
  {
    id: 'rev-3',
    productId: 'prod-2',
    merchantId: 'M-123',
    authorId: 'C-003',
    authorAlias: 'Jordan P.',
    verifiedPurchase: false,
    rating: 1,
    title: 'Terrible experience',
    body: 'Never received the item, and customer support was unresponsive. Beware!',
    photos: [],
    status: 'Reported',
    helpfulVotes: 0,
    createdAt: new Date(Date.now() - 86400000 * 2).toISOString(),
    updatedAt: new Date(Date.now() - 86400000 * 2).toISOString(),
    reportReason: 'Customer claims non-delivery, but tracking shows delivered.'
  },
  {
    id: 'rev-4',
    productId: 'prod-3',
    merchantId: 'M-124',
    authorId: 'C-004',
    authorAlias: 'Taylor W.',
    verifiedPurchase: true,
    rating: 4,
    body: 'Really good value for money. Would buy again.',
    photos: [],
    status: 'Pending',
    helpfulVotes: 0,
    createdAt: new Date(Date.now() - 3600000).toISOString(),
    updatedAt: new Date(Date.now() - 3600000).toISOString(),
  }
];

export const mockSellerRating: SellerRating = {
  merchantId: 'M-123',
  itemAsDescribed: 4.5,
  communication: 4.8,
  deliverySpeed: 4.2,
  totalRatings: 145,
  averageScore: 4.5,
  isNewSeller: false,
};
