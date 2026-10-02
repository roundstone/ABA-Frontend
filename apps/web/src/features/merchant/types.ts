import { Merchant } from "../merchants/types";

export interface MerchantProfile extends Merchant { 
  description: string;
  rating: number;
  reviewCount: number;
  joinedDate: string;
  isVerified: boolean;
  totalProducts: number;
  location: string;
}

export interface MerchantReview {
  id: string;
  authorName: string;
  rating: number;
  comment: string;
  date: string;
}
