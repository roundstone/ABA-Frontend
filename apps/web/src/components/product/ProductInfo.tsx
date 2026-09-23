'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useCartStore } from '@/store/useCartStore';
import { useWishlistStore } from '@/store/useWishlistStore';

interface ProductInfoProps {
  product: {
    id: string;
    name: string;
    price: number;
    originalPrice?: number;
    discountPercentage?: number;
    rating?: number;
    reviews?: number;
    description?: string;
    image: string;
  };
}

export default function ProductInfo({ product }: ProductInfoProps) {
  const [quantity, setQuantity] = useState(1);
  const [selectedColor, setSelectedColor] = useState(0);
  const router = useRouter();

  const addToCart = useCartStore((state) => state.addToCart);
  const toggleWishlist = useWishlistStore((state) => state.toggleWishlist);
  const isInWishlist = useWishlistStore((state) => state.isInWishlist);

  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  const colors = [
    '/images/pro3/1.jpg',
    '/images/pro3/2.jpg',
    '/images/pro3/3.jpg',
  ];

  const handleMinus = () => {
    if (quantity > 1) setQuantity(q => q - 1);
  };

  const handlePlus = () => {
    setQuantity(q => q + 1);
  };

  const handleAddToCart = () => {
    addToCart({
      productId: product.id,
      name: product.name,
      price: product.price,
      image: product.image,
      quantity,
      color: selectedColor,
    });
    const offcanvas = document.getElementById('cartOffcanvas');
    if (offcanvas) offcanvas.classList.add('show');
  };

  const handleBuyNow = () => {
    addToCart({
      productId: product.id,
      name: product.name,
      price: product.price,
      image: product.image,
      quantity,
      color: selectedColor,
    });
    router.push('/checkout');
  };

  return (
    <div className="rtl-text position-relative">
      <div className="product-page-details">
        <div className="trending-text">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img alt="Trending" className="img-fluid" src="/images/product-details/trending.gif" />
          <h5>Selling fast! 51 people have this in their carts.</h5>
        </div>
        
        <h2 className="main-title">{product.name}</h2>
        
        <div className="product-rating">
          <div className="rating-list">
            {Array.from({ length: 5 }).map((_, i) => (
              <i key={i} className={i < (product.rating || 0) ? "ri-star-fill" : "ri-star-line"}></i>
            ))}
          </div>
          <span className="divider">|</span>
          <a href="#!">{product.reviews || 0} Reviews</a>
        </div>
        
        <div className="price-text">
          <h3>
            <span className="fw-normal">MRP:</span> ${product.price.toFixed(2)}
            {product.originalPrice && (
              <del> ${product.originalPrice.toFixed(2)} </del>
            )}
            {product.discountPercentage && (
              <span className="discounted-price"> {product.discountPercentage}% Off </span>
            )}
          </h3>
          <span>Inclusive all the text</span>
        </div>
        
        <p className="description-text">
          {product.description || "Wide leg shorts with lace-up detail and a concealed zip closure. These comfortable and stylish shorts are perfect for creating a casual yet polished look. Whether you're dressing up for a night out or keeping it relaxed for a daytime stroll, these shorts are versatile and chic. Pair them with a tucked-in blouse and heels for a sophisticated ensemble, or opt for a casual vibe with a simple tee and sneakers."}
        </p>
        
        <div className="size-delivery-info">
          <a data-bs-toggle="modal" href="#return"><i className="ri-truck-line"></i> Delivery &amp; Return </a>
          <span></span>
          <a data-bs-toggle="modal" href="#ask-question"><i className="ri-questionnaire-line"></i> Ask a Question </a>
        </div>
        
        <div className="variation-box mt-3">
          <h4 className="sub-title">Color:</h4>
          <ul className="image-box">
            {colors.map((color, idx) => (
              <li key={idx} className={selectedColor === idx ? "active" : ""} onClick={() => setSelectedColor(idx)}>
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img alt={`Color ${idx + 1}`} src={color} />
              </li>
            ))}
          </ul>
        </div>
        
        <div className="product-buttons">
          <div className="qty-section">
            <div className="qty-box">
              <div className="input-group">
                <span className="input-group-prepend">
                  <button className="btn quantity-left-minus" type="button" onClick={handleMinus}>
                    <i className="ri-arrow-left-s-line"></i>
                  </button>
                </span>
                <input className="form-control input-number" name="quantity" type="text" value={quantity} readOnly />
                <span className="input-group-prepend">
                  <button className="btn quantity-right-plus" type="button" onClick={handlePlus}>
                    <i className="ri-arrow-right-s-line"></i>
                  </button>
                </span>
              </div>
            </div>
          </div>
          <div className="d-flex align-items-center gap-3">
            <button className="btn btn-animation btn-solid hover-solid scroll-button" type="button" onClick={handleAddToCart}>
              <i className="ri-shopping-cart-line me-1"></i> Add To Cart
            </button>
            <button className="btn btn-solid buy-button" type="button" onClick={handleBuyNow}>Buy Now</button>
          </div>
        </div>
        
        <div className="buy-box">
          <a href="#!" onClick={(e) => { e.preventDefault(); toggleWishlist(product as any); }}>
            <i className={mounted && isInWishlist(product.id) ? "ri-heart-fill text-danger" : "ri-heart-line"}></i>
            <span>{mounted && isInWishlist(product.id) ? "Remove From Wishlist" : "Add To Wishlist"}</span>
          </a>
          <a href="/compare">
            <i className="ri-refresh-line"></i>
            <span>Add To Compare</span>
          </a>
          <a data-bs-toggle="modal" href="#share">
            <i className="ri-share-line"></i>
            <span>Share</span>
          </a>
        </div>
        
        <div className="bordered-box">
          <h4 className="sub-title">Product Info:</h4>
          <ul className="shipping-info">
            <li><span>SKU:</span> FAS18 </li>
            <li><span>Unit:</span> 1 Item </li>
            <li><span>Weight:</span> 140 Gms</li>
            <li><span>Stock Status:</span> In Stock</li>
            <li><span>Quantity: </span> 60 Items Left</li>
          </ul>
        </div>
        
        <div className="bordered-box">
          <h4 className="sub-title">Delivery Details</h4>
          <ul className="product-offer delivery-details">
            <li><i className="ri-truck-line"></i> Your order is likely to reach you within 7 days. </li>
            <li><i className="ri-arrow-left-right-line"></i> Hassle free returns within 7 Days. </li>
          </ul>
        </div>
        
        <div className="dashed-border-box">
          <h4 className="sub-title">Guaranteed Safe Checkout</h4>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img alt="Payments" className="img-fluid payment-img" src="/images/product-details/payments.png" />
        </div>
        
        <div className="dashed-border-box mb-0">
          <h4 className="sub-title">Secure Checkout</h4>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img alt="Secure Payments" className="img-fluid payment-img" src="/images/product-details/secure_payments.png" />
        </div>
      </div>
    </div>
  );
}
