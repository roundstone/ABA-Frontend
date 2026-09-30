"use client";
import React from 'react';
import { PublicProduct } from '@/services/mock/public.service';

interface ShopProductGridProps {
  products: PublicProduct[];
  isListView: boolean;
  gridClass: string;
}

export function ShopProductGrid({ products, isListView, gridClass }: ShopProductGridProps) {
  if (products.length === 0) {
    return (
      <div className="product-wrapper-grid">
        <div className="row text-center mt-5">
          <div className="col-12">
            <h3>No products found matching your filters.</h3>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className={`product-wrapper-grid ${isListView ? 'list-view' : ''}`}>
      <div className="row g-3 g-sm-4">
        {products.map((product) => (
          <div className={`${gridClass} col-grid-box`} key={product.id}>
            <div className="basic-product theme-product-1">
              <div className="overflow-hidden">
                <div className="img-wrapper">
                  <a href={`/product/${product.id}`}>
                    <img 
                      alt={product.name} 
                      className="w-100 img-fluid lazyload"
                      src={product.imageUrl} 
                      style={{ objectFit: 'cover', aspectRatio: '4/5' }}
                    />
                  </a>
                  <div className="rating-label">
                    <i className="ri-star-fill"></i>
                    <span>{product.rating.toFixed(1)}</span>
                  </div>
                  <div className="cart-info">
                    <a className="wishlist-icon" href="#!" title="Add to Wishlist">
                      <i className="ri-heart-line"></i>
                    </a>
                    <button data-bs-target="#addtocart" data-bs-toggle="modal" title="Add to cart">
                      <i className="ri-shopping-cart-line"></i>
                    </button>
                    <a data-bs-toggle="modal" href="#quickView" title="Quick View">
                      <i className="ri-eye-line"></i>
                    </a>
                    <a href="#!" title="Compare">
                      <i className="ri-loop-left-line"></i>
                    </a>
                  </div>
                </div>
                <div className="product-detail">
                  <div>
                    <div className="brand-w-color">
                      <a className="product-title" href={`/product/${product.id}`}>
                        {product.brand}
                      </a>
                      {product.colors && product.colors.length > 0 && (
                        <div className="color-panel">
                          <ul>
                            {product.colors.slice(0, 3).map((color, i) => (
                              <li key={i} title={color} style={{ backgroundColor: color.toLowerCase() }}></li>
                            ))}
                          </ul>
                          {product.colors.length > 3 && <span>+{product.colors.length - 3}</span>}
                        </div>
                      )}
                    </div>
                    <h6>{product.name}</h6>
                    {isListView && (
                      <p>Experience premium quality with the {product.name}. A top choice in {product.category}, crafted perfectly for everyday use.</p>
                    )}
                    <h4 className="price">
                      ₦{product.price.toLocaleString()}
                      {product.originalPrice && (
                        <>
                          <del> ₦{product.originalPrice.toLocaleString()} </del>
                          {product.discountPercentage && (
                            <span className="discounted-price"> {product.discountPercentage}% Off </span>
                          )}
                        </>
                      )}
                    </h4>
                  </div>
                  <ul className="offer-panel">
                    <li>
                      <span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                      Limited Time Offer: {product.discountPercentage ? `${product.discountPercentage}% off` : 'Free shipping'}
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
