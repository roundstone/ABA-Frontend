'use client';

import Link from 'next/link';

export default function SupplierInvoices() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Supplier Invoices
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
                <li className="breadcrumb-item active">Invoices</li>
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
                <input className="form-control-plaintext" type="search" placeholder="Search Invoices.." />
                <span className="d-sm-none mobile-search">
                  <i data-feather="search"></i>
                </span>
              </div>
            </form>
            <Link href="#!" className="btn btn-primary mt-md-0 mt-2">Log New Invoice</Link>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table table-borderless">
                <thead>
                  <tr>
                    <th>Invoice ID</th>
                    <th>Supplier</th>
                    <th>Linked PO</th>
                    <th>Invoice Date</th>
                    <th>Due Date</th>
                    <th>Amount</th>
                    <th>Payment Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>INV-8820</td>
                    <td>Sole Makers Ltd.</td>
                    <td><Link href="/admin/procurement/orders">#PO-1022</Link></td>
                    <td>2026-09-24</td>
                    <td>2026-10-24</td>
                    <td>$12,000.00</td>
                    <td><span className="badge badge-warning">Unpaid</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!" className="btn btn-sm btn-solid">Mark Paid</Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>INV-8815</td>
                    <td>Thread & Co.</td>
                    <td><Link href="/admin/procurement/orders">#PO-1021</Link></td>
                    <td>2026-09-22</td>
                    <td>2026-10-22</td>
                    <td>$800.00</td>
                    <td><span className="badge badge-success">Paid</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-eye font-primary" title="View Details"></i></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>INV-8790</td>
                    <td>Leather Supplies Inc.</td>
                    <td><Link href="/admin/procurement/orders">#PO-1015</Link></td>
                    <td>2026-09-10</td>
                    <td>2026-10-10</td>
                    <td>$2,500.00</td>
                    <td><span className="badge badge-danger">Overdue</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!" className="btn btn-sm btn-solid">Process Payment</Link>
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
