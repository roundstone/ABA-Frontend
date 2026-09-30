'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';

interface Adjustment {
  id: string;
  date: string;
  item: string;
  category: string;
  type: 'INCREASE' | 'DECREASE';
  quantity: number;
  reason: string;
  requestedBy: string;
  status: 'PENDING' | 'APPROVED' | 'REJECTED';
}

export default function StockAdjustments() {
  const [adjustments, setAdjustments] = useState<Adjustment[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchAdjustments = async () => {
      setIsLoading(true);
      await new Promise(resolve => setTimeout(resolve, 600));

      setAdjustments([
        { id: 'ADJ-2026-004', date: '2026-09-23 15:00', item: 'Rubber Soles', category: 'Raw Material', type: 'DECREASE', quantity: 15, reason: 'Found defective batch during inspection', requestedBy: 'John (QC)', status: 'PENDING' },
        { id: 'ADJ-2026-003', date: '2026-09-22 09:30', item: 'Premium Leather Sneakers', category: 'Finished Good', type: 'DECREASE', quantity: 2, reason: 'Display samples for front showroom', requestedBy: 'Alice (Sales)', status: 'PENDING' },
        { id: 'ADJ-2026-002', date: '2026-09-20 11:15', item: 'Packaging Boxes', category: 'Raw Material', type: 'INCREASE', quantity: 50, reason: 'Found extra uncounted boxes in warehouse B', requestedBy: 'Mike (Warehouse)', status: 'APPROVED' },
        { id: 'ADJ-2026-001', date: '2026-09-18 16:45', item: 'Orthopedic Soles', category: 'Raw Material', type: 'DECREASE', quantity: 5, reason: 'Water damage from roof leak', requestedBy: 'Mike (Warehouse)', status: 'REJECTED' },
      ]);
      setIsLoading(false);
    };

    fetchAdjustments();
  }, []);

  const handleAction = (id: string, action: 'APPROVED' | 'REJECTED') => {
    setAdjustments(prev => prev.map(adj => 
      adj.id === id ? { ...adj, status: action } : adj
    ));
    console.log(`API Call: Adjustment ${id} marked as ${action}`);
  };

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Stock Adjustments
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
                <li className="breadcrumb-item active">Adjustments</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h5>Adjustment Requests</h5>
            <Link href="/admin/inventory/adjustments/create" className="btn btn-primary">Request Adjustment</Link>
          </div>
          <div className="card-body">
            {isLoading ? (
              <div className="text-center p-5">Loading adjustment requests...</div>
            ) : (
              <div className="table-responsive">
                <table className="table table-hover">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Date</th>
                      <th>Item</th>
                      <th>Change</th>
                      <th>Reason</th>
                      <th>Requested By</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {adjustments.map((adj) => (
                      <tr key={adj.id}>
                        <td><code>{adj.id}</code></td>
                        <td>{adj.date}</td>
                        <td>
                          <div>{adj.item}</div>
                          <small className="text-muted">{adj.category}</small>
                        </td>
                        <td>
                          <span className={adj.type === 'INCREASE' ? 'text-success fw-bold' : 'text-danger fw-bold'}>
                            {adj.type === 'INCREASE' ? '+' : '-'}{adj.quantity}
                          </span>
                        </td>
                        <td style={{ maxWidth: '200px' }} className="text-truncate" title={adj.reason}>{adj.reason}</td>
                        <td>{adj.requestedBy}</td>
                        <td>
                          {adj.status === 'PENDING' && <span className="badge badge-warning text-dark">Pending Approval</span>}
                          {adj.status === 'APPROVED' && <span className="badge badge-success">Approved</span>}
                          {adj.status === 'REJECTED' && <span className="badge badge-danger">Rejected</span>}
                        </td>
                        <td>
                          {adj.status === 'PENDING' ? (
                            <div className="d-flex gap-2">
                              <button 
                                className="btn btn-sm btn-outline-success" 
                                onClick={() => handleAction(adj.id, 'APPROVED')}
                              >
                                Approve
                              </button>
                              <button 
                                className="btn btn-sm btn-outline-danger" 
                                onClick={() => handleAction(adj.id, 'REJECTED')}
                              >
                                Reject
                              </button>
                            </div>
                          ) : (
                            <span className="text-muted small">Processed</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  );
}
