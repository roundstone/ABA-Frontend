'use client';

import Link from 'next/link';

export default function GoodsReceiving() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Goods Receiving
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
                <li className="breadcrumb-item active">Receiving</li>
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
                <input className="form-control-plaintext" type="search" placeholder="Search by PO or Supplier.." />
                <span className="d-sm-none mobile-search">
                  <i data-feather="search"></i>
                </span>
              </div>
            </form>
            <Link href="#!" className="btn btn-primary mt-md-0 mt-2">Log New Delivery</Link>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table table-borderless">
                <thead>
                  <tr>
                    <th>Receipt ID</th>
                    <th>PO Number</th>
                    <th>Supplier</th>
                    <th>Date Received</th>
                    <th>Items Received</th>
                    <th>Inventory Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>#REC-2055</td>
                    <td>#PO-1022</td>
                    <td>Sole Makers Ltd.</td>
                    <td>2026-09-23</td>
                    <td>Rubber Soles (1000 pairs)</td>
                    <td><span className="badge badge-success">Updated</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-eye font-primary" title="View Details"></i></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#REC-2054</td>
                    <td>#PO-1021</td>
                    <td>Thread & Co.</td>
                    <td>2026-09-21</td>
                    <td>Nylon Threads (50 spools)</td>
                    <td><span className="badge badge-success">Updated</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-eye font-primary" title="View Details"></i></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#REC-2053</td>
                    <td>#PO-1015</td>
                    <td>Leather Supplies Inc.</td>
                    <td>2026-09-15</td>
                    <td>Premium Leather (Partial: 200 sq ft)</td>
                    <td><span className="badge badge-warning">Pending Putaway</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!" className="btn btn-sm btn-outline">Complete Putaway</Link>
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
