'use client';

import { useQuery } from '@tanstack/react-query';
import { Loader2 } from 'lucide-react';
import { getShopProducts } from '@/features/shop/api';
import { ProductCard } from '@/components/storefront/ProductCard';
import { ItemCarousel } from '@/components/patterns/ItemCarousel';
import { Skeleton } from '@/components/ui/skeleton';
import { storefrontConfig } from '@/config/storefront';

interface ProductCarouselSectionProps {
  title: string;
  sliceStart: number;
  sliceEnd: number;
}

export function ProductCarouselSection({ title, sliceStart, sliceEnd }: ProductCarouselSectionProps) {
  const { data, isLoading, isError } = useQuery({
    queryKey: ['shop_products_carousel', title],
    queryFn: async () => (await getShopProducts({})).data
  });

  if (isError || (!isLoading && (!data || data.length === 0))) return null;

  return (
    <div className="mb-12">
      <div>
        <h2 id="meet-businesses-heading" className="text-2xl md:text-3xl font-extrabold text-brand-900 tracking-tight">
          {title}
        </h2>
        <p className="mt-1 text-text-muted">Connect directly with the makers and sellers behind every product.</p>
      </div>
      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4" aria-busy="true">
          {[0, 1, 2, 3].map(i => <Skeleton key={i} className="h-64 rounded-2xl" />)}
        </div>
      ) : (
        <ItemCarousel
          label="Featured businesses"
          autoplay={storefrontConfig.meetBusinesses.autoplay}
          autoplayIntervalMs={storefrontConfig.meetBusinesses.autoplayIntervalMs}
        >
          {data!.slice(sliceStart, sliceEnd).map(m => <ProductCard key={m.id} product={m} />)}
        </ItemCarousel>
      )}
    </div>
  );
}
