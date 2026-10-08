'use client';
import { brand } from '@/config/brand';


import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Check, ShieldCheck, MapPin, Truck, CreditCard, Wallet, AlertCircle, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useQuery, useMutation } from '@tanstack/react-query';
import { getCart } from '@/features/cart/api';
import { initializeCheckout, processCheckout } from '@/features/checkout/api';
import { CheckoutAddressInput, CheckoutPaymentInput } from '@/features/checkout/schemas';
import { Alert } from '@/components/ui/alert';
import { AmountText } from '@/components/patterns/AmountText';

export default function CheckoutPage() {
  const router = useRouter();
  const [step, setStep] = useState(1);

  const [paymentMethod, setPaymentMethod] = useState<'card' | 'wallet'>('card');
  const [addressForm, setAddressForm] = useState<CheckoutAddressInput>({
    fullName: 'Jane Doe',
    phone: '+2348012345678',
    street: '123 Market Street, Victoria Island',
    city: 'Lagos',
    state: 'Lagos',
    zipCode: '101241'
  });

  const nextStep = () => setStep(prev => Math.min(prev + 1, 5));
  const prevStep = () => setStep(prev => Math.max(prev - 1, 1));

  // 1. Fetch Cart for Summary
  const { data: cartData, isLoading: isCartLoading, error: cartError } = useQuery({
    queryKey: ['cart'],
    queryFn: async () => {
      const res = await getCart();
      return res.data;
    }
  });

  // 2. Initialize Checkout Session
  const { data: sessionData, isLoading: isSessionLoading } = useQuery({
    queryKey: ['checkoutSession', cartData?.id],
    queryFn: async () => {
      if (!cartData?.id) return null;
      const res = await initializeCheckout(cartData.id);
      return res.data;
    },
    enabled: !!cartData?.id
  });

  // 3. Process Checkout Mutation
  const processMutation = useMutation({
    mutationFn: async () => {
      if (!sessionData?.id) throw new Error('No active session');
      const res = await processCheckout(
        sessionData.id,
        addressForm,
        { method: paymentMethod }
      );
      return res.data;
    },
    onSuccess: (data) => {
      // Pass the order ID to the success page via query param (or just redirect)
      router.push(`/checkout/success?orderId=${data.orderId}`);
    }
  });

  const handlePlaceOrder = () => {
    processMutation.mutate();
  };

  const steps = [
    { num: 1, title: 'Customer Info' },
    { num: 2, title: 'Delivery Address' },
    { num: 3, title: 'Delivery Method' },
    { num: 4, title: 'Payment' },
    { num: 5, title: 'Review' },
  ];

  if (isCartLoading || isSessionLoading) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 flex justify-center items-center h-64">
        <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
      </div>
    );
  }

  if (cartError || !cartData) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <Alert variant="destructive">
          Failed to load checkout details. Please try again.
        </Alert>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-8">
        <Link href="/cart" className="text-sm text-brand-600 hover:underline">&larr; Back to Cart</Link>
        <h1 className="text-3xl font-bold text-text mt-4">Checkout</h1>
      </div>

      <div className="flex flex-col lg:flex-row gap-8">

        {/* Main Checkout Flow */}
        <div className="flex-1">
          {/* Progress Indicator */}
          <div className="flex items-center justify-between mb-8 relative">
            <div className="absolute left-0 top-1/2 -translate-y-1/2 w-full h-1 bg-surface-2 -z-10"></div>
            <div className="absolute left-0 top-1/2 -translate-y-1/2 h-1 bg-brand-600 -z-10 transition-all" style={{ width: `${((step - 1) / (steps.length - 1)) * 100}%` }}></div>

            {steps.map(s => (
              <div key={s.num} className="flex flex-col items-center">
                <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm border-2 transition-colors ${step > s.num ? 'bg-brand-600 border-brand-600 text-white' :
                  step === s.num ? 'bg-white border-brand-600 text-brand-600' : 'bg-white border-border text-text-muted'
                  }`}>
                  {step > s.num ? <Check className="w-4 h-4" /> : s.num}
                </div>
                <span className={`text-xs mt-2 hidden sm:block ${step >= s.num ? 'font-semibold text-text' : 'text-text-muted'}`}>{s.title}</span>
              </div>
            ))}
          </div>

          {processMutation.isError && (
            <div className="mb-6">
              <Alert variant="destructive">
                {processMutation.error instanceof Error ? processMutation.error.message : 'Checkout failed. Please try again.'}
              </Alert>
            </div>
          )}

          <div className="bg-white rounded-xl border border-border shadow-sm overflow-hidden min-h-[400px]">

            {/* STEP 1: Info */}
            {step === 1 && (
              <div className="p-6 md:p-8 animate-in fade-in slide-in-from-right-4">
                <h2 className="text-xl font-bold text-text mb-6">Contact Information</h2>
                <div className="space-y-4">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-text mb-1">First Name</label>
                      <input type="text" className="w-full h-10 px-3 rounded-md border border-border bg-white text-sm focus:ring-2 focus:ring-brand-500 outline-none" defaultValue="Jane" />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-text mb-1">Last Name</label>
                      <input type="text" className="w-full h-10 px-3 rounded-md border border-border bg-white text-sm focus:ring-2 focus:ring-brand-500 outline-none" defaultValue="Doe" />
                    </div>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-text mb-1">Email Address</label>
                    <input type="email" className="w-full h-10 px-3 rounded-md border border-border bg-white text-sm focus:ring-2 focus:ring-brand-500 outline-none" defaultValue="jane.doe@example.com" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-text mb-1">Phone Number</label>
                    <input type="tel" className="w-full h-10 px-3 rounded-md border border-border bg-white text-sm focus:ring-2 focus:ring-brand-500 outline-none" value={addressForm.phone} onChange={e => setAddressForm({ ...addressForm, phone: e.target.value })} />
                  </div>
                </div>
                <div className="mt-8 flex justify-end">
                  <Button onClick={nextStep} size="lg">Continue to Address</Button>
                </div>
              </div>
            )}

            {/* STEP 2: Address */}
            {step === 2 && (
              <div className="p-6 md:p-8 animate-in fade-in slide-in-from-right-4">
                <h2 className="text-xl font-bold text-text mb-6">Delivery Address</h2>

                {/* Saved Address Mock */}
                <div className="border-2 border-brand-600 rounded-lg p-4 bg-brand-50 mb-6 cursor-pointer relative flex items-start gap-4">
                  <div className="mt-1">
                    <MapPin className="w-5 h-5 text-brand-600" />
                  </div>
                  <div>
                    <p className="font-semibold text-text">Home</p>
                    <p className="text-sm text-text-muted mt-1">{addressForm.street}</p>
                    <p className="text-sm text-text-muted">{addressForm.city}, {addressForm.zipCode}, {addressForm.state}</p>
                  </div>
                  <div className="absolute top-4 right-4">
                    <Check className="w-5 h-5 text-brand-600" />
                  </div>
                </div>

                <button className="text-brand-600 font-medium text-sm hover:underline">+ Add a new address</button>

                <div className="mt-8 flex justify-between">
                  <Button variant="outline" onClick={prevStep}>Back</Button>
                  <Button onClick={nextStep} size="lg">Continue to Delivery</Button>
                </div>
              </div>
            )}

            {/* STEP 3: Delivery */}
            {step === 3 && (
              <div className="p-6 md:p-8 animate-in fade-in slide-in-from-right-4">
                <h2 className="text-xl font-bold text-text mb-6">Delivery Method</h2>

                <div className="space-y-4">
                  <label className="border-2 border-brand-600 rounded-lg p-4 bg-brand-50 flex items-center justify-between cursor-pointer">
                    <div className="flex items-center gap-3">
                      <input type="radio" name="delivery" defaultChecked className="text-brand-600 w-4 h-4" />
                      <div>
                        <p className="font-semibold text-text flex items-center gap-2"><Truck className="w-4 h-4" /> Standard Delivery</p>
                        <p className="text-sm text-text-muted">3-5 Business Days</p>
                      </div>
                    </div>
                    <span className="font-bold"><AmountText amountInKobo={250000} /></span>
                  </label>

                  <label className="border border-border rounded-lg p-4 bg-white flex items-center justify-between cursor-pointer hover:border-brand-300">
                    <div className="flex items-center gap-3">
                      <input type="radio" name="delivery" className="text-brand-600 w-4 h-4" />
                      <div>
                        <p className="font-semibold text-text">Express Delivery</p>
                        <p className="text-sm text-text-muted">1-2 Business Days</p>
                      </div>
                    </div>
                    <span className="font-bold"><AmountText amountInKobo={500000} /></span>
                  </label>
                </div>

                <div className="mt-8 flex justify-between">
                  <Button variant="outline" onClick={prevStep}>Back</Button>
                  <Button onClick={nextStep} size="lg">Continue to Payment</Button>
                </div>
              </div>
            )}

            {/* STEP 4: Payment */}
            {step === 4 && (
              <div className="p-6 md:p-8 animate-in fade-in slide-in-from-right-4">
                <h2 className="text-xl font-bold text-text mb-6">Payment Method</h2>

                <div className="space-y-4">
                  <label className={`border-2 rounded-lg p-4 flex items-center justify-between cursor-pointer transition-all ${paymentMethod === 'card' ? 'border-brand-600 bg-brand-50' : 'border-border bg-white'}`}>
                    <div className="flex items-center gap-3">
                      <input type="radio" name="payment" checked={paymentMethod === 'card'} onChange={() => setPaymentMethod('card')} className="text-brand-600 w-4 h-4" />
                      <div>
                        <p className="font-semibold text-text flex items-center gap-2"><CreditCard className="w-4 h-4" /> Credit / Debit Card</p>
                      </div>
                    </div>
                  </label>

                  <label className={`border-2 rounded-lg p-4 flex items-center justify-between cursor-pointer transition-all ${paymentMethod === 'wallet' ? 'border-brand-600 bg-brand-50' : 'border-border bg-white'}`}>
                    <div className="flex items-center gap-3">
                      <input type="radio" name="payment" checked={paymentMethod === 'wallet'} onChange={() => setPaymentMethod('wallet')} className="text-brand-600 w-4 h-4" />
                      <div>
                        <p className="font-semibold text-text flex items-center gap-2"><Wallet className="w-4 h-4" /> {brand.shortName} Wallet</p>
                        <p className="text-sm text-text-muted">Balance: <AmountText amountInKobo={150000000} /></p>
                      </div>
                    </div>
                  </label>
                </div>

                {paymentMethod === 'card' && (
                  <div className="mt-6 bg-surface-1 p-4 rounded-lg border border-border">
                    <p className="text-sm text-text-muted text-center">You will be redirected to our secure payment gateway to complete your purchase after reviewing your order.</p>
                  </div>
                )}

                <div className="mt-8 flex justify-between">
                  <Button variant="outline" onClick={prevStep}>Back</Button>
                  <Button onClick={nextStep} size="lg">Review Order</Button>
                </div>
              </div>
            )}

            {/* STEP 5: Review */}
            {step === 5 && (
              <div className="p-6 md:p-8 animate-in fade-in slide-in-from-right-4">
                <h2 className="text-xl font-bold text-text mb-6">Review Your Order</h2>

                <div className="bg-warning-light/30 border border-warning-main/30 rounded-lg p-4 flex items-start gap-3 mb-6">
                  <AlertCircle className="w-5 h-5 text-warning-dark shrink-0" />
                  <p className="text-sm text-warning-dark">Please review your order details carefully before placing your order. Orders cannot be easily modified once placed.</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                  <div className="bg-surface-1 p-4 rounded-lg border border-border">
                    <div className="flex justify-between items-center mb-2">
                      <h3 className="font-semibold text-text">Delivery Address</h3>
                      <button onClick={() => setStep(2)} className="text-xs text-brand-600 hover:underline">Edit</button>
                    </div>
                    <p className="text-sm text-text-muted">{addressForm.fullName}</p>
                    <p className="text-sm text-text-muted">{addressForm.street}, {addressForm.city}</p>
                    <p className="text-sm text-text-muted">{addressForm.phone}</p>
                  </div>
                  <div className="bg-surface-1 p-4 rounded-lg border border-border">
                    <div className="flex justify-between items-center mb-2">
                      <h3 className="font-semibold text-text">Payment & Delivery</h3>
                      <button onClick={() => setStep(3)} className="text-xs text-brand-600 hover:underline">Edit</button>
                    </div>
                    <p className="text-sm text-text-muted capitalize">Method: {paymentMethod === 'card' ? 'Card Payment (Gateway)' : '{brand.shortName} Wallet'}</p>
                    <p className="text-sm text-text-muted">Shipping: Standard Delivery</p>
                  </div>
                </div>

                <div className="mt-8 flex justify-between">
                  <Button variant="outline" onClick={prevStep} disabled={processMutation.isPending}>Back</Button>
                  <Button
                    onClick={handlePlaceOrder}
                    size="lg"
                    className="bg-brand-600 hover:bg-brand-700 disabled:opacity-50"
                    disabled={processMutation.isPending}
                  >
                    {processMutation.isPending ? (
                      <span className="flex items-center gap-2"><Loader2 className="w-5 h-5 animate-spin" /> Processing...</span>
                    ) : (
                      <>Place Order (<AmountText amountInKobo={cartData.total} />)</>
                    )}
                  </Button>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Order Summary Sidebar */}
        <div className="w-full lg:w-[380px] shrink-0">
          <div className="bg-white rounded-xl border border-border shadow-sm p-6 sticky top-24">
            <h2 className="text-lg font-bold text-text mb-4">Summary</h2>

            <div className="max-h-60 overflow-y-auto mb-4 divide-y divide-border pr-2">
              {cartData.items.map(item => (
                <div key={item.id} className="py-3 flex gap-3">
                  <div className="w-12 h-12 rounded border border-border shrink-0 overflow-hidden bg-surface-1">
                    {item.productImage && <img src={item.productImage} alt={item.productName} className="w-full h-full object-cover" />}
                  </div>
                  <div className="flex-1">
                    <p className="text-sm font-medium text-text line-clamp-1">{item.productName}</p>
                    <div className="flex justify-between items-center mt-1">
                      <span className="text-xs text-text-muted">Qty: {item.quantity}</span>
                      <span className="text-sm font-bold text-text"><AmountText amountInKobo={item.price * item.quantity} /></span>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            <div className="space-y-3 text-sm mb-6 border-t border-border pt-4">
              <div className="flex justify-between">
                <span className="text-text-muted">Subtotal</span>
                <span className="font-medium text-text"><AmountText amountInKobo={cartData.subtotal} /></span>
              </div>
              <div className="flex justify-between">
                <span className="text-text-muted">Delivery</span>
                <span className="font-medium text-text"><AmountText amountInKobo={cartData.deliveryFee} /></span>
              </div>

              <div className="border-t border-border pt-3 mt-2">
                <div className="flex justify-between items-center">
                  <span className="font-bold text-text text-base">Total</span>
                  <span className="font-bold text-brand-600 text-xl"><AmountText amountInKobo={cartData.total} /></span>
                </div>
              </div>
            </div>

            <div className="flex items-center gap-2 text-xs text-text-muted justify-center bg-surface-1 p-2 rounded">
              <ShieldCheck className="w-4 h-4 text-success-main" />
              <span>SSL Secured Payment</span>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
