import React from 'react';
import ProductCard from '@/components/common/ProductCard';

interface RelatedProductsProps {
  products: any[];
}

export default function RelatedProducts({ products }: RelatedProductsProps) {
  if (!products || products.length === 0) return null;

  return (
    <section className="section-b-space ratio_asos">
      <div className="container">
        <div className="title1">
          <h4>recent story</h4>
          <h2 className="title-inner1">related products</h2>
        </div>
        <div className="row">
          {products.slice(0, 6).map((product) => (
            <div key={product.id} className="col-xl-2 col-md-4 col-6">
              <ProductCard product={product} />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
