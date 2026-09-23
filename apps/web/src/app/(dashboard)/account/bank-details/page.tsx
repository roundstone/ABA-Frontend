import React from 'react';

export default function BankDetailsPage() {
  return (
    <>
                  <div className="row">
                    <div className="col-12">
                      <div className="card mb-0 mt-0">
                        <div className="card-body">
                          <div className="top-sec">
                            <h3>Bank Details</h3>
                          </div>
                          <form className="themeform-auth">
                            <div className="row mb-3 align-items-center">
                              <label className="form-label col-xxl-2 col-lg-12 col-md-3" htmlFor="bank_account_no">Bank Account
                                Number</label>
                              <div className="col-xxl-10 col-lg-12 col-md-9">
                                <input className="form-control" id="bank_account_no" placeholder="Enter Bank Account Number" type="text" />
                              </div>
                            </div>
                            <div className="row mb-3 align-items-center">
                              <label className="form-label col-xxl-2 col-lg-12 col-md-3" htmlFor="bank_name">Bank
                                Name</label>
                              <div className="col-xxl-10 col-lg-12 col-md-9"><input className="form-control" id="bank_name" placeholder="Enter Bank Name" type="text" />
                              </div>
                            </div>
                            <div className="row mb-3 align-items-center">
                              <label className="form-label col-xxl-2 col-lg-12 col-md-3" htmlFor="bank_holder_name">Holder
                                Name</label>
                              <div className="col-xxl-10 col-lg-12 col-md-9"><input className="form-control" id="bank_holder_name" placeholder="Enter Bank Holder Name" type="text" />
                              </div>
                            </div>
                            <div className="row mb-3 align-items-center">
                              <label className="form-label col-xxl-2 col-lg-12 col-md-3" htmlFor="swift">Swift</label>
                              <div className="col-xxl-10 col-lg-12 col-md-9">
                                <input className="form-control" id="swift" placeholder="Enter Swift Code" type="text" />
                              </div>
                            </div>
                            <div className="row mb-3 align-items-center">
                              <label className="form-label col-xxl-2 col-lg-12 col-md-3" htmlFor="ifsc">IFSC</label>
                              <div className="col-xxl-10 col-lg-12 col-md-9">
                                <input className="form-control" id="ifsc" placeholder="Enter IFSC Code" type="text" />
                              </div>
                            </div>
                          </form>
                          <div className="mb-3 top-sec top-sec-2">
                            <h3>Payment Details</h3>
                          </div>
                          <form className="themeform-auth">
                            <div className="row mb-3 align-items-center">
                              <label className="form-label col-xxl-2 col-lg-12 col-md-3" htmlFor="paypal_email">Paypal
                                Email</label>
                              <div className="col-xxl-10 col-lg-12 col-md-9">
                                <input className="form-control" id="paypal_email" placeholder="Enter Paypal Email" type="email" />
                              </div>
                            </div>
                            <div className="text-end">
                              <button className="btn btn-solid" id="payout_btn" type="submit"> Save
                              </button>
                            </div>
                          </form>
                        </div>
                      </div>
                    </div>
                  </div>

    </>
  );
}
