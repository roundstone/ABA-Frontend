'use client';

import Link from 'next/link';
import { useCartStore } from '@/store/useCartStore';
import { useEffect, useState } from 'react';

export default function CartOffcanvas() {
  const { items, removeFromCart, updateQuantity, clearCart, getCartTotal, getItemCount } = useCartStore();
  const [mounted, setMounted] = useState(false);
  
  useEffect(() => {
    setMounted(true);
  }, []);

  const closeCart = () => {
    const offcanvas = document.getElementById('cartOffcanvas');
    if (offcanvas) {
      offcanvas.classList.remove('show');
    }
  };

  const total = getCartTotal();
  const count = getItemCount();
  const freeShippingThreshold = 50;
  const progress = Math.min((total / freeShippingThreshold) * 100, 100);

  return (
    <div className="offcanvas offcanvas-end cart-offcanvas" id="cartOffcanvas" tabIndex={-1} style={{ visibility: 'visible' }}>
      <div className="offcanvas-header">
        <h3 className="offcanvas-title">My Cart ({mounted ? count : 0})</h3>
        <button className="btn-close" type="button" onClick={closeCart}>
          <i className="ri-close-line"></i>
        </button>
      </div>
      <div className="offcanvas-body">
        <div className="pre-text-box">
          {mounted && total < freeShippingThreshold ? (
            <p>Spend ${(freeShippingThreshold - total).toFixed(2)} More And Enjoy Free Shipping!</p>
          ) : (
            <p>You have unlocked Free Shipping!</p>
          )}
          <div className="progress" role="progressbar">
            <div className="progress-bar progress-bar-striped progress-bar-animated" style={{ width: `${mounted ? progress : 0}%` }}>
              <i className="ri-truck-line"></i>
            </div>
          </div>
        </div>
        
        {mounted && items.length > 0 && (
          <div className="sidebar-title">
            <a href="#!" onClick={(e) => { e.preventDefault(); clearCart(); }}>Clear Cart</a>
          </div>
        )}
        
        <div className="cart-media">
          <ul className="cart-product">
            {mounted && items.length === 0 ? (
              <li className="text-center py-5">
                <p>Your cart is empty.</p>
              </li>
            ) : (
              mounted && items.map((item) => (
                <li key={item.id}>
                  <div className="media">
                    <Link href={`/product/${item.productId}`}>
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img alt={item.name} className="img-fluid" src={item.image} />
                    </Link>
                    <div className="media-body">
                      <Link href={`/product/${item.productId}`}>
                        <h4>{item.name}</h4>
                      </Link>
                      <h4 className="quantity">
                        <span>{item.quantity} x ${item.price.toFixed(2)}</span>
                      </h4>
                      {item.size && <p className="mb-0 text-muted" style={{ fontSize: '12px' }}>Size: {item.size}</p>}
                      <div className="qty-box">
                        <div className="input-group qty-container">
                          <button className="btn qty-btn-minus" onClick={() => updateQuantity(item.id, item.quantity - 1)}>
                            <i className="ri-subtract-line"></i>
                          </button>
                          <input className="form-control input-qty" name="qty" readOnly type="number" value={item.quantity} />
                          <button className="btn qty-btn-plus" onClick={() => updateQuantity(item.id, item.quantity + 1)}>
                            <i className="ri-add-line"></i>
                          </button>
                        </div>
                      </div>
                      <div className="close-circle">
                        <button className="close_button delete-button" type="button" onClick={() => removeFromCart(item.id)}>
                          <i className="ri-delete-bin-line"></i>
                        </button>
                      </div>
                    </div>
                  </div>
                </li>
              ))
            )}
          </ul>
          
          {mounted && items.length > 0 && (
            <ul className="cart_total">
              <li>
                <div className="total">
                  <h5>Sub Total : <span>${total.toFixed(2)}</span></h5>
                </div>
              </li>
              <li>
                <div className="buttons">
                  <Link href="/cart" className="btn view-cart" onClick={closeCart}>View Cart</Link>
                  <Link href="/checkout" className="btn checkout" onClick={closeCart}>Check Out</Link>
                </div>
              </li>
            </ul>
          )}
        </div>
      </div>
    </div>
  );
}
