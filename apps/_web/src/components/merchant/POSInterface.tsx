"use client";

import React, { useState, useEffect } from 'react';
import { PublicService, PublicProduct } from '@/services/mock/public.service';
import Receipt from '@/components/Receipt';

interface CartItem extends PublicProduct {
  quantity: number;
}

export default function POSInterface() {
  const [products, setProducts] = useState<PublicProduct[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [cart, setCart] = useState<CartItem[]>([]);
  
  // Customer details
  const [customerName, setCustomerName] = useState('');
  const [customerEmail, setCustomerEmail] = useState('');
  const [referralCode, setReferralCode] = useState('');
  
  // Receipt state
  const [showReceipt, setShowReceipt] = useState(false);
  const [receiptData, setReceiptData] = useState<any>(null);

  useEffect(() => {
    // Load products
    const loadProducts = async () => {
      const allProducts = await PublicService.getProducts();
      setProducts(allProducts);
    };
    loadProducts();
  }, []);

  const filteredProducts = products.filter(p => 
    p.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
    p.category.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const addToCart = (product: PublicProduct) => {
    setCart(prev => {
      const existing = prev.find(item => item.id === product.id);
      if (existing) {
        return prev.map(item => item.id === product.id ? { ...item, quantity: item.quantity + 1 } : item);
      }
      return [...prev, { ...product, quantity: 1 }];
    });
  };

  const updateQuantity = (id: string, delta: number) => {
    setCart(prev => prev.map(item => {
      if (item.id === id) {
        const newQty = Math.max(1, item.quantity + delta);
        return { ...item, quantity: newQty };
      }
      return item;
    }));
  };

  const removeFromCart = (id: string) => {
    setCart(prev => prev.filter(item => item.id !== id));
  };

  const cartTotal = cart.reduce((total, item) => total + (item.price * item.quantity), 0);

  const handleCheckout = () => {
    if (cart.length === 0) {
      alert("Cart is empty");
      return;
    }
    
    // Generate mock receipt data
    const newReceiptData = {
      orderId: `POS-${Math.floor(Math.random() * 100000)}`,
      date: new Date().toISOString(),
      customerName: customerName || 'Walk-in Customer',
      customerEmail: customerEmail || 'N/A',
      referralCode: referralCode || 'N/A',
      items: cart.map(item => ({
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        total: item.price * item.quantity
      })),
      subtotal: cartTotal,
      tax: 0,
      total: cartTotal,
      type: 'POS'
    };
    
    setReceiptData(newReceiptData);
    setShowReceipt(true);
  };
  
  const resetPOS = () => {
    setCart([]);
    setCustomerName('');
    setCustomerEmail('');
    setReferralCode('');
    setShowReceipt(false);
    setReceiptData(null);
  };

  if (showReceipt && receiptData) {
    return (
      <div className="pos-receipt-view bg-white p-4 border rounded shadow-sm">
        <div className="d-flex justify-content-between mb-4">
          <h4>Sale Completed</h4>
          <button className="btn btn-outline-secondary" onClick={resetPOS}>New Sale</button>
        </div>
        <Receipt 
          orderData={receiptData} 
          type="POS" 
        />
      </div>
    );
  }

  return (
    <div className="pos-interface row g-4">
      {/* Products Column */}
      <div className="col-lg-8">
        <div className="card shadow-sm h-100 border-0">
          <div className="card-header bg-white py-3">
            <input 
              type="text" 
              className="form-control" 
              placeholder="Search products by name or category..." 
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
          <div className="card-body bg-light" style={{ maxHeight: '70vh', overflowY: 'auto' }}>
            <div className="row g-3">
              {filteredProducts.map(product => (
                <div key={product.id} className="col-md-4 col-sm-6">
                  <div 
                    className="card h-100 cursor-pointer product-card-hover border-0 shadow-sm"
                    onClick={() => addToCart(product)}
                    style={{ cursor: 'pointer' }}
                  >
                    {/* Using a placeholder image or product image */}
                    <div className="bg-white text-center p-2 border-bottom">
                      <img src={product.imageUrl || '/images/pro3/1.jpg'} alt={product.name} style={{ height: '100px', objectFit: 'contain' }} />
                    </div>
                    <div className="card-body p-2 text-center">
                      <h6 className="mb-1 text-truncate" title={product.name}>{product.name}</h6>
                      <p className="mb-0 fw-bold text-primary">₦{product.price.toLocaleString()}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
            {filteredProducts.length === 0 && (
              <div className="text-center py-5 text-muted">No products found</div>
            )}
          </div>
        </div>
      </div>

      {/* Cart & Checkout Column */}
      <div className="col-lg-4">
        <div className="card shadow-sm h-100 border-0 d-flex flex-column">
          <div className="card-header bg-white py-3">
            <h5 className="mb-0 fw-bold">Current Sale</h5>
          </div>
          
          <div className="card-body flex-grow-1" style={{ maxHeight: '40vh', overflowY: 'auto' }}>
            {cart.length === 0 ? (
              <div className="text-center py-5 text-muted">Cart is empty</div>
            ) : (
              <ul className="list-group list-group-flush">
                {cart.map(item => (
                  <li key={item.id} className="list-group-item px-0 py-2">
                    <div className="d-flex justify-content-between align-items-center mb-1">
                      <span className="fw-bold text-truncate" style={{ maxWidth: '70%' }}>{item.name}</span>
                      <button className="btn btn-link text-danger p-0 text-decoration-none" onClick={() => removeFromCart(item.id)}>
                        <i className="ri-close-circle-line fs-5"></i>
                      </button>
                    </div>
                    <div className="d-flex justify-content-between align-items-center">
                      <div className="input-group input-group-sm w-auto">
                        <button className="btn btn-outline-secondary" onClick={() => updateQuantity(item.id, -1)}>-</button>
                        <input type="text" className="form-control text-center px-1" value={item.quantity} readOnly style={{ width: '40px' }} />
                        <button className="btn btn-outline-secondary" onClick={() => updateQuantity(item.id, 1)}>+</button>
                      </div>
                      <span className="fw-bold">₦{(item.price * item.quantity).toLocaleString()}</span>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </div>

          <div className="card-footer bg-white pt-3 border-top-0">
            <div className="mb-3">
              <label className="form-label text-sm fw-bold">Customer Details (Optional)</label>
              <input type="text" className="form-control form-control-sm mb-2" placeholder="Customer Name" value={customerName} onChange={e => setCustomerName(e.target.value)} />
              <input type="text" className="form-control form-control-sm mb-2" placeholder="Referral Code (e.g. ABA-1234)" value={referralCode} onChange={e => setReferralCode(e.target.value)} />
            </div>
            
            <div className="d-flex justify-content-between mb-3 fs-5">
              <span>Total:</span>
              <span className="fw-bold text-primary">₦{cartTotal.toLocaleString()}</span>
            </div>
            
            <button 
              className="btn btn-primary w-100 py-2 fw-bold" 
              disabled={cart.length === 0}
              onClick={handleCheckout}
            >
              Record Offline Payment
            </button>
          </div>
        </div>
      </div>
      
      <style dangerouslySetInnerHTML={{__html: `
        .product-card-hover:hover {
          transform: translateY(-2px);
          transition: transform 0.2s ease-in-out;
          box-shadow: 0 4px 8px rgba(0,0,0,0.1) !important;
        }
      `}} />
    </div>
  );
}
