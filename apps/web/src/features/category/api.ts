import { ApiError } from '@/lib/api';
import { Category } from './types';
import { mockShopCategories } from './mocks';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function createCategory(data: any): Promise<{ data: Category }> {
  await delay(800);
  const newCategory: Category = {
    id: `cat-${Date.now()}`,
    name: data.name,
    slug: data.slug,
    image: data.image,
    productCount: 0,
  };
  // In a real app this would save to the backend.
  // For the mock, we can push to the mockShopCategories array
  mockShopCategories.push(newCategory);
  return { data: newCategory };
}
