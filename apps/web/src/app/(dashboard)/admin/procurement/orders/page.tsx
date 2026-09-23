'use client';

import Link from 'next/link';

export default function PurchaseOrders() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Purchase Orders
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
                <input className="form-control-plaintext" type="search" placeholder="Search POs.." />
                <span className="d-sm-none mobile-search">
                  <i data-feather="search"></i>
                </span>
              </div>
            </form>
            <Link href="#!" className="btn btn-primary mt-md-0 mt-2">Create PO</Link>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table table-borderless">
                <thead>
                  <tr>
                    <th>PO Number</th>
                    <th>Supplier</th>
                    <th>Order Date</th>
                    <th>Expected Delivery</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>#PO-1023</td>
                    <td>Leather Supplies Inc.</td>
                    <td>2026-09-22</td>
                    <td>2026-10-01</td>
                    <td>$5,000.00</td>
                    <td><span className="badge badge-secondary">Draft</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-edit me-2 font-success" title="Edit"></i></Link>
                        <Link href="#!"><i className="fa fa-paper-plane font-primary" title="Send to Supplier"></i></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#PO-1022</td>
                    <td>Sole Makers Ltd.</td>
                    <td>2026-09-20</td>
                    <td>2026-09-25</td>
                    <td>$12,000.00</td>
                    <td><span className="badge badge-warning">Sent (Awaiting Delivery)</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-eye font-primary me-2" title="View"></i></Link>
                        <Link href="#!" className="btn btn-sm btn-solid">Receive Goods</Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>#PO-1021</td>
                    <td>Thread & Co.</td>
                    <td>2026-09-18</td>
                    <td>2026-09-20</td>
                    <td>$800.00</td>
                    <td><span className="badge badge-success">Completed</span></td>
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
