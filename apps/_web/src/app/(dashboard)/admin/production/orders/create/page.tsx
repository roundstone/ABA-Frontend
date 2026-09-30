'use client';

import Link from 'next/link';
import { useState } from 'react';

export default function CreateProductionOrder() {
  const [formData, setFormData] = useState({
    productId: '',
    plannedQuantity: 100,
    plannedStartDate: '',
    plannedCompletionDate: '',
    notes: '',
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log('Submitting Production Order:', formData);
    alert('Production Order created successfully!');
  };

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Create Production Order
                <small>ABA ERP Admin panel</small>
              </h3>
            </div>
          </div>
          <div className="col-lg-6">
            <ol className="breadcrumb pull-right">
              <li className="breadcrumb-item">
                <Link href="/admin"><i data-feather="home"></i></Link>
              </li>
              <li className="breadcrumb-item">Production</li>
              <li className="breadcrumb-item">
                <Link href="/admin/production/orders">Orders</Link>
              </li>
              <li className="breadcrumb-item active">Create</li>
            </ol>
          </div>
        </div>
      </div>

      <div className="row">
        <div className="col-sm-12">
          <div className="card">
            <div className="card-header">
              <h5>New Production Order Details</h5>
            </div>
            <div className="card-body">
              <form className="needs-validation add-product-form" onSubmit={handleSubmit}>
                <div className="form">
                  <div className="form-group mb-3 row">
                    <label htmlFor="productId" className="col-xl-3 col-sm-4 mb-0">Select Product :</label>
                    <div className="col-xl-8 col-sm-7">
                      <select className="form-control" id="productId" name="productId" required value={formData.productId} onChange={handleChange}>
                        <option value="" disabled>Select Product</option>
                        <option value="prd_SNKR_042">Premium Leather Sneakers</option>
                        <option value="prd_CANV_041">Canvas High Tops</option>
                        <option value="prd_SOLE_043">Orthopedic Soles</option>
                      </select>
                    </div>
                  </div>
                  <div className="form-group mb-3 row">
                    <label htmlFor="plannedQuantity" className="col-xl-3 col-sm-4 mb-0">Planned Quantity :</label>
                    <div className="col-xl-8 col-sm-7">
                      <input className="form-control" id="plannedQuantity" name="plannedQuantity" type="number" required value={formData.plannedQuantity} onChange={handleChange} />
                    </div>
                  </div>
                  <div className="form-group mb-3 row">
                    <label htmlFor="plannedStartDate" className="col-xl-3 col-sm-4 mb-0">Planned Start Date :</label>
                    <div className="col-xl-8 col-sm-7">
                      <input className="form-control" id="plannedStartDate" name="plannedStartDate" type="date" required value={formData.plannedStartDate} onChange={handleChange} />
                    </div>
                  </div>
                  <div className="form-group mb-3 row">
                    <label htmlFor="plannedCompletionDate" className="col-xl-3 col-sm-4 mb-0">Expected Completion Date :</label>
                    <div className="col-xl-8 col-sm-7">
                      <input className="form-control" id="plannedCompletionDate" name="plannedCompletionDate" type="date" required value={formData.plannedCompletionDate} onChange={handleChange} />
                    </div>
                  </div>
                  <div className="form-group mb-3 row">
                    <label className="col-xl-3 col-sm-4 mb-0">Notes :</label>
                    <div className="col-xl-8 col-sm-7">
                      <textarea className="form-control" name="notes" rows={4} value={formData.notes} onChange={handleChange}></textarea>
                    </div>
                  </div>
                </div>
                <div className="offset-xl-3 offset-sm-4">
                  <button type="submit" className="btn btn-primary">Create Order</button>
                  <Link href="/admin/production/orders" className="btn btn-light ms-2">Discard</Link>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
