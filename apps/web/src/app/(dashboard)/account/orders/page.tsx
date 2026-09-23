"use client";

import { useAuthStore } from '@/store/useAuthStore';
import { OrderService, Order } from '@/services/mock/order.service';
import { useState, useEffect } from 'react';
import Link from 'next/link';

export default function AccountOrdersPage() {
  const { user } = useAuthStore();
  const [orders, setOrders] = useState<Order[]>([]);
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    if (user) {
      const userOrders = OrderService.getUserOrders(user.id);
      setOrders(userOrders);
      if (userOrders.length > 0) {
        setSelectedOrder(userOrders[0]);
      }
    }
  }, [user]);

  if (!mounted) return null;

  return (
    <div className="tab-pane fade show active">
      <div className="dashboard-right">
        <div className="dashboard">
          <div className="page-title">
            <h2>My Orders</h2>
          </div>
          
          <div className="welcome-msg border-0 mb-4 p-0 bg-transparent">
            <p>View your order history and track delivery statuses.</p>
          </div>

          <div className="box-account box-info">
            {selectedOrder && (
              <div className="mb-5 border p-4 rounded bg-light">
                <div className="title-header mb-3">
                  <h5>Order Number: {selectedOrder.id}</h5>
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
                      {selectedOrder.items.map((item) => (
                        <tr key={item.id}>
                          <td className="product-image">
                            {/* eslint-disable-next-line @next/next/no-img-element */}
                            <img alt={item.productName} className="img-fluid" src={item.image || '/images/fashion-1/product/1.jpg'} style={{ height: '60px', objectFit: 'contain' }} />
                          </td>
                          <td>
                            <h6>{item.productName}</h6>
                          </td>
                          <td>
                            <h6>₦{item.price.toFixed(2)}</h6>
                          </td>
                          <td>
                            <h6>{item.quantity}</h6>
                          </td>
                          <td>
                            <h6>₦{(item.price * item.quantity).toFixed(2)}</h6>
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
                        <h5 className="order-title mb-3">Consumer Details</h5>
                        <div className="customer-detail tracking-wrapper">
                          <ul className="row g-3 list-unstyled">
                            <li className="col-sm-6">
                              <label className="text-muted text-sm">Shipping Address:</label>
                              <h6 className="fw-bold">{selectedOrder.shippingAddress || 'N/A'}</h6>
                            </li>
                            <li className="col-sm-3">
                              <label className="text-muted text-sm">Payment Mode:</label>
                              <div className="d-flex align-items-center gap-2">
                                <h6 className="fw-bold">{selectedOrder.paymentMethod || 'PAYPAL'}</h6>
                              </div>
                            </li>
                            <li className="col-sm-3">
                              <label className="text-muted text-sm">Status:</label>
                              <div className="d-flex align-items-center gap-2">
                                <h6 className="fw-bold text-primary">{selectedOrder.status}</h6>
                              </div>
                            </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                    <div className="col-xxl-4 col-lg-12 col-md-5">
                      <div className="details-box bg-white p-3 border rounded">
                        <h5 className="fw-semibold mb-3 order-title">Summary</h5>
                        <ul className="tracking-total tracking-wrapper list-unstyled mb-0">
                          <li className="d-flex justify-content-between mb-2"><span>Sub Total</span> <span className="fw-bold">₦{selectedOrder.subtotal.toFixed(2)}</span></li>
                          <li className="d-flex justify-content-between mb-2"><span>Shipping</span> <span className="fw-bold">₦{selectedOrder.shipping.toFixed(2)}</span></li>
                          <li className="d-flex justify-content-between mb-2"><span>Tax</span> <span className="fw-bold">₦{selectedOrder.tax.toFixed(2)}</span></li>
                          <li className="d-flex justify-content-between mt-2 pt-2 border-top"><span>Total</span> <span className="fw-bold text-primary">₦{selectedOrder.total.toFixed(2)}</span></li>
                        </ul>
                        
                        <div className="mt-3 pt-3 border-top text-center">
                          <Link href={`/track-order?id=${selectedOrder.id}`} className="btn btn-solid btn-sm w-100">
                            Track Publicly
                          </Link>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            <div className="title-header mb-3">
              <h5>All Orders</h5>
            </div>
            <div className="table-responsive">
              <table className="table tacking-table table-bordered">
                <thead className="bg-light">
                  <tr>
                    <th>Order Number</th>
                    <th>Order Date</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  {orders.length === 0 ? (
                    <tr>
                      <td colSpan={5} className="text-center py-4 text-muted">No orders found.</td>
                    </tr>
                  ) : (
                    orders.map(order => (
                      <tr key={order.id} className={selectedOrder?.id === order.id ? 'bg-light' : ''}>
                        <td>
                          <h6>{order.id}</h6>
                        </td>
                        <td>
                          <h6>{new Date(order.createdAt).toLocaleString()}</h6>
                        </td>
                        <td>
                          <h6 className="fw-bold">₦{order.total.toFixed(2)}</h6>
                        </td>
                        <td>
                          <h6>
                            <span className={`badge ${order.status === 'DELIVERED' ? 'bg-success' : 'bg-warning text-dark'}`}>
                              {order.status}
                            </span>
                          </h6>
                        </td>
                        <td>
                          <button 
                            className="btn btn-sm btn-outline-primary" 
                            onClick={() => setSelectedOrder(order)}
                          >
                            View Details
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
