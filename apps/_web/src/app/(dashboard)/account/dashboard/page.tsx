import React from 'react';

export default function DashboardPage() {
  return (
    <>
                  <div className="counter-section">
                    <div className="welcome-msg">
                      <h4>Hello, MARK JECNO !</h4>
                      <p>From your My Account Dashboard you have the ability to view a snapshot of your
                        recent account activity and update your account information. Select a link below
                        to view or edit information.</p>
                    </div>
                    <div className="row">
                      <div className="col-md-4">
                        <div className="counter-box">
                          <img alt="" className="img-fluid" src="/images/dashboard/balance.png" />
                          <div>
                            <h3>$12.46</h3>
                            <h5>Total Order</h5>
                          </div>
                        </div>
                      </div>
                      <div className="col-md-4">
                        <div className="counter-box">
                          <img alt="" className="img-fluid" src="/images/dashboard/points.png" />
                          <div>
                            <h3>2530</h3>
                            <h5>Total Points</h5>
                          </div>
                        </div>
                      </div>
                      <div className="col-md-4">
                        <div className="counter-box">
                          <img alt="" className="img-fluid" src="/images/dashboard/order.png" />
                          <div>
                            <h3>15</h3>
                            <h5>Total Orders</h5>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div className="box-account box-info">
                      <div className="box-head">
                        <h4>Account Information</h4>
                      </div>
                      <div className="row">
                        <div className="col-sm-12">
                          <div className="box">
                            <ul className="box-content">
                              <li className="w-100">
                                <h6>Full Name: John Due</h6>
                              </li>
                              <li className="w-100">
                                <h6>Phone: +1 65558845</h6>
                              </li>
                              <li className="w-100">
                                <h6>Address: 26, Starts Hollow
                                  Colony Denver, Colorado, United States 80014</h6>
                              </li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      <div className="box mt-3">
                        <div className="box-head">
                          <h4>Login Details</h4>
                        </div>
                        <div className="row">
                          <div className="col-sm-6">
                            <h6>Email : john.customer@example.com</h6><a data-bs-toggle="modal" data-bs-target="#edit-profile" href="#!">Edit</a>
                          </div>
                          <div className="col-sm-6">
                            <h6>Password : ●●●●●●</h6><a data-bs-toggle="modal" data-bs-target="#edit-password" href="#!">Edit</a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

    </>
  );
}
