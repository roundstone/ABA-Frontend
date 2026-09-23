"use client";
import React from 'react';
import Slider from 'react-slick';
import { PublicProduct } from '@/services/mock/public.service';

interface ProductSlidersProps {
  products: PublicProduct[];
}

export function ProductSliders({ products }: ProductSlidersProps) {
  const saleProducts = products.filter(p => p.discountPercentage);

  const singleSlider = {
    dots: false,
    infinite: true,
    speed: 500,
    slidesToShow: 1,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 3000,
  };

  return (
    <section className="ratio_square">
      <div className="container">
        <div className="row g-4 partition_3">
          {/* New Product */}
          <div className="col-lg-4">
            <div className="theme-card card-border">
              <h5 className="title-border">new product</h5>
              <div className="offer-slider slide-1">
                <Slider {...singleSlider}>
                  <div>
                    {products.slice(0, 4).map((p) => (
                      <div className="media" key={`new-${p.id}`}>
                        <a href={`/product/${p.id}`}><img alt={p.name} className="img-fluid  lazyload" src={p.imageUrl} /></a>
                        <div className="media-body align-self-center mt-0">
                          <div className="rating">
                            {[...Array(5)].map((_, i) => <i key={`nstar-${i}`} className={i < p.rating ? "ri-star-fill" : "ri-star-line"}></i>)}
                          </div>
                          <a href={`/product/${p.id}`}><h6>{p.name}</h6></a>
                          <h4>₦{p.price.toLocaleString()}</h4>
                        </div>
                      </div>
                    ))}
                  </div>
                </Slider>
              </div>
            </div>
          </div>

          {/* Center Slider - On Sale */}
          <div className="col-lg-4 center-slider border-0">
            <div>
              <div className="title2 mb-3">
                <h4>on sale</h4>
                <h2 className="title-inner2">season sale</h2>
              </div>
              <div className="offer-slider slide-1">
                <Slider {...singleSlider}>
                  {saleProducts.map((product) => (
                    <div key={`sale-${product.id}`}>
                      <div className="basic-product theme-product-5">
                        <div className="img-wrapper">
                          <a href={`/product/${product.id}`}><img alt={product.name} className="img-fluid  lazyload m-auto" src={product.imageUrl} /></a>
                          <div className="cart-info">
                            <button onClick={() => console.log('openCart')} title="Add to cart"><i className="ri-shopping-cart-line"></i></button>
                            <a href="#!" title="Add to Wishlist"><i className="ri-heart-line"></i></a>
                          </div>
                        </div>
                        <div className="product-detail text-center mt-3">
                          <div className="brand-w-color justify-content-center">
                            <a className="product-title" href={`/product/${product.id}`}>{product.brand}</a>
                          </div>
                          <h6>{product.name}</h6>
                          <h4 className="price">
                            ₦{product.price.toLocaleString()}
                            {product.originalPrice && <del> ₦{product.originalPrice.toLocaleString()} </del>}
                            <span className="discounted-price"> {product.discountPercentage}% Off </span>
                          </h4>
                        </div>
                      </div>
                    </div>
                  ))}
                </Slider>
              </div>
            </div>
          </div>

          {/* Feature Product */}
          <div className="col-lg-4">
            <div className="theme-card card-border">
              <h5 className="title-border">feature product</h5>
              <div className="offer-slider slide-1">
                <Slider {...singleSlider}>
                  <div>
                    {products.slice(4, 8).map((p) => (
                      <div className="media" key={`feat-${p.id}`}>
                        <a href={`/product/${p.id}`}><img alt={p.name} className="img-fluid  lazyload" src={p.imageUrl} /></a>
                        <div className="media-body align-self-center mt-0">
                          <div className="rating">
                            {[...Array(5)].map((_, i) => <i key={`fstar-${i}`} className={i < p.rating ? "ri-star-fill" : "ri-star-line"}></i>)}
                          </div>
                          <a href={`/product/${p.id}`}><h6>{p.name}</h6></a>
                          <h4>₦{p.price.toLocaleString()}</h4>
                        </div>
                      </div>
                    ))}
                  </div>
                </Slider>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
