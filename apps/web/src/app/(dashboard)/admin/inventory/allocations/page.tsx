'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';

interface Allocation {
  id: string;
  date: string;
  merchantName: string;
  itemName: string;
  quantity: number;
  status: 'PENDING' | 'DISPATCHED' | 'RECEIVED';
}

export default function InventoryAllocations() {
  const [allocations, setAllocations] = useState<Allocation[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchAllocations = async () => {
      setIsLoading(true);
      await new Promise(resolve => setTimeout(resolve, 600));

      setAllocations([
        { id: 'ALLOC-009', date: '2026-09-23 14:20', merchantName: 'Aba Central Hub', itemName: 'Premium Leather Sneakers', quantity: 50, status: 'PENDING' },
        { id: 'ALLOC-008', date: '2026-09-22 11:10', merchantName: 'Lagos Branch', itemName: 'Casual Loafers', quantity: 150, status: 'DISPATCHED' },
        { id: 'ALLOC-007', date: '2026-09-20 09:00', merchantName: 'Abuja Franchise', itemName: 'Running Shoes', quantity: 100, status: 'RECEIVED' },
      ]);
      setIsLoading(false);
    };

    fetchAllocations();
  }, []);

  const handleDispatch = (id: string) => {
    setAllocations(prev => prev.map(alloc => 
      alloc.id === id ? { ...alloc, status: 'DISPATCHED' } : alloc
    ));
    console.log(`API Call: Dispatched allocation ${id}`);
  };

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Merchant Allocations
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
                <li className="breadcrumb-item active">Allocations</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header">
            <h5>Finished Goods Allocations</h5>
            <p className="text-muted small mb-0 mt-2">
              Track finished goods allocated and transferred to merchants or branches.
            </p>
          </div>
          <div className="card-body">
            {isLoading ? (
              <div className="text-center p-5">Loading allocations...</div>
            ) : (
              <div className="table-responsive">
                <table className="table table-hover">
                  <thead>
                    <tr>
                      <th>Allocation ID</th>
                      <th>Date</th>
                      <th>Merchant / Location</th>
                      <th>Product</th>
                      <th>Quantity</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {allocations.map((alloc) => (
                      <tr key={alloc.id}>
                        <td><code>{alloc.id}</code></td>
                        <td>{alloc.date}</td>
                        <td className="fw-bold">{alloc.merchantName}</td>
                        <td>{alloc.itemName}</td>
                        <td>{alloc.quantity}</td>
                        <td>
                          {alloc.status === 'PENDING' && <span className="badge badge-warning text-dark">Pending Dispatch</span>}
                          {alloc.status === 'DISPATCHED' && <span className="badge badge-info">In Transit</span>}
                          {alloc.status === 'RECEIVED' && <span className="badge badge-success">Received</span>}
                        </td>
                        <td>
                          {alloc.status === 'PENDING' ? (
                            <button 
                              className="btn btn-sm btn-outline-primary"
                              onClick={() => handleDispatch(alloc.id)}
                            >
                              Dispatch Goods
                            </button>
                          ) : (
                            <span className="text-muted small">No action needed</span>
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
