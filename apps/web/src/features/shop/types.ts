import { Merchant } from "../merchants/types";

export interface ShopCategory {
  id: string;
  name: string;
  slug: string;
  image?: string;
  productCount: number;
}

// export interface ShopMerchant {
//   id: string;
//   name: string;
//   slug: string;
//   logo: string;
//   rating: number;
//   reviewCount: number;
//   joinedDate: string;
//   isVerified: boolean;
//   description?: string;
// }

export interface ShopProduct {
  id: string;
  slug: string;
  merchantId?: string;
  name: string;
  description: string;
  price: number;
  originalPrice?: number;
  image: string;
  images: string[];
  category: ShopCategory;
  merchant: Merchant;
  inStock: boolean;
  rating: number;
  reviewCount: number;
  attributes: {
    name: string;
    value: string;
  }[];
}
