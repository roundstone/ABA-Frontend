import { ApiError } from '@/lib/api';
import { Category } from './types';
import { mockShopCategories } from './mocks';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getCategories(): Promise<{ data: Category[] }> {
  await delay(400);
  return { data: mockShopCategories };
}

export async function getCategoryMenu(): Promise<{ data: Category[] }> {
  await delay(400);
  return { data: mockShopCategories };
}
export async function createCategory(data: Partial<Category>): Promise<{ data: Category }> {
  await delay(800);
  const newCategory: Category = {
    id: `cat-${Date.now()}`,
    name: data.name || '',
    slug: data.slug || '',
    image: data.image,
    productCount: 0,
    sortOrder: 0,
    status: 'active',
    showInMenu: false,
    featuredMerchantIds: []
  };
  // In a real app this would save to the backend.
  // For the mock, we can push to the mockShopCategories array
  mockShopCategories.push(newCategory);
  return { data: newCategory };
}
