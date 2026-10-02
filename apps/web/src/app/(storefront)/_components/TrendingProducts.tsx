import { getProducts } from '@/features/products/api/products.api';
import { ProductCard } from '@/components/storefront/ProductCard';

export async function TrendingProducts() {
  const products = await getProducts();

  return (
    <section className="bg-surface-1 py-16 animate-in fade-in slide-in-from-bottom-4 duration-700">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 className="text-2xl font-bold text-brand-900 mb-8 text-center">Trending on ABA Online</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
          {products?.data?.slice(1, 5).map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      </div>
    </section>
  );
}
