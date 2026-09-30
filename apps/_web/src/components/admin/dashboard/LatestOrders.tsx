import React from 'react';
import Link from 'next/link';

export default function LatestOrders() {
  return (
    <div className="col-xl-6 xl-100">
      <div className="card">
        <div className="card-header">
          <h5>Latest Orders</h5>
          <div className="card-header-right">
            <ul className="list-unstyled card-option">
              <li><i className="icofont icofont-simple-left"></i></li>
              <li><i className="view-html fa fa-code"></i></li>
              <li><i className="icofont icofont-maximize full-card"></i></li>
              <li><i className="icofont icofont-minus minimize-card"></i></li>
              <li><i className="icofont icofont-refresh reload-card"></i></li>
              <li><i className="icofont icofont-error close-card"></i></li>
            </ul>
          </div>
        </div>
        <div className="card-body">
          <div className="user-status table-responsive latest-order-table">
            <table className="table table-bordernone">
              <thead>
                <tr>
                  <th scope="col">Order ID</th>
                  <th scope="col">Order Total</th>
                  <th scope="col">Payment Method</th>
                  <th scope="col">Status</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>1</td>
                  <td className="digits">$120.00</td>
                  <td className="font-danger">Bank Transfers</td>
                  <td className="digits">On Way</td>
                </tr>
                <tr>
                  <td>2</td>
                  <td className="digits">$90.00</td>
                  <td className="font-secondary">Ewallets</td>
                  <td className="digits">Delivered</td>
                </tr>
                <tr>
                  <td>3</td>
                  <td className="digits">$240.00</td>
                  <td className="font-warning">Cash</td>
                  <td className="digits">Delivered</td>
                </tr>
                <tr>
                  <td>4</td>
                  <td className="digits">$120.00</td>
                  <td className="font-primary">Direct Deposit</td>
                  <td className="digits">$6523</td>
                </tr>
                <tr>
                  <td>5</td>
                  <td className="digits">$50.00</td>
                  <td className="font-primary">Bank Transfers</td>
                  <td className="digits">Delivered</td>
                </tr>
              </tbody>
            </table>
            <Link href="/admin/orders" className="btn btn-primary mt-4">View All Orders</Link>
          </div>
        </div>
      </div>
    </div>
  );
}
