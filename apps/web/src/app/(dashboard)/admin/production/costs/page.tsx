'use client';

import Link from 'next/link';

export default function ProductionCosts() {
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Production Costs
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
                <li className="breadcrumb-item active">Costs</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header">
            <h5>Cost Analysis by Production Order</h5>
          </div>
          <div className="card-body">
            <div className="table-responsive">
              <table className="table table-bordered text-center align-middle">
                <thead className="bg-light">
                  <tr>
                    <th rowSpan={2} className="align-middle">Order ID</th>
                    <th rowSpan={2} className="align-middle">Product</th>
                    <th rowSpan={2} className="align-middle">Finished Units</th>
                    <th colSpan={5}>Cost Breakdown (USD)</th>
                    <th rowSpan={2} className="align-middle bg-primary text-white">Total Cost</th>
                    <th rowSpan={2} className="align-middle bg-secondary text-white">Cost per Unit</th>
                  </tr>
                  <tr>
                    <th>Raw Material</th>
                    <th>Packaging</th>
                    <th>Direct Labour</th>
                    <th>Overhead</th>
                    <th>Wastage</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td className="fw-bold text-start">#PROD-2026-0041</td>
                    <td className="text-start">Canvas High Tops</td>
                    <td>1000</td>
                    <td>$4,500.00</td>
                    <td>$500.00</td>
                    <td>$1,200.00</td>
                    <td>$800.00</td>
                    <td className="text-danger">$150.00</td>
                    <td className="fw-bold bg-light">$7,150.00</td>
                    <td className="fw-bold bg-light text-success">$7.15</td>
                  </tr>
                  <tr>
                    <td className="fw-bold text-start">#PROD-2026-0040</td>
                    <td className="text-start">Casual Loafers</td>
                    <td>300</td>
                    <td>$2,100.00</td>
                    <td>$150.00</td>
                    <td>$600.00</td>
                    <td>$300.00</td>
                    <td className="text-danger">$45.00</td>
                    <td className="fw-bold bg-light">$3,195.00</td>
                    <td className="fw-bold bg-light text-success">$10.65</td>
                  </tr>
                  <tr>
                    <td className="fw-bold text-start">#PROD-2026-0038</td>
                    <td className="text-start">Running Shoes</td>
                    <td>1500</td>
                    <td>$9,000.00</td>
                    <td>$750.00</td>
                    <td>$2,500.00</td>
                    <td>$1,500.00</td>
                    <td className="text-danger">$400.00</td>
                    <td className="fw-bold bg-light">$14,150.00</td>
                    <td className="fw-bold bg-light text-success">$9.43</td>
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
