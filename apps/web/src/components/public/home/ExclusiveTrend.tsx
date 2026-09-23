"use client";
import React from 'react';
import Slider from 'react-slick';
import { PublicProduct } from '@/services/mock/public.service';

interface ExclusiveTrendProps {
  products: PublicProduct[];
}

export function ExclusiveTrend({ products }: ExclusiveTrendProps) {
  const trendingProducts = products.filter(p => p.isTrending);

  const sliderSettings = {
    dots: false,
    infinite: true,
    speed: 500,
    slidesToShow: 4,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 3200,
    responsive: [
      { breakpoint: 1024, settings: { slidesToShow: 3 } },
      { breakpoint: 768, settings: { slidesToShow: 2 } },
      { breakpoint: 640, settings: { slidesToShow: 1 } }
    ]
  };

  return (
    <div className="container ratio_square bag-product">
      <section className="section-b-space border-section border-top-0">
        <div className="row">
          <div className="col">
            <div className="title2">
              <h4>trend</h4>
              <h2 className="title-inner2">exclusive items</h2>
            </div>
            <Slider {...sliderSettings} className="product-4 product-m no-arrow">
              {trendingProducts.map((product) => (
                <div key={`trend-${product.id}`}>
                  <div className="basic-product theme-product-5">
                    <div className="img-wrapper">
                      <a href={`/product/${product.id}`}><img alt={product.name} className="img-fluid  lazyload" src={product.imageUrl} /></a>
                      <div className="cart-info">
                        <button onClick={() => console.log('openCart')} title="Add to cart"><i className="ri-shopping-cart-line"></i></button>
                      </div>
                    </div>
                    <div className="product-detail">
                      <div className="brand-w-color">
                        <a className="product-title" href={`/product/${product.id}`}>{product.brand}</a>
                      </div>
                      <h6>{product.name}</h6>
                      <h4 className="price">₦{product.price.toLocaleString()}</h4>
                    </div>
                  </div>
                </div>
              ))}
            </Slider>
          </div>
        </div>
      </section>
    </div>
  );
}
