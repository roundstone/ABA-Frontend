import { mockShopProducts } from '@/features/shop/mocks';
import { ShopProduct } from '@/features/shop/types';
import { Product } from '../types';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_PRODUCTS = mockShopProducts;

export const getProducts = async (): Promise<{ data: Product[] }> => {
  await delay(500);
  return { data: MOCK_PRODUCTS };
};

export const getProductById = async (id: string): Promise<Product> => {
  await delay(500);
  const prod = MOCK_PRODUCTS.find(p => p.id === id);
  if (!prod) throw new Error('Product not found');
  return prod;
};

export const createProduct = async (data: any): Promise<Product> => {
  await delay(1000);
  const newProduct: Product = {
    id: `prod-${Date.now()}`,
    ...data,
    totalStock: 0,
    updatedAt: new Date().toISOString(),
  };
  MOCK_PRODUCTS.unshift(newProduct);
  return newProduct;
};
