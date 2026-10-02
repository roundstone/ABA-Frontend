import { ApiError } from '@/lib/api';
import { mockShopMerchants, mockShopProducts } from './mocks';
import { Merchant } from '../merchants/types';
import { Category } from '../category/types';
import { Product } from '../products/types';
import { mockShopCategories } from '../category/mocks';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getShopCategories(): Promise<{ data: Category[] }> {
  await delay(400);
  return { data: mockShopCategories };
}

export async function getShopMerchants(): Promise<{ data: Merchant[] }> {
  await delay(400);
  return { data: mockShopMerchants };
}

export async function getShopProducts(params?: { categorySlug?: string; merchantId?: string }): Promise<{ data: Product[] }> {
  await delay(600);
  let products = [...mockShopProducts];

  if (params?.categorySlug) {
    products = products.filter(p => p.category?.slug === params.categorySlug);
  }
  if (params?.merchantId) {
    products = products.filter(p => p.merchant?.id === params.merchantId);
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
