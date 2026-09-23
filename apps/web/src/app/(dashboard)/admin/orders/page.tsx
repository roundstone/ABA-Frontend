'use client';

import { OrderService, Order } from '@/services/mock/order.service';
import Link from 'next/link';
import { useEffect, useState } from 'react';

export default function AdminOrderList() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    setOrders(OrderService.getOrders());
  }, []);

  if (!mounted) return null;

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Order List
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
                <li className="breadcrumb-item active">Order List</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-sm-12">
            <div className="card">
              <div className="card-header">
                <form className="form-inline search-form search-box">
                  <div className="form-group">
                    <input className="form-control-plaintext" type="search" placeholder="Search.." />
                  </div>
                </form>
              </div>
              <div className="card-body">
                <div className="table-responsive table-desi">
                  <table className="table all-package order-list-table" id="editableTable">
                    <thead>
                      <tr>
                        <th>Order Code</th>
                        <th>Date</th>
                        <th>Payment Method</th>
                        <th>Delivery Status</th>
                        <th>Amount</th>
                        <th>Option</th>
                      </tr>
                    </thead>

                    <tbody>
                      {orders.map((order) => (
                        <tr key={order.id}>
                          <td data-field="number">{order.id}</td>
                          <td data-field="date">{new Date(order.createdAt).toLocaleDateString()}</td>
                          <td data-field="text">{order.paymentMethod || 'Credit Card'}</td>
                          <td className={order.status === 'DELIVERED' ? 'order-success' : order.status === 'PENDING' ? 'order-warning' : 'order-pending'}>
                            <span>{order.status}</span>
                          </td>
                          <td data-field="number">${order.total.toFixed(2)}</td>
                          <td>
                            <Link href={`/admin/orders/${order.id}`}>
                              <i className="fa fa-eye" title="View Detail"></i>
                            </Link>
                            <Link href={`/admin/orders/${order.id}/tracking`} className="ms-2">
                              <i className="fa fa-truck" title="Track Order"></i>
                            </Link>
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
    </>
  );
}
