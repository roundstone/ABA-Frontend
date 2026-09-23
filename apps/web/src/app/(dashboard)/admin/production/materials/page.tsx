'use client';

import Link from 'next/link';
import { CheckCircle, XCircle } from 'lucide-react';

export default function ProductionMaterials() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Material Requirements & Allocation
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
                <li className="breadcrumb-item active">Materials</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h5>Materials Needed For Active Orders</h5>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table table-borderless">
                <thead>
                  <tr>
                    <th>Production Order</th>
                    <th>Required Material</th>
                    <th>Qty Required</th>
                    <th>In Stock</th>
                    <th>Allocation Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td rowSpan={2} className="align-middle border-end">#PROD-2026-0042</td>
                    <td>Premium Leather (sq. m)</td>
                    <td>1000</td>
                    <td>1200</td>
                    <td><span className="badge badge-success"><CheckCircle size={14} className="me-1"/> Allocated</span></td>
                    <td><button className="btn btn-sm btn-light" disabled>Allocated</button></td>
                  </tr>
                  <tr className="border-bottom">
                    <td>Rubber Soles (pairs)</td>
                    <td>500</td>
                    <td>500</td>
                    <td><span className="badge badge-success"><CheckCircle size={14} className="me-1"/> Allocated</span></td>
                    <td><button className="btn btn-sm btn-light" disabled>Allocated</button></td>
                  </tr>
                  
                  <tr>
                    <td rowSpan={2} className="align-middle border-end">#PROD-2026-0043</td>
                    <td>Orthopedic Foam (kg)</td>
                    <td>50</td>
                    <td>10</td>
                    <td><span className="badge badge-danger"><XCircle size={14} className="me-1"/> Shortage (40)</span></td>
                    <td><Link href="/admin/procurement/orders/create" className="btn btn-sm btn-primary">Create PO</Link></td>
                  </tr>
                  <tr className="border-bottom">
                    <td>Fabric Mesh (m)</td>
                    <td>100</td>
                    <td>300</td>
                    <td><span className="badge badge-warning">Pending Allocation</span></td>
                    <td><button className="btn btn-sm btn-solid">Allocate</button></td>
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
