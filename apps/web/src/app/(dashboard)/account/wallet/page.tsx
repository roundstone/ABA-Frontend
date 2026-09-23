import React from 'react';

export default function WalletPage() {
  return (
    <>
                  <div className="row g-3">
                    <div className="col-12">
                      <div className="total-contain wallet-bg">
                        <div className="wallet-point-box">
                          <div className="total-image">
                            <img alt="" className="img-fluid" src="/images/dashboard/balance.png" />
                          </div>
                          <div className="total-detail">
                            <div className="total-box">
                              <h5>Wallet Balance</h5>
                              <h3>$8.46</h3>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div className="col-12">
                      <div className="card mb-0 dashboard-table mt-0">
                        <div className="card-body">
                          <div className="total-box mt-0">
                            <div className="wallet-table">
                              <div className="table-responsive">
                                <table className="table cart-table order-table">
                                  <thead>
                                    <tr className="table-head">
                                      <th>Date</th>
                                      <th>Amount</th>
                                      <th>Remark</th>
                                      <th>Status</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    <tr>
                                      <td>06 Jul 2024
                                        03:15:PM</td>
                                      <td>$39.40</td>
                                      <td>Wallet amount
                                        successfully debited for Order #1017</td>
                                      <td>
                                        <div className="badge bg-debit custom-badge rounded-0">
                                          <span>Debit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>25 Jun 2024
                                        06:34:PM</td>
                                      <td>$375.00</td>
                                      <td>Wallet amount
                                        successfully debited for Order #1015</td>
                                      <td>
                                        <div className="badge bg-debit custom-badge rounded-0">
                                          <span>Debit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>24 Jun 2024
                                        02:29:PM</td>
                                      <td>$34.44</td>
                                      <td>Wallet amount
                                        successfully debited for Order #1013</td>
                                      <td>
                                        <div className="badge bg-debit custom-badge rounded-0">
                                          <span>Debit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>21 Jun 2024
                                        04:29:PM</td>
                                      <td>$75.21</td>
                                      <td>Wallet amount
                                        successfully debited for Order #1010</td>
                                      <td>
                                        <div className="badge bg-debit custom-badge rounded-0">
                                          <span>Debit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>21 Jun 2024
                                        03:57:PM</td>
                                      <td>$30.52</td>
                                      <td>Wallet amount
                                        successfully debited for Order #1009</td>
                                      <td>
                                        <div className="badge bg-debit custom-badge rounded-0">
                                          <span>Debit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>21 Jun 2024
                                        03:48:PM</td>
                                      <td>$109.97</td>
                                      <td>Wallet amount
                                        successfully debited for Order #1006</td>
                                      <td>
                                        <div className="badge bg-debit custom-badge rounded-0">
                                          <span>Debit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>21 Jun 2024
                                        03:42:PM</td>
                                      <td>$323.00</td>
                                      <td>Admin has credited
                                        the balance.</td>
                                      <td>
                                        <div className="badge bg-credit custom-badge rounded-0">
                                          <span>Credit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>21 Jun 2024
                                        03:41:PM</td>
                                      <td>$250.00</td>
                                      <td>Admin has debited
                                        the balance.</td>
                                      <td>
                                        <div className="badge bg-debit custom-badge rounded-0">
                                          <span>Debit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>21 Jun 2024
                                        03:41:PM</td>
                                      <td>$500.00</td>
                                      <td>Admin has credited
                                        the balance.</td>
                                      <td>
                                        <div className="badge bg-credit custom-badge rounded-0">
                                          <span>Credit</span>
                                        </div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>21 Jun 2024
                                        03:41:PM</td>
                                      <td>$100.00</td>
                                      <td>Admin has credited
                                        the balance.</td>
                                      <td>
                                        <div className="badge bg-credit custom-badge rounded-0">
                                          <span>Credit</span>
                                        </div>
                                      </td>
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
