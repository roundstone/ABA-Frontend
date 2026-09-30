'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';

interface Movement {
  id: string;
  date: string;
  item: string;
  category: 'Raw Material' | 'Finished Good';
  type: 'IN' | 'OUT' | 'ADJUSTMENT' | 'ALLOCATION';
  qtyChange: number;
  balance: number;
  sourceTransaction: string;
  user: string;
}

export default function StockMovements() {
  const [movements, setMovements] = useState<Movement[]>([]);
  const [filterType, setFilterType] = useState<string>('ALL');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchMovements = async () => {
      setIsLoading(true);
      await new Promise(resolve => setTimeout(resolve, 700));

      setMovements([
        { id: 'MOV-1004', date: '2026-09-23 14:20', item: 'Premium Leather Sneakers', category: 'Finished Good', type: 'ALLOCATION', qtyChange: -50, balance: 450, sourceTransaction: 'ALLOC-009', user: 'Admin User' },
        { id: 'MOV-1003', date: '2026-09-23 10:30', item: 'Premium Leather', category: 'Raw Material', type: 'OUT', qtyChange: -100, balance: 1200, sourceTransaction: 'PROD-2026-0042', user: 'System' },
        { id: 'MOV-1002', date: '2026-09-23 09:15', item: 'Canvas High Tops', category: 'Finished Good', type: 'IN', qtyChange: 300, balance: 800, sourceTransaction: 'PROD-2026-0040', user: 'System' },
        { id: 'MOV-1001', date: '2026-09-22 16:45', item: 'Orthopedic Soles', category: 'Raw Material', type: 'ADJUSTMENT', qtyChange: -5, balance: 245, sourceTransaction: 'ADJ-2026-001', user: 'Manager John' },
        { id: 'MOV-1000', date: '2026-09-21 11:00', item: 'Rubber Soles', category: 'Raw Material', type: 'IN', qtyChange: 500, balance: 800, sourceTransaction: 'PO-2026-088', user: 'System' },
      ]);
      setIsLoading(false);
    };

    fetchMovements();
  }, []);

  const filteredMovements = filterType === 'ALL' 
    ? movements 
    : movements.filter(m => m.type === filterType);

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Stock Movements Ledger
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
                <li className="breadcrumb-item active">Movements</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h5>Ledger History</h5>
            <div className="d-flex gap-2 align-items-center">
              <label className="mb-0 fw-bold">Filter:</label>
              <select 
                className="form-select form-select-sm w-auto"
                value={filterType}
                onChange={(e) => setFilterType(e.target.value)}
              >
                <option value="ALL">All Movements</option>
                <option value="IN">Stock IN (Purchases/Production)</option>
                <option value="OUT">Stock OUT (Production)</option>
                <option value="ALLOCATION">Allocations (Merchants)</option>
                <option value="ADJUSTMENT">Adjustments</option>
              </select>
            </div>
          </div>
          <div className="card-body">
            {isLoading ? (
              <div className="text-center p-5">Loading ledger...</div>
            ) : (
              <div className="table-responsive">
                <table className="table table-striped table-hover">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Date</th>
                      <th>Item</th>
                      <th>Type</th>
                      <th>Qty Change</th>
                      <th>Balance</th>
                      <th>Source Trans.</th>
                      <th>User</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredMovements.length === 0 ? (
                      <tr>
                        <td colSpan={8} className="text-center">No movements found.</td>
                      </tr>
                    ) : (
                      filteredMovements.map((mov) => {
                        let qtyClass = '';
                        let qtyPrefix = '';
                        if (mov.type === 'IN') { qtyClass = 'text-success fw-bold'; qtyPrefix = '+'; }
                        else if (mov.type === 'OUT' || mov.type === 'ALLOCATION') { qtyClass = 'text-warning fw-bold'; }
                        else if (mov.type === 'ADJUSTMENT') { qtyClass = mov.qtyChange > 0 ? 'text-success fw-bold' : 'text-danger fw-bold'; qtyPrefix = mov.qtyChange > 0 ? '+' : ''; }

                        return (
                          <tr key={mov.id}>
                            <td><span className="text-muted">{mov.id}</span></td>
                            <td>{mov.date}</td>
                            <td>
                              <div>{mov.item}</div>
                              <small className="text-muted">{mov.category}</small>
                            </td>
                            <td>
                              <span className={`badge ${mov.type === 'IN' ? 'badge-success' : mov.type === 'OUT' ? 'badge-warning' : mov.type === 'ALLOCATION' ? 'badge-info' : 'badge-danger'}`}>
                                {mov.type}
                              </span>
                            </td>
                            <td className={qtyClass}>{qtyPrefix}{mov.qtyChange}</td>
                            <td>{mov.balance}</td>
                            <td><code>{mov.sourceTransaction}</code></td>
                            <td>{mov.user}</td>
                          </tr>
                        );
                      })
                    )}
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
