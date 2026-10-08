import { ShopProduct } from "../shop/types";

export interface Category {
  id: string;
  name: string;
  slug: string;
  parentId?: string | null;
  image?: string;
  icon?: string;
  sortOrder: number;
  status: 'active' | 'inactive';
  showInMenu: boolean;
  featuredMerchantIds: string[];
  productCount: number;
  children?: Category[]; // For tree structure
}
