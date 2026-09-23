'use client';

import Link from 'next/link';
import { Layers, AlertTriangle, DollarSign, Target } from 'lucide-react';
import MetricCard from '@/components/admin/dashboard/MetricCard';

export default function ProductionDashboard() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Production Dashboard
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
                <li className="breadcrumb-item active">Production</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <MetricCard
            title="Active Orders"
            value="8"
            Icon={Layers}
            colorClass="warning"
          />
          <MetricCard
            title="Production Rate"
            value="94"
            Icon={Target}
            colorClass="secondary"
            suffix="%"
          />
          <MetricCard
            title="Wastage Rate"
            value="2.4"
            Icon={AlertTriangle}
            colorClass="primary"
            suffix="%"
          />
          <MetricCard
            title="Total Costs"
            value="142,500"
            Icon={DollarSign}
            colorClass="danger"
            prefix="$"
          />
        </div>

        <div className="row">
          <div className="col-sm-12">
            <div className="card">
              <div className="card-header">
                <h5>Recent Production Orders</h5>
              </div>
              <div className="card-body">
                <div className="user-status table-responsive latest-order-table">
                  <table className="table table-bordernone">
                    <thead>
                      <tr>
                        <th>Order ID</th>
                        <th>Product</th>
                        <th>Planned Qty</th>
                        <th>Completed Qty</th>
                        <th>Status</th>
                        <th>Start Date</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>#PROD-2026-0042</td>
                        <td>Premium Leather Sneakers</td>
                        <td>500</td>
                        <td>420</td>
                        <td><span className="badge badge-warning">In Progress</span></td>
                        <td>2026-08-20</td>
                      </tr>
                      <tr>
                        <td>#PROD-2026-0041</td>
                        <td>Canvas High Tops</td>
                        <td>1000</td>
                        <td>1000</td>
                        <td><span className="badge badge-success">Completed</span></td>
                        <td>2026-08-15</td>
                      </tr>
                      <tr>
                        <td>#PROD-2026-0043</td>
                        <td>Orthopedic Soles</td>
                        <td>250</td>
                        <td>0</td>
                        <td><span className="badge badge-secondary">Material Allocated</span></td>
                        <td>2026-09-01</td>
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
