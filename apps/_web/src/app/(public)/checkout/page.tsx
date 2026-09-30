'use client';

import Breadcrumb from '@/components/ui/Breadcrumb';
import { useCartStore } from '@/store/useCartStore';
import { useAuthStore } from '@/store/useAuthStore';
import { ReferralService } from '@/services/mock/referral.service';
import { CommissionService } from '@/services/mock/commission.service';
import { OrderService } from '@/services/mock/order.service';
import { useRouter } from 'next/navigation';
import { useState, useEffect } from 'react';

export default function CheckoutPage() {
  const router = useRouter();
  const { items, getCartTotal, clearCart } = useCartStore();
  const { user } = useAuthStore();
  const [mounted, setMounted] = useState(false);
  const [referralCode, setReferralCode] = useState('');

  useEffect(() => setMounted(true), []);

  const handlePlaceOrder = (e: React.MouseEvent<HTMLButtonElement>) => {
    e.preventDefault();
    
    const orderTotal = getCartTotal();
    const purchaserId = user ? user.id : `guest_${Math.random().toString(36).substr(2, 9)}`;

    const newOrder = OrderService.createOrder({
      customerId: purchaserId,
      items: items.map(item => ({
        id: item.id,
        productId: item.id, // Assuming cart item id is productId
        productName: item.name,
        price: item.price,
        quantity: item.quantity,
        image: item.image,
      })),
      subtotal: orderTotal,
      tax: orderTotal * 0.05,
      shipping: 0.00,
      total: orderTotal + (orderTotal * 0.05),
      shippingAddress: 'New Home, Denver, CO', // Mocking selected address
      paymentMethod: 'PAYPAL', // Mocking selected payment
    }, referralCode);

    clearCart();
    router.push(`/order-success/${newOrder.id}`);
  };

  const total = mounted ? getCartTotal() : 0;
  const shipping = 0.00;
  const tax = total * 0.05; // 5% tax

  return (
    <>
      <Breadcrumb
        title="checkout"
        items={[{ label: 'Home', url: '/' }, { label: 'checkout' }]}
      />
      
      <section className="section-b-space checkout-section-2">
        <div className="container">
          <div className="checkout-page">
            <div className="checkout-form">
              <div className="row g-sm-4 g-3">
                <div className="col-lg-7">
                  <div className="left-sidebar-checkout">
                    <div className="checkout-detail-box">
                      <ul>
                        <li>
                          <div className="checkout-box">
                            <div className="checkout-title">
                              <h4>Shipping Address</h4>
                              <button className="d-flex align-items-center btn" data-bs-target="#addAddress" data-bs-toggle="modal"><i className="ri-add-line me-1"></i> Add New</button>
                            </div>
                            <div className="checkout-detail">
                              <div className="row g-3">
                                <div className="col-xxl-6 col-lg-12 col-md-6">
                                  <div className="delivery-address-box">
                                    <input defaultChecked className="form-check-input" id="check" name="flexRadioDefault" type="radio"/>
                                    <label className="form-check-label" htmlFor="check">
                                      <span className="name">New Home</span>
                                      <span className="address text-content"><span className="text-title">Address :</span> 26, Starts Hollow Colony, Denver, Colorado, United States</span>
                                      <span className="address text-content"><span className="text-title">Pin Code :</span> 80014</span>
                                      <span className="address text-content"><span className="text-title">Phone :</span> +1 5551855359</span>
                                    </label>
                                  </div>
                                </div>
                                <div className="col-xxl-6 col-lg-12 col-md-6">
                                  <div className="delivery-address-box">
                                    <input className="form-check-input" id="check1" name="flexRadioDefault" type="radio"/>
                                    <label className="form-check-label" htmlFor="check1">
                                      <span className="name">Old Home</span>
                                      <span className="address text-content"><span className="text-title">Address :</span> 53B, Claire New Street, San Jose, Colorado, United States</span>
                                      <span className="address text-content"><span className="text-title">Pin Code :</span> 36954</span>
                                      <span className="address text-content"><span className="text-title">Phone :</span> +1 5551855359</span>
                                    </label>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </li>
                        <li>
                          <div className="checkout-box">
                            <div className="checkout-title">
                              <h4>Billing Address</h4>
                              <button className="d-flex align-items-center btn" data-bs-target="#addAddress" data-bs-toggle="modal"><i className="ri-add-line me-1"></i> Add New</button>
                            </div>
                            <div className="checkout-detail">
                              <div className="row g-3">
                                <div className="col-xxl-6 col-lg-12 col-md-6">
                                  <div className="delivery-address-box">
                                    <input className="form-check-input" id="check3" name="checkbox" type="radio"/>
                                    <label className="form-check-label" htmlFor="check3">
                                      <span className="name">New Home</span>
                                      <span className="address text-content"><span className="text-title">Address :</span> 26, Starts Hollow Colony, Denver, Colorado, United States</span>
                                      <span className="address text-content"><span className="text-title">Pin Code :</span> 80014</span>
                                      <span className="address text-content"><span className="text-title">Phone :</span> +1 5551855359</span>
                                    </label>
                                  </div>
                                </div>
                                <div className="col-xxl-6 col-lg-12 col-md-6">
                                  <div className="delivery-address-box">
                                    <input defaultChecked className="form-check-input" id="check4" name="checkbox" type="radio"/>
                                    <label className="form-check-label" htmlFor="check4">
                                      <span className="name">Old Home</span>
                                      <span className="address text-content"><span className="text-title">Address :</span> 53B, Claire New Street, San Jose, Colorado, United States</span>
                                      <span className="address text-content"><span className="text-title">Pin Code :</span> 36954</span>
                                      <span className="address text-content"><span className="text-title">Phone :</span> +1 5551855359</span>
                                    </label>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </li>
                        <li>
                          <div className="checkout-box">
                            <div className="checkout-title">
                              <h4>Delivery Options</h4>
                            </div>
                            <div className="checkout-detail">
                              <div className="row g-3">
                                <div className="col-xxl-6 col-lg-12 col-md-6">
                                  <div className="delivery-address-box">
                                    <input className="form-check-input" id="check7" name="checkbox2" type="radio"/>
                                    <label className="form-check-label" htmlFor="check7">Standard Delivery | Approx 5 to 7 Days</label>
                                  </div>
                                </div>
                                <div className="col-xxl-6 col-lg-12 col-md-6">
                                  <div className="delivery-address-box">
                                    <input defaultChecked className="form-check-input" id="check8" name="checkbox2" type="radio"/>
                                    <label className="form-check-label" htmlFor="check8">Express Delivery | Schedule </label>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </li>
                        <li>
                          <div className="checkout-box">
                            <div className="checkout-title">
                              <h4>Payment Options</h4>
                            </div>
                            <div className="checkout-detail">
                              <div className="row g-3">
                                <div className="col-sm-6">
                                  <div className="delivery-address-box">
                                    <input className="form-check-input" id="check9" name="checkbox3" type="radio"/>
                                    <label className="form-check-label" htmlFor="check9">CASH ON DELIVERY</label>
                                  </div>
                                </div>
                                <div className="col-sm-6">
                                  <div className="delivery-address-box">
                                    <input defaultChecked className="form-check-input" id="check10" name="checkbox3" type="radio"/>
                                    <label className="form-check-label" htmlFor="check10">PAYPAL</label>
                                  </div>
                                </div>
                                <div className="col-sm-6">
                                  <div className="delivery-address-box">
                                    <input className="form-check-input" id="check11" name="checkbox3" type="radio"/>
                                    <label className="form-check-label" htmlFor="check11">STRIPE</label>
                                  </div>
                                </div>
                                <div className="col-sm-6">
                                  <div className="delivery-address-box">
                                    <input className="form-check-input" id="check12" name="checkbox3" type="radio"/>
                                    <label className="form-check-label" htmlFor="check12">PAYSTACK</label>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
                <div className="col-lg-5">
                  <div className="checkout-right-box">
                    <div className="checkout-details">
                      <div className="order-box">
                        <div className="title-box">
                          <h4>Summary Order</h4>
                          <p>For a better experience, verify your goods and choose your shipping option.</p>
                        </div>
                        <ul className="qty">
                          {mounted && items.length === 0 ? (
                            <li className="text-center py-3">Your cart is empty</li>
                          ) : (
                            mounted && items.map((item) => (
                              <li key={item.id}>
                                <div className="cart-image">
                                  {/* eslint-disable-next-line @next/next/no-img-element */}
                                  <img alt={item.name} className="img-fluid" src={item.image}/>
                                </div>
                                <div className="cart-content">
                                  <div>
                                    <h4>{item.name}</h4>
                                    <h5>${item.price.toFixed(2)} X {item.quantity}</h5>
                                  </div>
                                  <span className="text-theme">${(item.price * item.quantity).toFixed(2)}</span>
                                </div>
                              </li>
                            ))
                          )}
                        </ul>
                      </div>
                    </div>
                    <div className="checkout-details">
                      <div className="order-box">
                        <div className="title-box">
                          <h4>Billing Summary</h4>
                          <div className="promo-code-box">
                            <div className="promo-title">
                              <h5>Promo code</h5>
                              <button className="btn" data-bs-target="#couponModal" data-bs-toggle="modal"><i className="ri-coupon-line"></i>View All</button>
                            </div>
                            <div className="row g-sm-3 g-2 mb-3">
                              <div className="col-md-6">
                                <div className="coupon-box">
                                  <div className="card-name">
                                    <h6>Holiday Savings</h6>
                                  </div>
                                  <div className="coupon-content">
                                    <div className="coupon-apply">
                                      <h6 className="coupon-code success-color">#HOLIDAY40</h6>
                                      <a className="btn theme-btn border-btn copy-btn mt-0" href="#!">Copy Code</a>
                                    </div>
                                  </div>
                                </div>
                              </div>
                              <div className="col-md-6">
                                <div className="coupon-box">
                                  <div className="card-name">
                                    <h6>Welcome Bonus</h6>
                                  </div>
                                  <div className="coupon-content">
                                    <div className="coupon-apply">
                                      <h6 className="coupon-code success-color">#NEWUSER20</h6>
                                      <a className="btn theme-btn border-btn copy-btn mt-0" href="#!">Copy Code</a>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </div>
                            <div className="coupon-input-box">
                              <input className="form-control" id="coupon" placeholder="Enter Coupon Code Here..." type="text"/>
                              <button className="apply-button btn">Apply now</button>
                            </div>
                          </div>

                          <div className="promo-code-box mt-4">
                            <div className="promo-title">
                              <h5>Referral Code</h5>
                            </div>
                            <div className="coupon-input-box">
                              <input 
                                className="form-control" 
                                id="referral" 
                                placeholder="E.g. ABA-1234-SHOE" 
                                type="text"
                                value={referralCode}
                                onChange={(e) => setReferralCode(e.target.value)}
                              />
                            </div>
                            <p className="text-xs text-muted mt-2">Enter a distributor's referral code to credit them with this sale.</p>
                          </div>
                        </div>
                        <div className="custom-box-loader">
                          <ul className="sub-total">
                            <li>Sub Total <span className="count">${total.toFixed(2)}</span></li>
                            <li> Shipping <span className="count">${shipping.toFixed(2)}</span></li>
                            <li> Tax <span className="count">${tax.toFixed(2)}</span></li>
                            <li>
                              <h4 className="txt-muted">Points</h4>
                              <h4 className="price txt-muted">$65.66</h4>
                            </li>
                          </ul>
                        </div>
                        <ul className="total">
                          <li>Total <span className="count">${(total + shipping + tax).toFixed(2)}</span></li>
                        </ul>
                        <div className="text-end">
                          <button className="btn order-btn" onClick={handlePlaceOrder} disabled={!mounted || items.length === 0}>Place Order</button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
