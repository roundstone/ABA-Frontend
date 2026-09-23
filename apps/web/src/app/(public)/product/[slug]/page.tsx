import Breadcrumb from '@/components/ui/Breadcrumb';
import { PRODUCTS } from '@/data/products';
import { notFound } from 'next/navigation';
import ProductGallery from '@/components/product/ProductGallery';
import ProductInfo from '@/components/product/ProductInfo';
import ProductTabs from '@/components/product/ProductTabs';
import ProductModals from '@/components/product/ProductModals';
import ProductSidebar from '@/components/product/ProductSidebar';
import RelatedProducts from '@/components/product/RelatedProducts';

export const metadata = {
  title: 'Product - Multikart',
  description: 'Product details',
};

export default async function ProductPage({ params }: { params: Promise<{ slug: string }> }) {
  const resolvedParams = await params;
  const product = PRODUCTS.find(p => p.id === resolvedParams.slug);

  if (!product) {
    notFound();
  }

  const galleryImages = [
    product.image,
    '/images/pro3/1.jpg',
    '/images/pro3/2.jpg',
    '/images/pro3/3.jpg'
  ];

  return (
    <>
      <Breadcrumb
        title={product.name}
        items={[{ label: 'Home', url: '/' }, { label: 'Shop', url: '/shop' }, { label: product.name }]}
      />
      
      <section>
        <div className="collection-wrapper">
          <div className="container">
            <div className="row g-sm-4">
              <div className="col-12">
                <ProductGallery images={galleryImages} />
              </div>
              <div className="col-12">
                <div className="row">
                  <div className="col-xxl-9 col-lg-8">
                    <ProductInfo product={product} />
                    <ProductTabs />
                  </div>
                  <ProductSidebar />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <RelatedProducts products={PRODUCTS.filter(p => p.id !== product.id)} />
      <ProductModals />
    </>
  );
}

