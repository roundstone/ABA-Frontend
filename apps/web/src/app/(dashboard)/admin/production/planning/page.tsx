'use client';

import Link from 'next/link';

export default function ProductionPlanning() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Production Planning
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
                <li className="breadcrumb-item active">Planning</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h5>Demand-to-Production Forecast</h5>
            <Link href="/admin/production/planning/generate" className="btn btn-primary">Generate Schedule</Link>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table">
                <thead>
                  <tr>
                    <th>Product</th>
                    <th>Current Inventory</th>
                    <th>Projected Demand (30 Days)</th>
                    <th>Production Requirement</th>
                    <th>Suggested Start</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Premium Leather Sneakers</td>
                    <td>120 units</td>
                    <td>600 units</td>
                    <td><span className="text-danger fw-bold">480 units</span></td>
                    <td>2026-09-25</td>
                    <td><Link href="/admin/production/orders/create" className="btn btn-sm btn-solid">Schedule Run</Link></td>
                  </tr>
                  <tr>
                    <td>Canvas High Tops</td>
                    <td>800 units</td>
                    <td>500 units</td>
                    <td><span className="text-success fw-bold">0 units</span></td>
                    <td>N/A</td>
                    <td><button className="btn btn-sm btn-light" disabled>Sufficient Stock</button></td>
                  </tr>
                  <tr>
                    <td>Orthopedic Soles</td>
                    <td>50 units</td>
                    <td>300 units</td>
                    <td><span className="text-danger fw-bold">250 units</span></td>
                    <td>2026-09-28</td>
                    <td><Link href="/admin/production/orders/create" className="btn btn-sm btn-solid">Schedule Run</Link></td>
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
