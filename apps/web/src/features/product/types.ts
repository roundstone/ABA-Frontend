import { ShopProduct } from "../shop/types";

export interface ProductDetail extends ShopProduct {
  id: string;
  slug: string;
  name: string;
  description: string;
  price: number;
  originalPrice?: number;
  image: string;
  images: string[];
  inStock: boolean;
  stockQuantity: number;
  sku: string;
  rating: number;
  reviewCount: number;
  categoryId: string;
  categoryName: string;
  merchantId: string;
  merchantName: string;
}
