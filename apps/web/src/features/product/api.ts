import { ApiError } from '@/lib/api';
import { Product } from '../products/types';
import { mockShopProducts } from '../shop/mocks';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getProductDetailBySlug(slug: string): Promise<{ data: Product }> {
  await delay(500);
  const product = mockShopProducts.find(p => p.slug === slug || p.id === slug);
  if (!product) {
    throw new ApiError(404, 'Product not found', 'NOT_FOUND');
  }
  return { data: product as unknown as Product };
}

export async function getRelatedProducts(categoryId: string, excludeId: string): Promise<{ data: Product[] }> {
  await delay(500);
  const products = mockShopProducts.filter(p => p.id !== excludeId && p.status === 'Active' && p.category?.id === categoryId);
  return { data: products as unknown as Product[] };
}

export async function getMerchantProducts(merchantId: string, excludeId: string): Promise<{ data: Product[] }> {
  await delay(500);
  const products = mockShopProducts.filter(p => p.id !== excludeId && p.status === 'Active' && p.merchant?.id === merchantId);
  return { data: products as unknown as Product[] };
}
