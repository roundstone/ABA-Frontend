import { API_MODE, fetchApi } from '@/lib/api';
import { mockShopProducts } from '@/features/shop/mocks';
import { CreateProductInput } from '../schemas';
import { Product, ProductVariant } from '../types';

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));
const MOCK_PRODUCTS = mockShopProducts;

type BackendVariant = {
  id: number | string;
  name: string;
  sku: string;
  barcode?: string | null;
  price: string | number;
  cost_price?: string | number | null;
  is_active: boolean;
  attributes?: Record<string, string> | null;
};

type BackendProduct = {
  id: number | string;
  name: string;
  slug: string;
  description?: string | null;
  brand?: string | null;
  base_cost_price?: string | number | null;
  base_selling_price?: string | number | null;
  base_unit_of_measurement?: string | null;
  type?: Product['type'] | null;
  reorder_level?: number;
  reorder_quantity?: number;
  is_active: boolean;
  category?: { id: number; name: string } | null;
  variants?: BackendVariant[];
  updatedAt?: string;
  updated_at?: string;
};

type PaginatedProducts = { data: BackendProduct[] };

export type ProductOverview = {
  totalProducts: number;
  activeProducts: number;
  lowStock: number;
  outOfStock: number;
};

const numberValue = (value?: string | number | null) =>
  value === null || value === undefined ? 0 : Number(value);

function toVariant(variant: BackendVariant): ProductVariant {
  return {
    id: String(variant.id),
    name: variant.name,
    sku: variant.sku,
    barcode: variant.barcode ?? undefined,
    price: numberValue(variant.price),
    cost: numberValue(variant.cost_price),
    reorderLevel: 0,
    images: [],
    isActive: variant.is_active,
    stockCount: 0,
    attributes: variant.attributes
      ? Object.entries(variant.attributes).map(([name, value]) => ({ name, type: 'text', value }))
      : undefined,
  };
}

function toProduct(product: BackendProduct): Product {
  const variants = product.variants?.map(toVariant) ?? [];
  const price = numberValue(product.base_cost_price) || variants[0]?.cost || 0;
  const sellingPrice = numberValue(product.base_selling_price) || variants[0]?.price || 0;

  return {
    id: String(product.id),
    slug: product.slug,
    name: product.name,
    // The backend catalog does not yet persist a base-product SKU or price.
    sku: product.slug.toUpperCase(),
    type: product.type ?? 'Finished good',
    categoryName: product.category?.name ?? 'Uncategorized',
    category: product.category
      ? { id: String(product.category.id), name: product.category.name } as Product['category']
      : undefined,
    brand: product.brand ?? undefined,
    description: product.description ?? undefined,
    unitOfMeasure: product.base_unit_of_measurement ?? 'unit',
    status: product.is_active ? 'Active' : 'Draft',
    images: [],
    price,
    sellingPrice,
    priceIncludesTax: true,
    hasVariants: variants.length > 0,
    variants,
    trackInventory: false,
    reorderLevel: product.reorder_level ?? 0,
    reorderQuantity: product.reorder_quantity ?? 0,
    allowBackorder: false,
    isCommissionable: false,
    totalStock: 0,
    updatedAt: product.updatedAt ?? product.updated_at ?? new Date().toISOString(),
    rating: 0,
    reviewCount: 0,
  };
}

export const getProducts = async (): Promise<{ data: Product[] }> => {
  if (API_MODE !== 'mock') {
    const response = await fetchApi<PaginatedProducts>('/api/v1/products?limit=100&includeVariants=true');
    return { data: response.data.map(toProduct) };
  }

  await delay(500);
  return { data: MOCK_PRODUCTS };
};

export const getProductOverview = async (): Promise<ProductOverview> => {
  if (API_MODE !== 'mock') {
    return fetchApi<ProductOverview>('/api/v1/products/overview');
  }

  await delay(250);
  return {
    totalProducts: MOCK_PRODUCTS.length,
    activeProducts: MOCK_PRODUCTS.filter((product) => product.status === 'Active').length,
    lowStock: MOCK_PRODUCTS.filter(
      (product) => product.totalStock > 0 && product.totalStock <= product.reorderLevel,
    ).length,
    outOfStock: MOCK_PRODUCTS.filter((product) => product.totalStock === 0).length,
  };
};

export const getProductById = async (id: string): Promise<Product> => {
  if (API_MODE !== 'mock') {
    const product = await fetchApi<BackendProduct>(`/api/v1/products/${encodeURIComponent(id)}`);
    return toProduct(product);
  }

  await delay(500);
  const product = MOCK_PRODUCTS.find((item) => item.id === id);
  if (!product) throw new Error('Product not found');
  return product;
};

export const createProduct = async (data: CreateProductInput): Promise<Product> => {
  if (API_MODE !== 'mock') {
    const product = await fetchApi<BackendProduct>('/api/v1/products', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        categoryId: Number(data.categoryId),
        vendorId: data.vendorId ? Number(data.vendorId) : undefined,
        name: data.name,
        description: data.description || undefined,
        brand: data.brand || undefined,
        isActive: data.status === 'Active',
        baseCostPrice: String(data.cost),
        baseSellingPrice: String(data.sellingPrice),
        baseUnitOfMeasurement: data.unitOfMeasure,
        type: data.type,
        reorderLevel: data.reorderLevel,
        reorderQuantity: data.reorderQuantity,
      }),
    });

    if (data.hasVariants && data.variants?.length) {
      await Promise.all(data.variants.map((variant) => fetchApi<BackendVariant>(
        `/api/v1/products/${product.id}/variants`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            name: variant.name,
            barcode: variant.barcode || undefined,
            price: String(variant.price),
            variantCostPrice: String(variant.cost),
            variantSellingPrice: String(variant.price),
            isActive: variant.isActive,
          }),
        },
      )));
    }

    return getProductById(String(product.id));
  }

  await delay(1000);
  const newProduct: Product = {
    id: `prod-${Date.now()}`,
    ...data,
    sku: `PRODUCT-${Date.now()}`,
    price: data.cost,
    variants: data.variants?.map((variant, index) => ({
      ...variant,
      id: `variant-${Date.now()}-${index}`,
      sku: `VAR-${Date.now()}-${index + 1}`,
      images: [],
      stockCount: 0,
    })) ?? [],
    images: data.images ?? [],
    totalStock: 0,
    updatedAt: new Date().toISOString(),
    categoryName: '',
    rating: 0,
    reviewCount: 0,
  };
  MOCK_PRODUCTS.unshift(newProduct);
  return newProduct;
};
