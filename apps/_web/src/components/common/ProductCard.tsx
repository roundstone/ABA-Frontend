'use client';

import Link from 'next/link';
import Image from 'next/image';
import { Product } from '@/data/products';
import { useCartStore } from '@/store/useCartStore';
import { useWishlistStore } from '@/store/useWishlistStore';
import { useQuickViewStore } from '@/store/useQuickViewStore';

export default function ProductCard({ product }: { product: Product }) {
  const addToCart = useCartStore(state => state.addToCart);
  const addToWishlist = useWishlistStore(state => state.toggleWishlist);
  const setQuickViewProduct = useQuickViewStore(state => state.setProduct);

  const handleAddToCart = (e: React.MouseEvent) => {
    e.preventDefault();
    addToCart({
      productId: product.id,
      name: product.name,
      price: product.price,
      image: product.image,
      quantity: 1
    });
  };

  const handleAddToWishlist = (e: React.MouseEvent) => {
    e.preventDefault();
    addToWishlist(product);
  };

  return (
    <div className="basic-product theme-product-5">
      <div className="img-wrapper">
        <Link href={`/product/${product.id}`}>
          <Image 
            src={product.image} 
            alt={product.name} 
            className="img-fluid blur-up lazyloaded"
            width={300}
            height={400}
            style={{ width: '100%', height: 'auto' }}
          />
        </Link>
        <div className="cart-info">
          <button title="Add to cart" onClick={handleAddToCart}>
            <i className="ri-shopping-cart-line"></i>
          </button>
          <button title="Add to Wishlist" onClick={handleAddToWishlist}>
            <i className="ri-heart-line"></i>
          </button>
          <button title="Quick View" data-bs-target="#quickView" data-bs-toggle="modal" onClick={() => setQuickViewProduct(product)}>
            <i className="ri-eye-line"></i>
          </button>
          <Link href="/compare" title="Compare">
            <i className="ri-loop-left-line"></i>
          </Link>
        </div>
        {product.isTrending && <label className="rotate-label">Trending</label>}
        {product.isNew && <label className="rotate-label">New</label>}
      </div>
      <div className="product-detail">
        <div className="brand-w-color">
          <Link href={`/product/${product.id}`} className="product-title">
            {product.name.split(' ')[0]}
          </Link>
          <div className="rating-w-count mb-0 d-sm-inline-flex d-none">
            <div className="rating">
              {Array.from({ length: 5 }).map((_, i) => (
                <i key={i} className={i < (product.rating || 0) ? "ri-star-fill" : "ri-star-line"}></i>
              ))}
            </div>
            <span>({product.reviews || 0})</span>
          </div>
        </div>
        <h6> {product.name} </h6>
        <h4 className="price">
          ${product.price.toFixed(2)}
          {product.originalPrice && (
            <>
              <del> ${product.originalPrice.toFixed(2)} </del>
              <span className="discounted-price"> {product.discountPercentage}% Off </span>
            </>
          )}
        </h4>
      </div>
    </div>
  );
}
