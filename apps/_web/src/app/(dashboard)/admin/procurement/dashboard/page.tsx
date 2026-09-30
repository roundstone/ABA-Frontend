'use client';

import Link from 'next/link';
import { FileText, Truck, Box, DollarSign } from 'lucide-react';
import MetricCard from '@/components/admin/dashboard/MetricCard';

export default function ProcurementDashboard() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Procurement Dashboard
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
                <li className="breadcrumb-item active">Procurement</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <MetricCard
            title="Pending Requisitions"
            value="12"
            Icon={FileText}
            colorClass="warning"
            subtitle=""
          />
          <MetricCard
            title="Active POs"
            value="5"
            Icon={Truck}
            colorClass="secondary"
            subtitle=""
          />
          <MetricCard
            title="Expected Deliveries"
            value="3"
            Icon={Box}
            colorClass="primary"
            subtitle=""
          />
          <MetricCard
            title="Total Payable"
            value="24,500"
            Icon={DollarSign}
            colorClass="danger"
            prefix="$"
            subtitle=""
          />
        </div>

        <div className="row">
          <div className="col-sm-12">
            <div className="card">
              <div className="card-header">
                <h5>Recent Purchase Orders</h5>
              </div>
              <div className="card-body">
                <div className="user-status table-responsive latest-order-table">
                  <table className="table table-bordernone">
                    <thead>
                      <tr>
                        <th>Order ID</th>
                        <th>Supplier</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>#PO-1023</td>
                        <td>Leather Supplies Inc.</td>
                        <td>2026-09-22</td>
                        <td>$5,000.00</td>
                        <td><span className="badge badge-secondary">Pending</span></td>
                      </tr>
                      <tr>
                        <td>#PO-1022</td>
                        <td>Sole Makers Ltd.</td>
                        <td>2026-09-20</td>
                        <td>$12,000.00</td>
                        <td><span className="badge badge-success">Delivered</span></td>
                      </tr>
                      <tr>
                        <td>#PO-1021</td>
                        <td>Thread & Co.</td>
                        <td>2026-09-18</td>
                        <td>$800.00</td>
                        <td><span className="badge badge-warning">In Transit</span></td>
                      </tr>
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
