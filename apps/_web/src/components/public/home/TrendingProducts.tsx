"use client";
import React, { useState } from 'react';
import Slider from 'react-slick';
import { PublicProduct, PublicCategory } from '@/services/mock/public.service';
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";

interface TrendingProductsProps {
  products: PublicProduct[];
  categories: PublicCategory[];
}

export function TrendingProducts({ products, categories }: TrendingProductsProps) {
  const [activeTab, setActiveTab] = useState<string>(categories.length > 0 ? categories[0].id : '');

  const sliderSettings = {
    dots: false,
    infinite: true,
    speed: 500,
    slidesToShow: 4,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 3000,
    responsive: [
      { breakpoint: 1024, settings: { slidesToShow: 3 } },
      { breakpoint: 768, settings: { slidesToShow: 2 } },
      { breakpoint: 640, settings: { slidesToShow: 1 } }
    ]
  };

  return (
    <section className="section-b-space ratio_square bag-product">
      <div className="container">
        <div className="title2">
          <h4>new collection</h4>
          <h2 className="title-inner2">trending products</h2>
        </div>
        <div className="row">
          <div className="col">
            <div className="theme-tab">
              <ul className="tabs tab-title">
                {categories.slice(0, 3).map((cat) => (
                  <li key={cat.id} className={activeTab === cat.id ? 'current' : ''}>
                    <a href="#!" onClick={(e) => { e.preventDefault(); setActiveTab(cat.id); }}>{cat.name}</a>
                  </li>
                ))}
              </ul>
              <div className="tab-content-cls">
                <div className="tab-content active default">
                  <Slider {...sliderSettings} className="product-4 product-m no-arrow">
                    {products.map((product) => (
                      <div key={product.id}>
                        <div className="basic-product theme-product-5">
                          <div className="img-wrapper">
                            <a href={`/product/${product.id}`}>
                              <img alt={product.name} className="img-fluid  lazyload" src={product.imageUrl} />
                            </a>
                            <div className="cart-info">
                              <button onClick={() => console.log('openCart')} title="Add to cart"><i className="ri-shopping-cart-line"></i></button>
                              <a href="#!" title="Add to Wishlist"><i className="ri-heart-line"></i></a>
                              <a data-bs-toggle="modal" href="#quickView" title="Quick View"><i className="ri-eye-line"></i></a>
                              <a href="#!" title="Compare"><i className="ri-loop-left-line"></i></a>
                            </div>
                            {product.isTrending && <label className="rotate-label">Trending</label>}
                          </div>
                          <div className="product-detail">
                            <div className="brand-w-color">
                              <a className="product-title" href={`/product/${product.id}`}>{product.brand}</a>
                              <div className="rating-w-count mb-0 d-sm-inline-flex d-none">
                                <div className="rating">
                                  {[...Array(5)].map((_, i) => (
                                    <i key={`star-${i}`} className={i < product.rating ? "ri-star-fill" : "ri-star-line"}></i>
                                  ))}
                                </div>
                                <span>({product.reviewCount})</span>
                              </div>
                            </div>
                            <h6>{product.name}</h6>
                            <h4 className="price">
                              ₦{product.price.toLocaleString()}
                              {product.originalPrice && <del> ₦{product.originalPrice.toLocaleString()} </del>}
                              {product.discountPercentage && <span className="discounted-price"> {product.discountPercentage}% Off </span>}
                            </h4>
                          </div>
                        </div>
                      </div>
                    ))}
                  </Slider>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
