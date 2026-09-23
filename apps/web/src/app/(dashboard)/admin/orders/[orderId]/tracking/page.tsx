'use client';

import { OrderService, Order, OrderTrackingEvent } from '@/services/mock/order.service';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

export default function AdminOrderTracking() {
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

  // Assuming order.items[0] represents the main item for display in tracking
  const mainItem = order.items[0];
  const history = order.trackingHistory || [];

  // Helper to determine status for progress tracker
  const getStatusClass = (stepStatus: string) => {
    const statusOrder = ['PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED'];
    const currentIndex = statusOrder.indexOf(order.status);
    const stepIndex = statusOrder.indexOf(stepStatus);

    return stepIndex <= currentIndex ? 'progtrckr-done' : 'progtrckr-todo';
  };

  const getStatusDate = (stepStatus: string) => {
    const event = history.find(h => h.status === stepStatus);
    if (event) {
      return new Date(event.date).toLocaleDateString();
    }
    return 'Pending';
  };

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Order Tracking
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
                <li className="breadcrumb-item active">Order Tracking</li>
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
                <div className="row">
                  <div className="col-12 overflow-hidden">
                    <div className="order-left-image">
                      <div className="tracking-product-image">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img src={mainItem?.image || '/images/fashion/1.jpg'} className="img-fluid w-100 blur-up lazyload" alt={mainItem?.productName} />
                      </div>

                      <div className="order-image-contain">
                        <h4>{mainItem?.productName || 'Order Package'}</h4>
                        <div className="tracker-number">
                          <p>Order Number : <span>{order.id}</span></p>
                          <p>Order Placed : <span>{new Date(order.createdAt).toLocaleDateString()}</span></p>
                        </div>
                        <h5>{order.status === 'DELIVERED' ? 'Your item has been delivered.' : 'Your item is on the way. Tracking information is below.'}</h5>
                      </div>
                    </div>
                  </div>

                  <ol className="progtrckr">
                    <li className={getStatusClass('PENDING')}>
                      <h5>Order Placed</h5>
                      <h6>{getStatusDate('PENDING')}</h6>
                    </li>
                    <li className={getStatusClass('PROCESSING')}>
                      <h5>Processing</h5>
                      <h6>{getStatusDate('PROCESSING')}</h6>
                    </li>
                    <li className={getStatusClass('SHIPPED')}>
                      <h5>Shipped</h5>
                      <h6>{getStatusDate('SHIPPED')}</h6>
                    </li>
                    <li className={getStatusClass('DELIVERED')}>
                      <h5>Delivered</h5>
                      <h6>{getStatusDate('DELIVERED')}</h6>
                    </li>
                  </ol>

                  <div className="col-12 overflow-visible">
                    <div className="tracker-table all-package">
                      <div className="table-responsive">
                        <table className="table">
                          <thead>
                            <tr className="table-head">
                              <th scope="col">Date</th>
                              <th scope="col">Time</th>
                              <th scope="col">Description</th>
                              <th scope="col">Location</th>
                            </tr>
                          </thead>

                          <tbody>
                            {[...history].reverse().map((event, index) => (
                              <tr key={index}>
                                <td>
                                  <h6>{new Date(event.date).toLocaleDateString()}</h6>
                                </td>
                                <td>
                                  <h6>{new Date(event.date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</h6>
                                </td>
                                <td>
                                  <p className="fw-bold">{event.status}</p>
                                  <p>{event.description}</p>
                                </td>
                                <td>
                                  <p>{event.location || 'N/A'}</p>
                                </td>
                              </tr>
                            ))}
                          </tbody>
                        </table>
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
