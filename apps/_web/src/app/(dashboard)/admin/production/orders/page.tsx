'use client';

import Link from 'next/link';
import { Search, Plus, Eye, Edit } from 'lucide-react';

export default function ProductionOrders() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Production Orders
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
                <li className="breadcrumb-item">Production</li>
                <li className="breadcrumb-item active">Orders</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header">
            <form className="form-inline search-form search-box">
              <div className="form-group">
                <input className="form-control-plaintext" type="search" placeholder="Search Orders.." />
                <span className="d-sm-none mobile-search">
                  <Search />
                </span>
              </div>
            </form>
            <Link href="/admin/production/orders/create" className="btn btn-primary mt-md-0 mt-2 d-flex align-items-center gap-2">
              <Plus size={18} /> Create Order
            </Link>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table table-borderless">
                <thead>
                  <tr>
                    <th>Order ID</th>
                    <th>Product</th>
                    <th>Planned Qty</th>
                    <th>Completed Qty</th>
                    <th>Status</th>
                    <th>Dates</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>#PROD-2026-0042</td>
                    <td>Premium Leather Sneakers</td>
                    <td>500</td>
                    <td>420</td>
                    <td><span className="badge badge-warning">IN PROGRESS</span></td>
                    <td>
                      <div className="d-flex flex-column">
                        <small className="text-muted">Start: 2026-08-20</small>
                        <small className="text-muted">End: 2026-08-28</small>
                      </div>
                    </td>
                    <td>
                      <div className="d-flex align-items-center gap-2">
                        <Link href="#!" title="View"><Eye size={18} className="font-primary" /></Link>
                        <Link href="#!" title="Edit"><Edit size={18} className="font-success" /></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#PROD-2026-0041</td>
                    <td>Canvas High Tops</td>
                    <td>1000</td>
                    <td>1000</td>
                    <td><span className="badge badge-success">COMPLETED</span></td>
                    <td>
                      <div className="d-flex flex-column">
                        <small className="text-muted">Start: 2026-08-15</small>
                        <small className="text-muted">End: 2026-08-22</small>
                      </div>
                    </td>
                    <td>
                      <div className="d-flex align-items-center gap-2">
                        <Link href="#!" title="View"><Eye size={18} className="font-primary" /></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#PROD-2026-0043</td>
                    <td>Orthopedic Soles</td>
                    <td>250</td>
                    <td>0</td>
                    <td><span className="badge badge-secondary">MATERIAL ALLOCATED</span></td>
                    <td>
                      <div className="d-flex flex-column">
                        <small className="text-muted">Start: 2026-09-01</small>
                        <small className="text-muted">End: 2026-09-05</small>
                      </div>
                    </td>
                    <td>
                      <div className="d-flex align-items-center gap-2">
                        <Link href="#!" title="View"><Eye size={18} className="font-primary" /></Link>
                        <Link href="#!" title="Edit"><Edit size={18} className="font-success" /></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#PROD-2026-0044</td>
                    <td>Running Shoe Laces</td>
                    <td>5000</td>
                    <td>0</td>
                    <td><span className="badge badge-light text-dark">PLANNED</span></td>
                    <td>
                      <div className="d-flex flex-column">
                        <small className="text-muted">Start: 2026-09-10</small>
                        <small className="text-muted">End: 2026-09-15</small>
                      </div>
                    </td>
                    <td>
                      <div className="d-flex align-items-center gap-2">
                        <Link href="#!" title="View"><Eye size={18} className="font-primary" /></Link>
                        <Link href="#!" title="Edit"><Edit size={18} className="font-success" /></Link>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
