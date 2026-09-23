'use client';

import React, { useEffect, useState } from 'react';
import Breadcrumb from '@/components/ui/Breadcrumb';
import UserSidebar from '@/components/layout/UserSidebar';
import { CommissionService, CommissionPolicy } from '@/services/mock/commission.service';

export default function AdminCommissionPolicyPage() {
  const [policy, setPolicy] = useState<CommissionPolicy | null>(null);

  useEffect(() => {
    setPolicy(CommissionService.getPolicy());
  }, []);

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    if (policy) {
      CommissionService.updatePolicy(policy);
      alert('Commission policy updated successfully!');
    }
  };

  const updatePercentage = (index: number, value: string) => {
    if (!policy) return;
    const newPercentages = [...policy.percentages];
    newPercentages[index] = Number(value);
    setPolicy({ ...policy, percentages: newPercentages });
  };

  if (!policy) return <div className="p-5 text-center">Loading...</div>;

  return (
    <>
      <Breadcrumb
        title="Admin - Commission Policy"
        items={[{ label: 'Home', url: '/' }, { label: 'Commission Policy' }]}
      />
      <section className="section-b-space">
        <div className="container">
          <div className="row">
            <div className="col-lg-3">
              <UserSidebar />
            </div>
            <div className="col-sm-9">
              <div className="dashboard-right">
                <div className="dashboard">
                  <div className="page-title">
                    <h2>Global Commission Policy</h2>
                  </div>
                  
                  <div className="welcome-msg">
                    <p>Configure the parameters for the referral commission engine.</p>
                  </div>

                  <div className="box-account mt-4">
                    <div className="card shadow-sm border-0">
                      <div className="card-body p-4">
                        <form onSubmit={handleSave} className="theme-form">
                          <div className="row mb-4">
                            <div className="col-md-6">
                              <label className="form-label font-bold">Commission Model</label>
                              <select 
                                className="form-control"
                                value={policy.type}
                                onChange={(e) => setPolicy({ ...policy, type: e.target.value as any })}
                              >
                                <option value="MULTI_LEVEL">Multi-Level (Upline Tree)</option>
                                <option value="FLAT_DIRECT">Flat Direct Only</option>
                                <option value="TIERED_BY_VOLUME">Tiered by Sales Volume</option>
                              </select>
                            </div>
                            <div className="col-md-6">
                              <label className="form-label font-bold">Engine Status</label>
                              <div className="form-check form-switch mt-2">
                                <input 
                                  className="form-check-input" 
                                  type="checkbox" 
                                  id="engineStatus" 
                                  checked={policy.isActive}
                                  onChange={(e) => setPolicy({ ...policy, isActive: e.target.checked })}
                                />
                                <label className="form-check-label ms-2" htmlFor="engineStatus">
                                  {policy.isActive ? 'Active (Processing Commissions)' : 'Paused'}
                                </label>
                              </div>
                            </div>
                          </div>

                          <h5 className="mb-3 text-primary border-bottom pb-2">Multi-Level Configurations</h5>
                          
                          <div className="row mb-4">
                            <div className="col-md-4">
                              <label className="form-label font-bold">Max Rewardable Levels</label>
                              <input 
                                type="number" 
                                className="form-control" 
                                value={policy.levels}
                                min={1}
                                max={10}
                                onChange={(e) => {
                                  const levels = Number(e.target.value);
                                  const percentages = [...policy.percentages];
                                  // Adjust array size
                                  while (percentages.length < levels) percentages.push(0);
                                  if (percentages.length > levels) percentages.length = levels;
                                  setPolicy({ ...policy, levels, percentages });
                                }}
                              />
                            </div>
                          </div>

                          <div className="row mb-4">
                            <div className="col-12">
                              <label className="form-label font-bold">Level Percentages (%)</label>
                              <div className="d-flex flex-column gap-3 max-w-md">
                                {Array.from({ length: policy.levels }).map((_, idx) => (
                                  <div key={idx} className="d-flex align-items-center">
                                    <span className="me-3" style={{ width: '80px' }}>Level {idx + 1}</span>
                                    <input 
                                      type="number" 
                                      className="form-control flex-grow-1"
                                      step="0.1"
                                      min="0"
                                      max="100"
                                      value={policy.percentages[idx] || 0}
                                      onChange={(e) => updatePercentage(idx, e.target.value)}
                                    />
                                    <span className="ms-2">%</span>
                                  </div>
                                ))}
                              </div>
                            </div>
                          </div>

                          <button type="submit" className="btn btn-solid">Save Configuration</button>
                        </form>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
