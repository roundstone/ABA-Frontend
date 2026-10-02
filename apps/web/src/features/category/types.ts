import { ShopProduct } from "../shop/types";

export interface Category {
  id: string;
  name: string;
  slug: string;
  image?: string;
  productCount: number;
}
