'use client';

import Link from 'next/link';
import { useState } from 'react';

export default function GenerateSchedule() {
  const [isGenerating, setIsGenerating] = useState(false);
  const [scheduleGenerated, setScheduleGenerated] = useState(false);

  const handleGenerate = (e: React.FormEvent) => {
    e.preventDefault();
    setIsGenerating(true);
    
    // Simulate API delay
    setTimeout(() => {
      setIsGenerating(false);
      setScheduleGenerated(true);
    }, 1500);
  };

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Generate Production Schedule
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
                <Link href="/admin/production/planning">Planning</Link>
              </li>
              <li className="breadcrumb-item active">Generate</li>
            </ol>
          </div>
        </div>
      </div>

      <div className="row">
        <div className="col-sm-12">
          <div className="card">
            <div className="card-header">
              <h5>Schedule Parameters</h5>
            </div>
            <div className="card-body">
              <form className="needs-validation add-product-form" onSubmit={handleGenerate}>
                <div className="form">
                  <div className="form-group mb-3 row">
                    <label htmlFor="timeframe" className="col-xl-3 col-sm-4 mb-0">Forecast Timeframe :</label>
                    <div className="col-xl-8 col-sm-7">
                      <select className="form-control" id="timeframe" required>
                        <option value="15">Next 15 Days</option>
                        <option value="30" defaultValue="30">Next 30 Days</option>
                        <option value="60">Next 60 Days</option>
                        <option value="90">Next 90 Days</option>
                      </select>
                    </div>
                  </div>
                  
                  <div className="form-group mb-3 row">
                    <label htmlFor="strategy" className="col-xl-3 col-sm-4 mb-0">Optimization Strategy :</label>
                    <div className="col-xl-8 col-sm-7">
                      <select className="form-control" id="strategy" required>
                        <option value="demand">Meet Demand (Just-in-Time)</option>
                        <option value="cost">Minimize Production Costs</option>
                        <option value="output">Maximize Factory Output</option>
                      </select>
                    </div>
                  </div>

                  <div className="form-group mb-3 row">
                    <label className="col-xl-3 col-sm-4 mb-0">Include Products :</label>
                    <div className="col-xl-8 col-sm-7">
                      <div className="form-check checkbox-primary mb-2">
                        <input className="form-check-input" id="prod1" type="checkbox" defaultChecked />
                        <label className="form-check-label" htmlFor="prod1">Premium Leather Sneakers (Shortage: 480)</label>
                      </div>
                      <div className="form-check checkbox-primary mb-2">
                        <input className="form-check-input" id="prod2" type="checkbox" defaultChecked />
                        <label className="form-check-label" htmlFor="prod2">Casual Loafers (Shortage: 150)</label>
                      </div>
                      <div className="form-check checkbox-primary mb-2">
                        <input className="form-check-input" id="prod3" type="checkbox" />
                        <label className="form-check-label" htmlFor="prod3">Canvas High Tops (Sufficient Inventory)</label>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div className="offset-xl-3 offset-sm-4">
                  <button type="submit" className="btn btn-primary" disabled={isGenerating}>
                    {isGenerating ? 'Analyzing Data...' : 'Generate Auto-Schedule'}
                  </button>
                  <Link href="/admin/production/planning" className="btn btn-light ms-2">Cancel</Link>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>

      {scheduleGenerated && (
        <div className="row mt-4">
          <div className="col-sm-12">
            <div className="card border-top border-success border-3">
              <div className="card-header d-flex justify-content-between align-items-center">
                <h5>AI Suggested Schedule</h5>
                <button className="btn btn-success btn-sm">Confirm & Create Orders</button>
              </div>
              <div className="card-body">
                <div className="table-responsive">
                  <table className="table table-bordered">
                    <thead className="bg-light">
                      <tr>
                        <th>Product</th>
                        <th>Recommended Qty</th>
                        <th>Suggested Start Date</th>
                        <th>Estimated Completion</th>
                        <th>Resource Bottlenecks</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>Premium Leather Sneakers</td>
                        <td>500 units</td>
                        <td>2026-09-25</td>
                        <td>2026-10-05</td>
                        <td><span className="badge badge-warning">Leather Material Low</span></td>
                      </tr>
                      <tr>
                        <td>Casual Loafers</td>
                        <td>200 units</td>
                        <td>2026-10-06</td>
                        <td>2026-10-12</td>
                        <td><span className="badge badge-success">None</span></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <p className="text-muted mt-3 small">
                  * Confirming this schedule will automatically generate Production Orders and allocate available materials.
                </p>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
