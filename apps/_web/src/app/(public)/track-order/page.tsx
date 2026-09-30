'use client';

import Breadcrumb from '@/components/ui/Breadcrumb';
import { useState, useEffect, Suspense } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import { OrderService, Order } from '@/services/mock/order.service';

function TrackOrderContent() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const initialId = searchParams?.get('id') || '';
  
  const [orderId, setOrderId] = useState(initialId);
  const [order, setOrder] = useState<Order | null>(null);
  const [searched, setSearched] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    if (initialId) {
      handleSearch(initialId);
    }
  }, [initialId]);

  const handleSearch = (idToSearch: string) => {
    setSearched(true);
    if (idToSearch.trim()) {
      const fetchedOrder = OrderService.getOrderById(idToSearch.trim());
      setOrder(fetchedOrder || null);
    }
  };

  if (!mounted) return null;

  return (
    <>
      <Breadcrumb title="track order" items={[{ label: 'Home', url: '/' }, { label: 'Track Order' }]} />

      <section className="tracking-page section-b-space">
        <div className="container">
          <div className="row justify-content-center mb-5">
            <div className="col-lg-6">
              <div className="search-bar">
                <h3 className="mb-3 text-center">Track Your Order</h3>
                <div className="input-group mb-3">
                  <input 
                    type="text" 
                    className="form-control" 
                    placeholder="Enter your Order ID (e.g. ord_xxx)" 
                    value={orderId}
                    onChange={(e) => setOrderId(e.target.value)}
                  />
                  <button 
                    className="btn btn-solid" 
                    type="button"
                    onClick={() => {
                      router.replace(`/track-order?id=${orderId}`);
                      handleSearch(orderId);
                    }}
                  >
                    Track
                  </button>
                </div>
              </div>
            </div>
          </div>

          {searched && !order && (
            <div className="text-center mt-5">
              <h4>Order not found</h4>
              <p className="text-muted">Please check your Order ID and try again.</p>
            </div>
          )}

          {order && (
            <>
              <div className="title-header mb-3">
                <h5>Order Number: #{order.id}</h5>
              </div>
              <div className="table-responsive">
                <table className="table tacking-table">
                  <thead>
                    <tr>
                      <th>Image</th>
                      <th>Product Name</th>
                      <th>Price</th>
                      <th>Quantity</th>
                      <th>Sub Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {order.items.map(item => (
                      <tr key={item.id}>
                        <td className="product-image">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img alt={item.productName} className="img-fluid" src={item.image || '/images/fashion-1/product/1.jpg'}/>
                        </td>
                        <td>
                          <h6>{item.productName}</h6>
                        </td>
                        <td>
                          <h6>${item.price.toFixed(2)}</h6>
                        </td>
                        <td>
                          <h6>{item.quantity}</h6>
                        </td>
                        <td>
                          <h6>${(item.price * item.quantity).toFixed(2)}</h6>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
              <div className="summary-details my-3">
                <div className="row g-4">
                  <div className="col-xxl-8 col-lg-12 col-md-7">
                    <div className="details-box">
                      <h3 className="order-title">Delivery Details</h3>
                      <div className="customer-detail tracking-wrapper">
                        <ul className="row g-3">
                          <li className="col-sm-6">
                            <label>Shipping Address:</label>
                            <h4>{order.shippingAddress || 'N/A'}</h4>
                          </li>
                          <li className="col-sm-6">
                            <label>Order Date:</label>
                            <h4>{new Date(order.createdAt).toLocaleDateString()}</h4>
                          </li>
                          <li className="col-sm-3">
                            <label>Payment Method:</label>
                            <div className="d-flex align-items-center gap-2">
                              <h4>{order.paymentMethod || 'PAYPAL'}</h4>
                            </div>
                          </li>
                          <li className="col-sm-3">
                            <label>Status:</label>
                            <div className="d-flex align-items-center gap-2">
                              <h4>{order.status}</h4>
                            </div>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                  <div className="col-xxl-4 col-lg-12 col-md-5">
                    <div className="details-box">
                      <h3 className="fw-semibold mb-3 order-title"> Summary </h3>
                      <ul className="tracking-total tracking-wrapper">
                        <li>Sub Total <span>${order.subtotal.toFixed(2)}</span></li>
                        <li>Shipping <span>${order.shipping.toFixed(2)}</span></li>
                        <li>Tax <span>${order.tax.toFixed(2)}</span></li>
                        <li>Total <span>${order.total.toFixed(2)}</span></li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </>
          )}
        </div>
      </section>
    </>
  );
}

export default function TrackOrderPage() {
  return (
    <Suspense fallback={<div>Loading track order page...</div>}>
      <TrackOrderContent />
    </Suspense>
  );
}
