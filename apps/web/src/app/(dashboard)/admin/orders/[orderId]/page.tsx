'use client';

import { OrderService, Order } from '@/services/mock/order.service';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

export default function AdminOrderDetail() {
  const params = useParams();
  const orderId = params?.orderId as string;
  const [order, setOrder] = useState<Order | null>(null);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    if (orderId) {
      setOrder(OrderService.getOrderById(orderId) || null);
    }
  }, [orderId]);

  if (!mounted) return null;

  if (!order) {
    return (
      <div className="container-fluid text-center mt-5">
        <h3>Order Not Found</h3>
        <Link href="/admin/orders" className="btn btn-primary mt-3">Back to Orders</Link>
      </div>
    );
  }

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Order Details
                  <small>ABA ERP Admin panel</small>
                </h3>
              </div>
            </div>
            <div className="col-lg-6">
              <ol className="breadcrumb pull-right">
                <li className="breadcrumb-item">
                  <Link href="/admin">
                    <i data-feather="home"></i>
                  </Link>
                </li>
                <li className="breadcrumb-item">Sales</li>
                <li className="breadcrumb-item active">Order Details</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-sm-12">
            <div className="card">
              <div className="card-body">
                <div className="bg-inner cart-section order-details-table">
                  <div className="row g-4">
                    <div className="col-xl-8">
                      <div className="card-details-title">
                        <h3>Order Number <span>#{order.id}</span></h3>
                      </div>
                      <div className="table-responsive table-details">
                        <table className="table cart-table table-borderless">
                          <thead>
                            <tr>
                              <th colSpan={2}>Items</th>
                              <th className="text-end" colSpan={2}>
                                <a href="#!" className="theme-color">Edit Items</a>
                              </th>
                            </tr>
                          </thead>

                          <tbody>
                            {order.items.map((item) => (
                              <tr className="table-order" key={item.id}>
                                <td>
                                  <a href="#!">
                                    {/* eslint-disable-next-line @next/next/no-img-element */}
                                    <img src={item.image || '/images/fashion/1.jpg'} className="img-fluid blur-up lazyload" alt={item.productName} style={{ width: '60px', height: '60px', objectFit: 'cover' }} />
                                  </a>
                                </td>
                                <td>
                                  <p>Product Name</p>
                                  <h5>{item.productName}</h5>
                                </td>
                                <td>
                                  <p>Quantity</p>
                                  <h5>{item.quantity}</h5>
                                </td>
                                <td>
                                  <p>Price</p>
                                  <h5>${item.price.toFixed(2)}</h5>
                                </td>
                              </tr>
                            ))}
                          </tbody>

                          <tfoot>
                            <tr className="table-order">
                              <td colSpan={3}>
                                <h5>Subtotal :</h5>
                              </td>
                              <td>
                                <h4>${order.subtotal.toFixed(2)}</h4>
                              </td>
                            </tr>

                            <tr className="table-order">
                              <td colSpan={3}>
                                <h5>Shipping :</h5>
                              </td>
                              <td>
                                <h4>${order.shipping.toFixed(2)}</h4>
                              </td>
                            </tr>

                            <tr className="table-order">
                              <td colSpan={3}>
                                <h5>Tax :</h5>
                              </td>
                              <td>
                                <h4>${order.tax.toFixed(2)}</h4>
                              </td>
                            </tr>

                            <tr className="table-order">
                              <td colSpan={3}>
                                <h4 className="theme-color fw-bold">Total Price :</h4>
                              </td>
                              <td>
                                <h4 className="theme-color fw-bold">${order.total.toFixed(2)}</h4>
                              </td>
                            </tr>
                          </tfoot>
                        </table>
                      </div>
                    </div>

                    <div className="col-xl-4">
                      <div className="order-success">
                        <div className="row g-4">
                          <h4>Summary</h4>
                          <ul className="order-details">
                            <li>Order ID: {order.id}</li>
                            <li>Order Date: {new Date(order.createdAt).toLocaleDateString()}</li>
                            <li>Order Total: ${order.total.toFixed(2)}</li>
                          </ul>

                          <h4>Shipping Address</h4>
                          <ul className="order-details">
                            <li>{order.shippingAddress || 'N/A'}</li>
                          </ul>

                          <div className="payment-mode">
                            <h4>Payment Method</h4>
                            <p>{order.paymentMethod || 'PAYPAL'}</p>
                          </div>

                          <div className="delivery-sec">
                            <h3>Expected date of delivery: <span>{new Date(Date.now() + 86400000 * 5).toLocaleDateString()}</span></h3>
                            <Link href={`/admin/orders/${order.id}/tracking`} className="btn btn-primary mt-3">Track Order</Link>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
