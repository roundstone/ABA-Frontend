import React from 'react';

export default function RefundPage() {
  return (
    <>
                  <div className="row">
                    <div className="col-12">
                      <div className="card mb-0 dashboard-table mt-0">
                        <div className="card-body">
                          <div className="top-sec">
                            <h3>Refund</h3>
                          </div>
                          <div className="total-box mt-0">
                            <div className="wallet-table mt-0">
                              <div className="table-responsive">
                                <table className="table cart-table order-table">
                                  <thead>
                                    <tr className="table-head">
                                      <th>Order</th>
                                      <th>Status</th>
                                      <th className="reason-table">Reason</th>
                                      <th>Created At</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    <tr>
                                      <td><span className="fw-bolder">#1000</span></td>
                                      <td>
                                        <div className="status-rejected">
                                          <span>Rejected</span>
                                        </div>
                                      </td>
                                      <td className="reason-table">Item was damaged . also
                                        fabric was not
                                        good as expected</td>
                                      <td>21 Jun 2024</td>
                                    </tr>
                                  </tbody>
                                </table>
                              </div>
                            </div>
                            <div className="product-pagination">
                              <div className="theme-paggination-block">
                                <nav>
                                  <ul className="pagination">
                                    <li className="page-item">
                                      <a aria-label="Previous" className="page-link" href="#!">
                                        <span>
                                          <i className="ri-arrow-left-s-line"></i>
                                        </span>
                                        <span className="sr-only">Previous</span>
                                      </a>
                                    </li>
                                    <li className="page-item active">
                                      <a className="page-link" href="#!">1</a>
                                    </li>
                                    <li className="page-item">
                                      <a className="page-link" href="#!">2</a>
                                    </li>
                                    <li className="page-item">
                                      <a className="page-link" href="#!">3</a>
                                    </li>
                                    <li className="page-item">
                                      <a aria-label="Next" className="page-link" href="#!">
                                        <span>
                                          <i className="ri-arrow-right-s-line"></i>
                                        </span>
                                        <span className="sr-only">Next</span>
                                      </a>
                                    </li>
                                  </ul>
                                </nav>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

    </>
  );
}
