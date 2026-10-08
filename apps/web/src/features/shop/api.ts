import { ApiError } from '@/lib/api';
import { mockShopMerchants, mockShopProducts } from './mocks';
import { Merchant } from '../merchants/types';
import { Category } from '../category/types';
import { Product } from '../products/types';
import { mockShopCategories } from '../category/mocks';
import { DirectoryMerchant, DirectoryParams, DirectoryResult } from '../merchants/types';
import { queryDirectory } from '../merchants/directory';
import { storefrontConfig } from '@/config/storefront';
import { maybeInjectMockError } from '@/lib/mockErrors';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getShopCategories(): Promise<{ data: Category[] }> {
  await delay(400);
  return { data: mockShopCategories };
}

export async function getShopMerchants(): Promise<{ data: Merchant[] }> {
  await delay(400);
  // Storefront only lists active merchants (REQ-06-266).
  return { data: mockShopMerchants.filter(m => m.status === 'Active') };
}

/** `GET /merchants/directory` : search, filters, sort and pagination of 24 (Doc 06 §6.2). */
export async function getDirectoryMerchants(params: DirectoryParams = {}): Promise<DirectoryResult> {
  await delay(500);
  maybeInjectMockError('directory');
  return queryDirectory(mockShopMerchants, params, {
    pageSize: storefrontConfig.merchantDirectory.pageSize,
    defaultOrder: storefrontConfig.merchantDirectory.defaultOrder,
    spotlight: storefrontConfig.spotlight,
  });
}

/** `GET /merchants/meet-businesses` : spotlight-ordered merchants for the shop landing carousel (Doc 06 §6.1). */
export async function getMeetBusinesses(): Promise<{ data: DirectoryMerchant[] }> {
  const res = await getDirectoryMerchants({ sort: 'recommended', pageSize: storefrontConfig.meetBusinesses.limit });
  return { data: res.data };
}

export async function getShopProducts(params?: { 
  categorySlug?: string; 
  merchantId?: string;
  q?: string;
  minRating?: number;
  inStockOnly?: boolean;
  onSaleOnly?: boolean;
  sort?: 'recommended' | 'newest' | 'price-asc' | 'price-desc' | 'rating';
}): Promise<{ data: Product[] }> {
  await delay(600);
  let products = [...mockShopProducts];

  if (params?.categorySlug) {
    products = products.filter(p => p.category?.slug === params.categorySlug);
  }
  if (params?.merchantId) {
    products = products.filter(p => p.merchant?.id === params.merchantId);
  }
  if (params?.q) {
    const q = params.q.toLowerCase();
    products = products.filter(p => p.name.toLowerCase().includes(q) || p.description?.toLowerCase().includes(q));
  }
  if (params?.minRating) {
    products = products.filter(p => p.rating >= params.minRating!);
  }
  if (params?.inStockOnly) {
    products = products.filter(p => p.totalStock > 0);
  }
  if (params?.onSaleOnly) {
    products = products.filter(p => p.originalPrice && p.originalPrice > p.price);
  }

  if (params?.sort) {
    products.sort((a, b) => {
      switch (params.sort) {
        case 'price-asc': return a.price - b.price;
        case 'price-desc': return b.price - a.price;
        case 'rating': return (b.rating || 0) - (a.rating || 0);
        case 'newest': return new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime();
        default: return 0;
      }
    });
  }

  return { data: products };
}

export async function getShopProductBySlug(slug: string): Promise<{ data: Product }> {
  await delay(400);
  const product = mockShopProducts.find(p => p.slug === slug);
  if (!product) {
    throw new ApiError(404, 'Product not found', 'NOT_FOUND');
  }
  return { data: product };
}
