'use client';

import { UserService } from '@/services/mock/user.service';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState } from 'react';

export default function AdminCreateUser() {
  const router = useRouter();
  const [activeTab, setActiveTab] = useState('account');
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    confirmPassword: '',
    role: 'Customer' as 'Customer' | 'Admin',
  });

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    if (formData.password !== formData.confirmPassword) {
      alert("Passwords do not match");
      return;
    }

    UserService.createUser({
      firstName: formData.firstName,
      lastName: formData.lastName,
      email: formData.email,
      role: formData.role
    });

    router.push('/admin/users');
  };

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Create User
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
                <li className="breadcrumb-item">Users</li>
                <li className="breadcrumb-item active">Create User</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-sm-12">
            <div className="card tab2-card">
              <div className="card-header">
                <h5> Add User</h5>
              </div>
              <div className="card-body">
                <ul className="nav nav-tabs tab-coupon" id="myTab" role="tablist">
                  <li className="nav-item">
                    <button
                      className={`nav-link ${activeTab === 'account' ? 'active show' : ''}`}
                      onClick={() => setActiveTab('account')}
                    >
                      Account
                    </button>
                  </li>
                  <li className="nav-item">
                    <button
                      className={`nav-link ${activeTab === 'permission' ? 'active show' : ''}`}
                      onClick={() => setActiveTab('permission')}
                    >
                      Permission
                    </button>
                  </li>
                </ul>

                <div className="tab-content" id="myTabContent">
                  <div className={`tab-pane fade ${activeTab === 'account' ? 'active show' : ''}`}>
                    <form className="needs-validation user-add" onSubmit={handleSave}>
                      <h4>Account Details</h4>
                      <div className="form-group row">
                        <label className="col-xl-3 col-md-4"><span>*</span> First Name</label>
                        <div className="col-xl-8 col-md-7">
                          <input className="form-control" type="text" name="firstName" value={formData.firstName} onChange={handleInputChange} required />
                        </div>
                      </div>
                      <div className="form-group row">
                        <label className="col-xl-3 col-md-4"><span>*</span> Last Name</label>
                        <div className="col-xl-8 col-md-7">
                          <input className="form-control" type="text" name="lastName" value={formData.lastName} onChange={handleInputChange} required />
                        </div>
                      </div>
                      <div className="form-group row">
                        <label className="col-xl-3 col-md-4"><span>*</span> Email</label>
                        <div className="col-xl-8 col-md-7">
                          <input className="form-control" type="email" name="email" value={formData.email} onChange={handleInputChange} required />
                        </div>
                      </div>
                      <div className="form-group row">
                        <label className="col-xl-3 col-md-4"><span>*</span> Password</label>
                        <div className="col-xl-8 col-md-7">
                          <input className="form-control" type="password" name="password" value={formData.password} onChange={handleInputChange} required />
                        </div>
                      </div>
                      <div className="form-group row">
                        <label className="col-xl-3 col-md-4"><span>*</span> Confirm Password</label>
                        <div className="col-xl-8 col-md-7">
                          <input className="form-control" type="password" name="confirmPassword" value={formData.confirmPassword} onChange={handleInputChange} required />
                        </div>
                      </div>
                      <div className="form-group row">
                        <label className="col-xl-3 col-md-4"><span>*</span> Role</label>
                        <div className="col-xl-8 col-md-7">
                          <select className="form-control" name="role" value={formData.role} onChange={handleInputChange}>
                            <option value="Customer">Customer</option>
                            <option value="Admin">Admin</option>
                          </select>
                        </div>
                      </div>

                      <div className="pull-right">
                        <button type="submit" className="btn btn-primary">Save</button>
                      </div>
                    </form>
                  </div>

                  <div className={`tab-pane fade ${activeTab === 'permission' ? 'active show' : ''}`}>
                    <form className="needs-validation user-add">
                      <div className="permission-block">
                        <div className="attribute-blocks">
                          <h5 className="f-w-600 mb-3">Product Related permissions</h5>
                          <div className="row">
                            <div className="col-xl-3 col-sm-4">
                              <label>Add Product</label>
                            </div>
                            <div className="col-xl-9 col-sm-8">
                              <div className="form-group m-checkbox-inline mb-0 custom-radio-ml d-flex radio-animated">
                                <label className="d-block" htmlFor="edo-ani1">
                                  <input className="radio_animated" id="edo-ani1" type="radio" name="rdo-ani" />
                                  Allow
                                </label>
                                <label className="d-block" htmlFor="edo-ani2">
                                  <input className="radio_animated" id="edo-ani2" type="radio" name="rdo-ani" defaultChecked />
                                  Deny
                                </label>
                              </div>
                            </div>
                          </div>
                          <div className="row">
                            <div className="col-xl-3 col-sm-4">
                              <label>Update Product</label>
                            </div>
                            <div className="col-xl-9 col-sm-8">
                              <div className="form-group m-checkbox-inline mb-0 custom-radio-ml d-flex radio-animated">
                                <label className="d-block" htmlFor="edo-ani3">
                                  <input className="radio_animated" id="edo-ani3" type="radio" name="rdo-ani1" />
                                  Allow
                                </label>
                                <label className="d-block" htmlFor="edo-ani4">
                                  <input className="radio_animated" id="edo-ani4" type="radio" name="rdo-ani1" defaultChecked />
                                  Deny
                                </label>
                              </div>
                            </div>
                          </div>
                          <div className="row">
                            <div className="col-xl-3 col-sm-4">
                              <label>Delete Product</label>
                            </div>
                            <div className="col-xl-9 col-sm-8">
                              <div className="form-group m-checkbox-inline mb-0 custom-radio-ml d-flex radio-animated">
                                <label className="d-block" htmlFor="edo-ani5">
                                  <input className="radio_animated" id="edo-ani5" type="radio" name="rdo-ani2" />
                                  Allow
                                </label>
                                <label className="d-block" htmlFor="edo-ani6">
                                  <input className="radio_animated" id="edo-ani6" type="radio" name="rdo-ani2" defaultChecked />
                                  Deny
                                </label>
                              </div>
                            </div>
                          </div>
                        </div>

                        <div className="attribute-blocks">
                          <h5 className="f-w-600 mb-3 mt-4">Category Related permissions</h5>
                          <div className="row">
                            <div className="col-xl-3 col-sm-4">
                              <label>Add Category</label>
                            </div>
                            <div className="col-xl-9 col-sm-8">
                              <div className="form-group m-checkbox-inline mb-0 custom-radio-ml d-flex radio-animated">
                                <label className="d-block" htmlFor="edo-ani7">
                                  <input className="radio_animated" id="edo-ani7" type="radio" name="rdo-ani3" />
                                  Allow
                                </label>
                                <label className="d-block" htmlFor="edo-ani8">
                                  <input className="radio_animated" id="edo-ani8" type="radio" name="rdo-ani3" defaultChecked />
                                  Deny
                                </label>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>

                      <div className="pull-right">
                        <button type="button" className="btn btn-primary" onClick={() => setActiveTab('account')}>Back</button>
                      </div>
                    </form>
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
