'use client';

import Link from 'next/link';
import { useState } from 'react';

export default function CreateProcurementOrder() {
  const [formData, setFormData] = useState({
    supplierId: '',
    materialId: '',
    quantity: 100,
    unitPrice: 0,
    expectedDeliveryDate: '',
    notes: '',
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log('Submitting Procurement Order:', formData);
    alert('Purchase Order created successfully!');
  };

  const totalPrice = formData.quantity * formData.unitPrice;

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Create Purchase Order
                <small>ABA ERP Admin panel</small>
              </h3>
            </div>
          </div>
          <div className="col-lg-6">
            <ol className="breadcrumb pull-right">
              <li className="breadcrumb-item">
                <Link href="/admin"><i data-feather="home"></i></Link>
              </li>
              <li className="breadcrumb-item">Procurement</li>
              <li className="breadcrumb-item">
                <Link href="/admin/procurement/orders">Orders</Link>
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
              <h5>New Purchase Order Details</h5>
            </div>
            <div className="card-body">
              <form className="needs-validation add-product-form" onSubmit={handleSubmit}>
                <div className="form">
                  <div className="form-group mb-3 row">
                    <label htmlFor="supplierId" className="col-xl-3 col-sm-4 mb-0">Select Supplier :</label>
                    <div className="col-xl-8 col-sm-7">
                      <select className="form-control" id="supplierId" name="supplierId" required value={formData.supplierId} onChange={handleChange}>
                        <option value="" disabled>Select Supplier</option>
                        <option value="sup_001">Global Leathers Co.</option>
                        <option value="sup_002">Rubber & Sole Ltd.</option>
                        <option value="sup_003">Textile Masters</option>
                      </select>
                    </div>
                  </div>
                  
                  <div className="form-group mb-3 row">
                    <label htmlFor="materialId" className="col-xl-3 col-sm-4 mb-0">Select Material :</label>
                    <div className="col-xl-8 col-sm-7">
                      <select className="form-control" id="materialId" name="materialId" required value={formData.materialId} onChange={handleChange}>
                        <option value="" disabled>Select Material</option>
                        <option value="mat_001">Premium Leather (sq. m)</option>
                        <option value="mat_002">Rubber Soles (pairs)</option>
                        <option value="mat_003">Fabric Mesh (m)</option>
                        <option value="mat_004">Orthopedic Foam (kg)</option>
                      </select>
                    </div>
                  </div>

                  <div className="form-group mb-3 row">
                    <label htmlFor="quantity" className="col-xl-3 col-sm-4 mb-0">Order Quantity :</label>
                    <div className="col-xl-8 col-sm-7">
                      <input className="form-control" id="quantity" name="quantity" type="number" required min="1" value={formData.quantity} onChange={handleChange} />
                    </div>
                  </div>
                  
                  <div className="form-group mb-3 row">
                    <label htmlFor="unitPrice" className="col-xl-3 col-sm-4 mb-0">Unit Price (USD) :</label>
                    <div className="col-xl-8 col-sm-7">
                      <input className="form-control" id="unitPrice" name="unitPrice" type="number" step="0.01" required min="0" value={formData.unitPrice} onChange={handleChange} />
                    </div>
                  </div>
                  
                  <div className="form-group mb-3 row">
                    <label className="col-xl-3 col-sm-4 mb-0">Total Estimated Price :</label>
                    <div className="col-xl-8 col-sm-7">
                      <input className="form-control" type="text" readOnly value={`$${totalPrice.toFixed(2)}`} />
                    </div>
                  </div>

                  <div className="form-group mb-3 row">
                    <label htmlFor="expectedDeliveryDate" className="col-xl-3 col-sm-4 mb-0">Expected Delivery Date :</label>
                    <div className="col-xl-8 col-sm-7">
                      <input className="form-control" id="expectedDeliveryDate" name="expectedDeliveryDate" type="date" required value={formData.expectedDeliveryDate} onChange={handleChange} />
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
                  <button type="submit" className="btn btn-primary">Create Purchase Order</button>
                  <Link href="/admin/procurement/orders" className="btn btn-light ms-2">Discard</Link>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
