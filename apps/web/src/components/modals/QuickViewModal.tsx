'use client';

import { useQuickViewStore } from '@/store/useQuickViewStore';
import { useCartStore } from '@/store/useCartStore';
import { useWishlistStore } from '@/store/useWishlistStore';
import { useState } from 'react';

export default function QuickViewModal() {
  const { product } = useQuickViewStore();
  const { addToCart } = useCartStore();
  const { toggleWishlist } = useWishlistStore();
  const [qty, setQty] = useState(1);

  if (!product) return (
    <div className="modal fade theme-modal-2 quick-view-modal" id="quickView">
      <div className="modal-dialog modal-lg modal-dialog-centered">
        <div className="modal-content">
          <button className="btn-close" data-bs-dismiss="modal" type="button">
            <i className="ri-close-line"></i>
          </button>
          <div className="modal-body"></div>
        </div>
      </div>
    </div>
  );

  return (
    <div className="modal fade theme-modal-2 quick-view-modal" id="quickView">
      <div className="modal-dialog modal-lg modal-dialog-centered">
        <div className="modal-content">
          <button className="btn-close" data-bs-dismiss="modal" type="button">
            <i className="ri-close-line"></i>
          </button>
          <div className="modal-body">
            <div className="wrap-modal-slider">
              <div className="row g-sm-4 g-3">
                <div className="col-lg-6">
                  <div className="row g-3">
                    <div className="col-12">
                      <div className="view-main-slider">
                        <div>
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img alt={product.name} className="img-fluid" src={product.image}/>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="right-sidebar-modal">
                    <a className="name" href={`/product/${product.id}`}>{product.name}</a>
                    <div className="product-rating">
                      <ul className="rating-list">
                        {Array.from({ length: 5 }).map((_, i) => (
                          <li key={i}>
                            <i className={i < (product.rating || 0) ? "ri-star-fill" : "ri-star-line"}></i>
                          </li>
                        ))}
                      </ul>
                      <div className="divider">|</div>
                      <a href="#!">{product.reviews || 0} Review</a>
                    </div>
                    <div className="price-text">
                      <h3>
                        <span className="fw-normal">MRP:</span>
                        ${product.price.toFixed(2)}
                        {product.originalPrice && (
                          <>
                            <del>${product.originalPrice.toFixed(2)}</del>
                            <span className="discounted-price">{product.discountPercentage}% off</span>
                          </>
                        )}
                      </h3>
                      <span className="text">Inclusive all the text</span>
                    </div>
                    <p className="description-text">
                      {(product as any).description || "Beautiful and comfortable product suitable for your everyday needs."}
                    </p>
                    <div className="qty-box mt-3">
                      <div className="input-group qty-container">
                        <button className="btn qty-btn-minus" onClick={() => setQty(Math.max(1, qty - 1))}>
                          <i className="ri-arrow-left-s-line"></i>
                        </button>
                        <input className="form-control input-qty" name="qty" readOnly type="number" value={qty}/>
                        <button className="btn qty-btn-plus" onClick={() => setQty(qty + 1)}>
                          <i className="ri-arrow-right-s-line"></i>
                        </button>
                      </div>
                    </div>
                    <div className="product-buy-btn-group mt-3">
                      <button 
                        className="btn btn-animation btn-solid buy-button hover-solid scroll-button"
                        onClick={() => addToCart({
                          productId: product.id,
                          name: product.name,
                          price: product.price,
                          image: product.image,
                          quantity: qty
                        })}
                        data-bs-dismiss="modal"
                      >
                        <i className="ri-shopping-cart-line me-1"></i> Add To Cart
                      </button>
                    </div>
                    <div className="buy-box compare-box mt-3">
                      <a href="#!" onClick={(e) => { e.preventDefault(); toggleWishlist(product); }}>
                        <i className="ri-heart-line"></i>
                        <span>Add To Wishlist</span>
                      </a>
                      <a href="/compare">
                        <i className="ri-refresh-line"></i>
                        <span>Add To Compare</span>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
