'use client';

export default function ProductsTab() {
  return (
    <div className="tab-pane fade show active" id="products">
      <div className="dashboard-table">
        <div className="wallet-table">
          <div className="top-sec">
            <h3>all products</h3>
            <a className="btn btn-sm btn-solid" href="#!">+ add new</a>
          </div>
          <div className="table-responsive">
            <table className="table cart-table order-table">
              <thead>
                <tr>
                  <th>image</th>
                  <th>product name</th>
                  <th>category</th>
                  <th>price</th>
                  <th>stock</th>
                  <th>sales</th>
                  <th>edit/delete</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td className="image-box">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img alt="" className="blur-up lazyloaded" src="/assets/images/fashion-1/product/5.jpg" />
                  </td>
                  <td>neck velvet dress</td>
                  <td>women clothes</td>
                  <td className="fw-bold text-theme">$205</td>
                  <td>1000</td>
                  <td>2000</td>
                  <td>
                    <a href="#!"><i className="fa fa-pencil-square-o me-1"></i></a>
                    <a href="#!"><i className="fa fa-trash-o ms-1 text-theme"></i></a>
                  </td>
                </tr>
                <tr>
                  <td className="image-box">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img alt="" className="blur-up lazyloaded" src="/assets/images/fashion-1/product/9.jpg" />
                  </td>
                  <td>belted trench coat</td>
                  <td>women clothes</td>
                  <td className="fw-bold text-theme">$350</td>
                  <td>800</td>
                  <td>350</td>
                  <td>
                    <a href="#!"><i className="fa fa-pencil-square-o me-1"></i></a>
                    <a href="#!"><i className="fa fa-trash-o ms-1 text-theme"></i></a>
                  </td>
                </tr>
                <tr>
                  <td className="image-box">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img alt="" className="blur-up lazyloaded" src="/assets/images/fashion-1/product/1.jpg" />
                  </td>
                  <td>men print tee</td>
                  <td>men clothes</td>
                  <td className="fw-bold text-theme">$150</td>
                  <td>750</td>
                  <td>150</td>
                  <td>
                    <a href="#!"><i className="fa fa-pencil-square-o me-1"></i></a>
                    <a href="#!"><i className="fa fa-trash-o ms-1 text-theme"></i></a>
                  </td>
                </tr>
                <tr>
                  <td className="image-box">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img alt="" className="blur-up lazyloaded" src="/assets/images/fashion-1/product/15.jpg" />
                  </td>
                  <td>woman print tee</td>
                  <td>women clothes</td>
                  <td className="fw-bold text-theme">$150</td>
                  <td>750</td>
                  <td>150</td>
                  <td>
                    <a href="#!"><i className="fa fa-pencil-square-o me-1"></i></a>
                    <a href="#!"><i className="fa fa-trash-o ms-1 text-theme"></i></a>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
