'use client';

import Link from 'next/link';

export default function SupplierManagement() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Suppliers
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
                <li className="breadcrumb-item active">Suppliers</li>
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
                <input className="form-control-plaintext" type="search" placeholder="Search Suppliers.." />
                <span className="d-sm-none mobile-search">
                  <i data-feather="search"></i>
                </span>
              </div>
            </form>
            <Link href="#!" className="btn btn-primary mt-md-0 mt-2">Add New Supplier</Link>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table table-borderless">
                <thead>
                  <tr>
                    <th>Supplier Name</th>
                    <th>Category</th>
                    <th>Contact Info</th>
                    <th>Materials Supplied</th>
                    <th>Outstanding Payable</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Leather Supplies Inc.</td>
                    <td>Raw Materials</td>
                    <td>sales@leathersupplies.com</td>
                    <td>Premium Leather, Dye</td>
                    <td>$5,000.00</td>
                    <td><span className="badge badge-success">Active</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-edit me-2 font-success" title="Edit"></i></Link>
                        <Link href="#!"><i className="fa fa-trash font-danger ms-3" title="Delete"></i></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>Sole Makers Ltd.</td>
                    <td>Components</td>
                    <td>contact@solemakers.com</td>
                    <td>Rubber Soles, Insoles</td>
                    <td>$12,000.00</td>
                    <td><span className="badge badge-success">Active</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-edit me-2 font-success" title="Edit"></i></Link>
                        <Link href="#!"><i className="fa fa-trash font-danger ms-3" title="Delete"></i></Link>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td>Thread & Co.</td>
                    <td>Consumables</td>
                    <td>info@threadco.com</td>
                    <td>Nylon Threads, Laces</td>
                    <td>$0.00</td>
                    <td><span className="badge badge-warning">Inactive</span></td>
                    <td>
                      <div className="d-flex align-items-center">
                        <Link href="#!"><i className="fa fa-edit me-2 font-success" title="Edit"></i></Link>
                        <Link href="#!"><i className="fa fa-trash font-danger ms-3" title="Delete"></i></Link>
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
