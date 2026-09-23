'use client';

import { OrderService, Order } from '@/services/mock/order.service';
import { CommissionService } from '@/services/mock/commission.service';
import { useState, useEffect } from 'react';
import Link from 'next/link';
import { Navigation, Box, MessageSquare, Users } from 'lucide-react';
import MarketValue from '@/components/admin/dashboard/MarketValue';
import SalesCarousel from '@/components/admin/dashboard/SalesCarousel';
import BuySell from '@/components/admin/dashboard/BuySell';
import GoodsReturn from '@/components/admin/dashboard/GoodsReturn';
import EmployeeStatus from '@/components/admin/dashboard/EmployeeStatus';
import SalesStatus from '@/components/admin/dashboard/SalesStatus';
import MetricCard from '@/components/admin/dashboard/MetricCard';

export default function AdminDashboard() {
  const [mounted, setMounted] = useState(false);
  const [metrics, setMetrics] = useState({
    totalEarnings: 0,
    totalProducts: 120, // Dummy
    totalMessages: 89, // Dummy
    newVendors: 15, // Dummy
  });
  const [latestOrders, setLatestOrders] = useState<Order[]>([]);

  useEffect(() => {
    setMounted(true);
    // Simulate API fetch for all metrics
    const fetchDashboardData = async () => {
      // Simulate network delay
      await new Promise(resolve => setTimeout(resolve, 500));
      
      const orders = OrderService.getOrders();
      const validOrders = orders.filter(o => o.status !== 'CANCELLED');
      const revenue = validOrders.reduce((sum, order) => sum + order.total, 0);

      setMetrics({
        totalEarnings: revenue,
        totalProducts: Math.floor(Math.random() * 50) + 100, // Dynamic mock
        totalMessages: Math.floor(Math.random() * 30) + 50,  // Dynamic mock
        newVendors: Math.floor(Math.random() * 10) + 5,      // Dynamic mock
      });
      setLatestOrders(orders.slice(0, 5));
    };

    fetchDashboardData();
  }, []);

  if (!mounted) return null;

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Dashboard
                  <small>ABA EPR Admin panel</small>
                </h3>
              </div>
            </div>
            <div className="col-lg-6">
              <ol className="breadcrumb pull-right">
                <li className="breadcrumb-item">
                  <Link href="/admin"><i data-feather="home"></i></Link>
                </li>
                <li className="breadcrumb-item active">Dashboard</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          {/* Metric Cards */}
          <MetricCard
            title="Earnings"
            value={metrics.totalEarnings.toFixed(2)}
            Icon={Navigation}
            colorClass="warning"
            prefix="$"
            subtitle="All Time"
          />
          <MetricCard
            title="Products"
            value={metrics.totalProducts}
            Icon={Box}
            colorClass="secondary"
            subtitle="This Month"
          />
          <MetricCard
            title="Messages"
            value={metrics.totalMessages}
            Icon={MessageSquare}
            colorClass="primary"
            subtitle="This Month"
          />
          <MetricCard
            title="New Merchants"
            value={metrics.newVendors}
            Icon={Users}
            colorClass="danger"
            subtitle="This Month"
          />

          <MarketValue />

          {/* Latest Orders */}
          <div className="col-xl-6 xl-100">
            <div className="card">
              <div className="card-header">
                <h5>Latest Orders</h5>
              </div>
              <div className="card-body">
                <div className="user-status table-responsive latest-order-table">
                  <table className="table table-bordernone">
                    <thead>
                      <tr>
                        <th scope="col">Order ID</th>
                        <th scope="col">Order Total</th>
                        <th scope="col">Payment Method</th>
                        <th scope="col">Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      {latestOrders.length === 0 ? (
                        <tr><td colSpan={4}>No orders found.</td></tr>
                      ) : (
                        latestOrders.map((order) => (
                          <tr key={order.id}>
                            <td>{order.id.slice(0, 8)}...</td>
                            <td className="digits">${order.total.toFixed(2)}</td>
                            <td className="font-secondary">{order.paymentMethod}</td>
                            <td className="digits">{order.status}</td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                  <Link href="/admin/orders" className="btn btn-primary mt-4">View All Orders</Link>
                </div>
              </div>
            </div>
          </div>

          <SalesCarousel />
          <BuySell />

          <GoodsReturn />

          <EmployeeStatus />

          <SalesStatus />

        </div>
      </div>
    </>
  );
}
