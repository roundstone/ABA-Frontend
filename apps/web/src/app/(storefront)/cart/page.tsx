'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { Trash2, ShieldCheck, ArrowRight, Store, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useCartStore } from '@/features/cart/store';
import { AmountText } from '@/components/patterns/AmountText';

export default function CartPage() {
  const [mounted, setMounted] = useState(false);
  const { 
    items, 
    subtotal, 
    deliveryFee, 
    total, 
    updateQuantity, 
    removeFromCart, 
    isSyncing 
  } = useCartStore();

  // Avoid hydration mismatch by only rendering after mount
  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 flex justify-center items-center h-64">
        <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
      </div>
    );
  }

  if (items.length === 0) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 text-center">
        <div className="w-24 h-24 bg-surface-2 rounded-full flex items-center justify-center mx-auto mb-6">
          <Trash2 className="w-10 h-10 text-text-muted opacity-50" />
        </div>
        <h1 className="text-3xl font-bold text-text mb-4">Your cart is empty</h1>
        <p className="text-text-muted mb-8">Looks like you haven't added anything to your cart yet.</p>
        <Link href="/shop">
          <Button size="lg" className="rounded-full px-8">Start Shopping</Button>
        </Link>
      </div>
    );
  }

  // Group items by merchant for display
  const groupedItems = items.reduce((acc, item) => {
    if (!acc[item.merchantName]) acc[item.merchantName] = [];
    acc[item.merchantName].push(item);
    return acc;
  }, {} as Record<string, typeof items>);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <h1 className="text-3xl font-bold text-text mb-8">Shopping Cart</h1>

      <div className="flex flex-col lg:flex-row gap-8">
        {/* Cart Items */}
        <div className="flex-1 space-y-6">
          {Object.entries(groupedItems).map(([merchantName, merchantItems]) => (
            <div key={merchantName} className="bg-white rounded-xl border border-border shadow-sm overflow-hidden">
              <div className="bg-surface-1 px-6 py-3 border-b border-border flex items-center gap-2">
                <Store className="w-4 h-4 text-brand-600" />
                <span className="font-semibold text-text">{merchantName}</span>
              </div>
              <ul className="divide-y divide-border">
                {merchantItems.map(item => (
                  <li key={item.id} className="p-6 flex flex-col sm:flex-row gap-6">
                    <div className="w-24 h-24 shrink-0 rounded-lg border border-border overflow-hidden bg-surface-1">
                      {item.productImage && (
                        <img src={item.productImage} alt={item.productName} className="w-full h-full object-cover" />
                      )}
                    </div>
                    
                    <div className="flex-1 flex flex-col justify-between">
                      <div className="flex justify-between items-start gap-4">
                        <div>
                          <h3 className="font-semibold text-text mb-1">{item.productName}</h3>
                          {item.attributes && (
                            <p className="text-sm text-text-muted mb-1">
                              {Object.entries(item.attributes).map(([k, v]) => `${k}: ${v}`).join(' | ')}
                            </p>
                          )}
                          <p className="text-sm text-success-main font-medium">In Stock</p>
                        </div>
                        <p className="font-bold text-lg text-text">
                          <AmountText amountInKobo={item.price * item.quantity} />
                        </p>
                      </div>
                      
                      <div className="flex justify-between items-center mt-4 sm:mt-0">
                        <div className="flex items-center border border-border rounded-md bg-surface-1 h-9 w-28 overflow-hidden">
                          <button 
                            onClick={() => updateQuantity(item.id, Math.max(1, item.quantity - 1))} 
                            className="flex-1 h-full text-lg hover:text-brand-600 hover:bg-surface-2 disabled:opacity-50"
                            disabled={isSyncing || item.quantity <= 1}
                          >
                            -
                          </button>
                          <span className="flex-1 text-center text-sm font-medium">
                            {item.quantity}
                          </span>
                          <button 
                            onClick={() => updateQuantity(item.id, item.quantity + 1)} 
                            className="flex-1 h-full text-lg hover:text-brand-600 hover:bg-surface-2 disabled:opacity-50"
                            disabled={isSyncing}
                          >
                            +
                          </button>
                        </div>
                        
                        <button 
                          onClick={() => removeFromCart(item.id)} 
                          className="text-sm text-error hover:underline flex items-center gap-1 disabled:opacity-50"
                          disabled={isSyncing}
                        >
                          <Trash2 className="w-4 h-4" /> 
                          Remove
                        </button>
                      </div>
                    </div>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        {/* Order Summary */}
        <div className="w-full lg:w-[380px] shrink-0">
          <div className="bg-white rounded-xl border border-border shadow-sm p-6 sticky top-24">
            <h2 className="text-lg font-bold text-text mb-6">Order Summary</h2>
            
            <div className="space-y-4 text-sm mb-6">
              <div className="flex justify-between">
                <span className="text-text-muted">Subtotal ({useCartStore(state => state.getTotalItems())} items)</span>
                <span className="font-medium text-text"><AmountText amountInKobo={subtotal} /></span>
              </div>
              <div className="flex justify-between">
                <span className="text-text-muted flex items-center gap-1">Delivery Estimate</span>
                <span className="font-medium text-text"><AmountText amountInKobo={deliveryFee} /></span>
              </div>
              
              <div className="border-t border-border pt-4 mt-2">
                <div className="flex justify-between items-center">
                  <span className="font-bold text-text text-base">Total</span>
                  <span className="font-bold text-brand-600 text-xl"><AmountText amountInKobo={total} /></span>
                </div>
                <p className="text-xs text-text-muted mt-1 text-right">Prices include VAT.</p>
              </div>
            </div>

            <Link href="/checkout" className="block">
              <Button size="lg" className="w-full rounded-full h-12 text-base">
                Proceed to Checkout <ArrowRight className="w-5 h-5 ml-2" />
              </Button>
            </Link>

            <div className="mt-6 flex items-center gap-2 text-xs text-text-muted justify-center">
              <ShieldCheck className="w-4 h-4 text-success-main" />
              <span>Secure Checkout Powered by ABA Online</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
