'use client';

export default function OrdersTab() {
  return (
    <div className="tab-pane fade show active" id="orders">
      <div className="dashboard-table">
        <div className="wallet-table">
          <div className="top-sec">
            <h3>orders</h3>
            <a className="btn btn-sm btn-solid" href="#!">add product</a>
          </div>
          <div className="table-responsive">
            <table className="table cart-table order-table">
              <thead>
                <tr>
                  <th>order id</th>
                  <th>product details</th>
                  <th>status</th>
                  <th>price</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>#125021</td>
                  <td>neck velvet dress</td>
                  <td><span className="badge bg-credit custom-badge rounded-0">shipped</span></td>
                  <td>$205</td>
                </tr>
                <tr>
                  <td>#521214</td>
                  <td>belted trench coat</td>
                  <td><span className="badge bg-credit custom-badge rounded-0">shipped</span></td>
                  <td>$350</td>
                </tr>
                <tr>
                  <td>#521021</td>
                  <td>men print tee</td>
                  <td><span className="badge bg-pending custom-badge rounded-0">pending</span></td>
                  <td>$150</td>
                </tr>
                <tr>
                  <td>#245021</td>
                  <td>woman print tee</td>
                  <td><span className="badge bg-credit custom-badge rounded-0">shipped</span></td>
                  <td>$150</td>
                </tr>
                <tr>
                  <td>#122141</td>
                  <td>men print tee</td>
                  <td><span className="badge bg-credit custom-badge rounded-0">shipped</span></td>
                  <td>$150</td>
                </tr>
                <tr>
                  <td>#125015</td>
                  <td>men print tee</td>
                  <td><span className="badge bg-pending custom-badge rounded-0">pending</span></td>
                  <td>$150</td>
                </tr>
                <tr>
                  <td>#245021</td>
                  <td>woman print tee</td>
                  <td><span className="badge bg-credit custom-badge rounded-0">shipped</span></td>
                  <td>$150</td>
                </tr>
                <tr>
                  <td>#122141</td>
                  <td>men print tee</td>
                  <td><span className="badge bg-debit custom-badge rounded-0">cancelled</span></td>
                  <td>$150</td>
                </tr>
                <tr>
                  <td>#125015</td>
                  <td>men print tee</td>
                  <td><span className="badge bg-pending custom-badge rounded-0">pending</span></td>
                  <td>$150</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
