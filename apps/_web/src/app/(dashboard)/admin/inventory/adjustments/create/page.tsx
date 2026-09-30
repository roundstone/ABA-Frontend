'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState } from 'react';

export default function CreateStockAdjustment() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    itemType: 'RAW_MATERIAL',
    itemId: '',
    adjustmentType: 'DECREASE',
    quantity: '',
    reason: '',
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log('API Call: Submitting Adjustment Request:', formData);
    alert('Adjustment Request Submitted for Approval!');
    router.push('/admin/inventory/adjustments');
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Request Stock Adjustment
                  <small>ABA ERP Admin panel</small>
                </h3>
              </div>
            </div>
            <div className="col-lg-6">
              <ol className="breadcrumb pull-right">
                <li className="breadcrumb-item">
                  <Link href="/admin"><i data-feather="home"></i></Link>
                </li>
                <li className="breadcrumb-item">Inventory</li>
                <li className="breadcrumb-item">
                  <Link href="/admin/inventory/adjustments">Adjustments</Link>
                </li>
                <li className="breadcrumb-item active">Request</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-sm-12">
            <div className="card">
              <div className="card-header">
                <h5>Stock Adjustment Form</h5>
                <p className="text-muted small mb-0 mt-2">
                  All manual adjustments must go through an approval workflow. Please provide a detailed reason.
                </p>
              </div>
              <div className="card-body">
                <form className="needs-validation" onSubmit={handleSubmit}>
                  <div className="form-group row">
                    <label className="col-xl-3 col-md-4">Item Category</label>
                    <div className="col-xl-8 col-md-7">
                      <select 
                        className="form-control" 
                        name="itemType" 
                        value={formData.itemType} 
                        onChange={handleChange}
                      >
                        <option value="RAW_MATERIAL">Raw Material</option>
                        <option value="FINISHED_GOOD">Finished Good</option>
                      </select>
                    </div>
                  </div>

                  <div className="form-group row">
                    <label className="col-xl-3 col-md-4">Select Item</label>
                    <div className="col-xl-8 col-md-7">
                      <select 
                        className="form-control" 
                        name="itemId" 
                        value={formData.itemId} 
                        onChange={handleChange}
                        required
                      >
                        <option value="">Select an item...</option>
                        {formData.itemType === 'RAW_MATERIAL' ? (
                          <>
                            <option value="RM-001">Premium Leather (Current: 1200 sq.m)</option>
                            <option value="RM-002">Rubber Soles (Current: 800 pairs)</option>
                            <option value="RM-003">Packaging Boxes (Current: 150 pcs)</option>
                          </>
                        ) : (
                          <>
                            <option value="FG-001">Premium Leather Sneakers (Current: 450)</option>
                            <option value="FG-002">Casual Loafers (Current: 300)</option>
                          </>
                        )}
                      </select>
                    </div>
                  </div>

                  <div className="form-group row">
                    <label className="col-xl-3 col-md-4">Adjustment Type</label>
                    <div className="col-xl-8 col-md-7">
                      <select 
                        className="form-control" 
                        name="adjustmentType" 
                        value={formData.adjustmentType} 
                        onChange={handleChange}
                      >
                        <option value="INCREASE">Increase Stock (Found items, audit correction)</option>
                        <option value="DECREASE">Decrease Stock (Damage, shrinkage, display sample)</option>
                      </select>
                    </div>
                  </div>

                  <div className="form-group row">
                    <label className="col-xl-3 col-md-4">Quantity to Adjust</label>
                    <div className="col-xl-8 col-md-7">
                      <input 
                        className="form-control" 
                        type="number" 
                        name="quantity" 
                        min="1"
                        value={formData.quantity} 
                        onChange={handleChange}
                        placeholder="e.g. 5"
                        required 
                      />
                    </div>
                  </div>

                  <div className="form-group row">
                    <label className="col-xl-3 col-md-4">Reason / Justification</label>
                    <div className="col-xl-8 col-md-7">
                      <textarea 
                        className="form-control" 
                        name="reason" 
                        rows={4}
                        value={formData.reason} 
                        onChange={handleChange}
                        placeholder="Detailed explanation for this adjustment request..."
                        required
                      ></textarea>
                    </div>
                  </div>

                  <div className="pull-right">
                    <Link href="/admin/inventory/adjustments" className="btn btn-light me-3">Cancel</Link>
                    <button type="submit" className="btn btn-primary">Submit Request</button>
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
