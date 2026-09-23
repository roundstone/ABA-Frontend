'use client';

import Link from 'next/link';

export default function Requisitions() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Purchase Requisitions
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
                <li className="breadcrumb-item">Procurement</li>
                <li className="breadcrumb-item active">Requisitions</li>
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
                <input className="form-control-plaintext" type="search" placeholder="Search Requisitions.." />
                <span className="d-sm-none mobile-search">
                  <i data-feather="search"></i>
                </span>
              </div>
            </form>
            <Link href="#!" className="btn btn-primary mt-md-0 mt-2">Create Requisition</Link>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table table-borderless">
                <thead>
                  <tr>
                    <th>Req ID</th>
                    <th>Requested By</th>
                    <th>Department</th>
                    <th>Material</th>
                    <th>Quantity</th>
                    <th>Date Needed</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>#REQ-001</td>
                    <td>Jane Smith</td>
                    <td>Production</td>
                    <td>Premium Leather (Black)</td>
                    <td>500 sq ft</td>
                    <td>2026-10-01</td>
                    <td><span className="badge badge-warning">Pending Approval</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!" className="btn btn-sm btn-solid">Review</Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#REQ-002</td>
                    <td>Mike Johnson</td>
                    <td>Inventory</td>
                    <td>Rubber Soles (Size 42)</td>
                    <td>1000 pairs</td>
                    <td>2026-10-05</td>
                    <td><span className="badge badge-success">Approved</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!" className="btn btn-sm btn-outline">Convert to PO</Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#REQ-003</td>
                    <td>Jane Smith</td>
                    <td>Production</td>
                    <td>Nylon Threads</td>
                    <td>50 spools</td>
                    <td>2026-09-25</td>
                    <td><span className="badge badge-danger">Rejected</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-eye font-primary" title="View"></i></Link>
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
