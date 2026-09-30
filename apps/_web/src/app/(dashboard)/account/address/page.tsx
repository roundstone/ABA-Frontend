import React from 'react';

export default function AddressPage() {
  return (
    <>
                  <div className="row">
                    <div className="col-12">
                      <div className="card mb-0 mt-0">
                        <div className="card-body">
                          <div className="top-sec">
                            <h3>Address Book</h3><a className="btn btn-sm btn-solid" data-bs-toggle="modal" data-bs-target="#add-address" href="#!">+ Add New</a>
                          </div>
                          <div className="address-book-section">
                            <div className="row g-4">
                              <div className="select-box active col-xl-4 col-md-6">
                                <div className="address-box">
                                  <div className="top">
                                    <h6>John Due <span>New Home</span>
                                    </h6>
                                  </div>
                                  <div className="middle">
                                    <div className="address">
                                      <p>26, Starts Hollow
                                        Colony, Denver</p>
                                      <p>Colorado, United
                                        States</p>
                                      <p>80014</p>
                                    </div>
                                    <div className="number">
                                      <p>Phone: <span>+1
                                        5551855359</span></p>
                                    </div>
                                  </div>
                                  <div className="bottom"><a className="bottom_btn" data-bs-toggle="modal" data-bs-target="#edit-address" href="#!">Edit</a><a className="bottom_btn" data-bs-toggle="modal" data-bs-target="#delate-address" href="#!">Remove</a></div>
                                </div>
                              </div>
                              <div className="select-box active col-xl-4 col-md-6">
                                <div className="address-box">
                                  <div className="top">
                                    <h6>John Due <span>Old Home</span>
                                    </h6>
                                  </div>
                                  <div className="middle">
                                    <div className="address">
                                      <p>53B, Claire New
                                        Street, San Jose</p>
                                      <p>Colorado, United States</p>
                                      <p>94088</p>
                                    </div>
                                    <div className="number">
                                      <p>Phone: <span>+1
                                        5551855359</span></p>
                                    </div>
                                  </div>
                                  <div className="bottom"><a className="bottom_btn" data-bs-toggle="modal" data-bs-target="#edit-address" href="#!">Edit</a><a className="bottom_btn" data-bs-toggle="modal" data-bs-target="#delate-address" href="#!">Remove</a></div>
                                </div>
                              </div>
                              <div className="select-box active col-xl-4 col-md-6">
                                <div className="address-box">
                                  <div className="top">
                                    <h6>John Due <span>Office</span></h6>
                                  </div>
                                  <div className="middle">
                                    <div className="address">
                                      <p>21B, Row New Street,
                                        San Jose</p>
                                      <p>California, United
                                        States</p>
                                      <p>94088</p>
                                    </div>
                                    <div className="number">
                                      <p>Phone: <span>+1
                                        551865359</span></p>
                                    </div>
                                  </div>
                                  <div className="bottom"><a className="bottom_btn" data-bs-toggle="modal" data-bs-target="#edit-address" href="#!">Edit</a><a className="bottom_btn" data-bs-toggle="modal" data-bs-target="#delate-address" href="#!">Remove</a></div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

      <div className="modal fade theme-modal-2" id="edit-profile" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="fw-semibold">Edit Profile</h3>
              <button className="btn btn-close" data-bs-dismiss="modal" type="submit">
                <i className="ri-close-line"></i>
              </button>
            </div>
            <div className="modal-body">
              <div className="row g-3">
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="name">Full Name</label>
                    <input className="form-control" id="name" placeholder="Enter Name" type="text" defaultValue="john due" />
                  </div>
                </div>
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="name1">Email</label>
                    <input className="form-control" id="name1" placeholder="Enter Email" type="email" defaultValue="john.customer@example.com" />
                  </div>
                </div>
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="name2">Phone Number</label>
                    <input className="form-control" id="name2" placeholder="Enter Phone Number" type="tel" defaultValue="(+1) 65558845" />
                  </div>
                </div>
              </div>
              <div className="mt-3 d-flex align-items-center justify-content-end gap-2">
                <button className="btn btn-md btn-outline fw-bold" data-bs-dismiss="modal" type="button">
                  Cancel
                </button>
                <button className="btn btn-solid" data-bs-dismiss="modal" type="submit">
                  Submit
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      {/**/}
      {/**/}
      <div className="modal fade theme-modal-2" id="edit-password" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="fw-semibold">Edit Password</h3>
              <button className="btn btn-close" data-bs-dismiss="modal" type="submit">
                <i className="ri-close-line"></i>
              </button>
            </div>
            <div className="modal-body">
              <div className="row g-3">
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="current">Current Password</label>
                    <input className="form-control" id="current" placeholder="Enter Current Password" type="password" />
                  </div>
                </div>
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="New">New Password</label>
                    <input className="form-control" id="New" placeholder="Enter New Password" type="password" />
                  </div>
                </div>
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="Confirm">Confirm Password</label>
                    <input className="form-control" id="Confirm" placeholder="Enter Confirm Password" type="password" />
                  </div>
                </div>
              </div>
              <div className="mt-3 d-flex align-items-center justify-content-end gap-2">
                <button className="btn btn-md btn-outline fw-bold" data-bs-dismiss="modal" type="button">
                  Cancel
                </button>
                <button className="btn btn-solid" data-bs-dismiss="modal" id="submit_profile_btn1" type="submit">
                  Submit
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      {/**/}
      {/**/}
      <div className="modal fade theme-modal-2" id="add-address" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="fw-semibold">Edit Profile</h3>
              <button className="btn btn-close" data-bs-dismiss="modal" type="submit">
                <i className="ri-close-line"></i>
              </button>
            </div>
            <div className="modal-body">
              <div className="row g-3">
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="title"> title</label>
                    <input className="form-control" id="title" placeholder="Enter title" type="text" />
                  </div>
                </div>
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="name32">Address</label>
                    <input className="form-control" id="name32" placeholder="Enter Address" type="text" />
                  </div>
                </div>
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="name4">Phone Number</label>
                    <input className="form-control" id="name4" placeholder="Enter Phone Number" type="tel" defaultValue="(+1) 65558845" />
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="form-box">
                    <label className="form-label" htmlFor="name">Country</label>
                    <select className="form-control form-select quantity-variant select-dropdown" id="input-state-02" defaultValue="">
                      <option disabled value="">Select Country </option>
                      <option className="" value="0"> United States </option>
                      <option className="" value="1"> United Kingdom </option>
                      <option className="" value="2"> India </option>
                      <option className="" value="3"> Canada </option>
                    </select>
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="form-box">
                    <label className="form-label">State</label>
                    <select className="form-control form-select quantity-variant select-dropdown" id="input-state-04" defaultValue="">
                      <option disabled value="">Select Country </option>
                      <option className="" value="0"> New York </option>
                      <option className="" value="1"> London </option>
                      <option className="" value="2"> Delhi </option>
                      <option className="" value="3"> Ottawa </option>
                    </select>
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="form-box">
                    <label className="form-label" htmlFor="City">City</label>
                    <input className="form-control" id="City" placeholder="Enter City" type="text" />
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="form-box">
                    <label className="form-label" htmlFor="pincode">Pin Code</label>
                    <input className="form-control" id="pincode" placeholder="Enter Pin Code" type="number" />
                  </div>
                </div>
              </div>
              <div className="mt-3 d-flex align-items-center justify-content-end gap-2">
                <button className="btn btn-md btn-outline fw-bold" data-bs-dismiss="modal" type="button">Cancel</button>
                <button className="btn btn-solid" data-bs-dismiss="modal" type="submit">Submit</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      {/**/}
      {/**/}
      <div className="modal fade theme-modal-2" id="edit-address" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="fw-semibold">Edit Profile</h3>
              <button className="btn btn-close" data-bs-dismiss="modal">
                <i className="ri-close-line"></i>
              </button>
            </div>
            <div className="modal-body">
              <div className="row g-3">
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="title"> title</label>
                    <input className="form-control" id="title2" placeholder="Enter title" type="text" defaultValue="Home" />
                  </div>
                </div>
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="name6">Address</label>
                    <input className="form-control" id="name6" placeholder="Enter Address" type="text" defaultValue="26, Starts Hollow Colony" />
                  </div>
                </div>
                <div className="col-xxl-12">
                  <div className="form-box">
                    <label className="form-label" htmlFor="name5">Phone Number</label>
                    <input className="form-control" id="name5" placeholder="Enter Phone Number" type="tel" defaultValue="(+1) 65558845" />
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="form-box">
                    <label className="form-label">Country</label>
                    <select className="form-control form-select quantity-variant select-dropdown" id="input-state-06" defaultValue="0">
                      <option disabled value="">Select Country </option>
                      <option className="" value="0"> United States </option>
                      <option className="" value="1"> United Kingdom </option>
                      <option className="" value="2"> India </option>
                      <option className="" value="3"> Canada </option>
                    </select>
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="form-box">
                    <label className="form-label">State</label>
                    <select className="form-control form-select quantity-variant select-dropdown" id="input-state-0" defaultValue="0">
                      <option disabled value="">Select Country </option>
                      <option className="" value="0"> New York </option>
                      <option className="" value="1"> London </option>
                      <option className="" value="2"> Delhi </option>
                      <option className="" value="3"> Ottawa </option>
                    </select>
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="form-box">
                    <label className="form-label" htmlFor="city2">City</label>
                    <input className="form-control" id="city2" placeholder="Enter City" type="text" defaultValue="Albany" />
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="form-box">
                    <label className="form-label" htmlFor="pincode2">Pin Code</label>
                    <input className="form-control" id="pincode2" placeholder="Enter Pin Code" type="number" defaultValue="12204" />
                  </div>
                </div>
              </div>
              <div className="mt-3 d-flex align-items-center justify-content-end gap-2">
                <button className="btn btn-md btn-outline fw-bold" data-bs-dismiss="modal">Cancel</button>
                <button className="btn btn-solid" data-bs-dismiss="modal">Submit</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      {/**/}
      {/**/}
      <div className="modal fade theme-modal-2" data-bs-backdrop="static" id="delate-address" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-body p-3">
              <div className="trash-box text-center">
                <i className="ri-delete-bin-line icon-box"></i>
                <h5 className="modal-title">Delete Item?</h5>
                <p>This Item Will Be Deleted Permanently. You Can&apos;t Undo This Action.
                </p>
                <div className="mt-3 d-flex align-items-center justify-content-center gap-2">
                  <button className="btn btn-md btn-outline fw-bold" data-bs-dismiss="modal">No</button>
                  <button className="btn btn-solid" data-bs-dismiss="modal">Yes</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      {/**/}
      {/**/}
      <div className="modal fade theme-modal-2 exit-modal" data-bs-backdrop="static" id="logout" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-body p-3">
              <i className="ri-question-line icon-box"></i>
              <h5 className="modal-title">Confirmation</h5>
              <p>Are You Sure You Want To Processed?</p>
              <div className="mt-3 d-flex align-items-center justify-content-center gap-2">
                <button className="btn btn-md btn-outline fw-bold" data-bs-dismiss="modal">No</button>
                <a className="btn btn-solid" href="index.html">Yes</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
