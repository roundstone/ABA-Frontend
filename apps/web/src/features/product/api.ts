import { ApiError } from '@/lib/api';
import { ProductDetail } from './types';
import { mockShopProducts } from '../shop/mocks';
import { ShopProduct } from '../shop/types';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getProductDetailBySlug(slug: string): Promise<{ data: ProductDetail }> {
  await delay(500);
  const product = mockShopProducts.find(p => p.slug === slug);
  if (!product) {
    throw new ApiError(404, 'Product not found', 'NOT_FOUND');
  }
  return { data: product as unknown as ProductDetail };
}
