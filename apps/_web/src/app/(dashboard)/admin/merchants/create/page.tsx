'use client';

import { VendorService } from '@/services/mock/merchant.service';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState } from 'react';

export default function AdminCreateVendor() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    storeName: '',
    password: '',
    confirmPassword: '',
  });

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    if (formData.password !== formData.confirmPassword) {
      alert("Passwords do not match");
      return;
    }

    VendorService.createVendor({
      firstName: formData.firstName,
      lastName: formData.lastName,
      email: formData.email,
      storeName: formData.storeName,
    });

    router.push('/admin/merchants');
  };

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Create Merchant
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
                <li className="breadcrumb-item">Merchants</li>
                <li className="breadcrumb-item active">Create Merchant</li>
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
                <h5> Add Merchant</h5>
              </div>
              <div className="card-body">
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
                    <label className="col-xl-3 col-md-4"><span>*</span> Store Name</label>
                    <div className="col-xl-8 col-md-7">
                      <input className="form-control" type="text" name="storeName" value={formData.storeName} onChange={handleInputChange} required />
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

                  <div className="pull-right">
                    <button type="submit" className="btn btn-primary">Save</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
