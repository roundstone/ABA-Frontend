'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { Box, Archive, AlertTriangle, Truck } from 'lucide-react';
import MetricCard from '@/components/admin/dashboard/MetricCard';

// API-ready interfaces
interface InventoryMetrics {
  totalRawMaterialValue: number;
  totalFinishedGoodsValue: number;
  lowStockItemsCount: number;
  pendingAllocations: number;
}

interface LowStockAlert {
  id: string;
  itemName: string;
  category: 'Raw Material' | 'Finished Good';
  currentStock: number;
  reorderPoint: number;
}

interface RecentMovement {
  id: string;
  date: string;
  item: string;
  type: 'IN' | 'OUT' | 'ADJUSTMENT';
  qtyChange: number;
  source: string;
}

export default function InventoryDashboard() {
  const [metrics, setMetrics] = useState<InventoryMetrics | null>(null);
  const [alerts, setAlerts] = useState<LowStockAlert[]>([]);
  const [movements, setMovements] = useState<RecentMovement[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  // Simulate API fetch
  useEffect(() => {
    const fetchDashboardData = async () => {
      setIsLoading(true);
      // Simulate network delay
      await new Promise(resolve => setTimeout(resolve, 800));

      setMetrics({
        totalRawMaterialValue: 45200.50,
        totalFinishedGoodsValue: 128500.00,
        lowStockItemsCount: 3,
        pendingAllocations: 5,
      });

      setAlerts([
        { id: '1', itemName: 'Orthopedic Foam', category: 'Raw Material', currentStock: 10, reorderPoint: 50 },
        { id: '2', itemName: 'Packaging Boxes', category: 'Raw Material', currentStock: 150, reorderPoint: 200 },
        { id: '3', itemName: 'Running Shoes (Size 10)', category: 'Finished Good', currentStock: 5, reorderPoint: 20 },
      ]);

      setMovements([
        { id: 'm1', date: '2026-09-23 10:30', item: 'Premium Leather', type: 'OUT', qtyChange: -100, source: 'Prod-2026-0042' },
        { id: 'm2', date: '2026-09-23 09:15', item: 'Canvas High Tops', type: 'IN', qtyChange: 300, source: 'Prod-2026-0040' },
        { id: 'm3', date: '2026-09-22 16:45', item: 'Orthopedic Soles', type: 'ADJUSTMENT', qtyChange: -5, source: 'Adj-2026-001' },
      ]);

      setIsLoading(false);
    };

    fetchDashboardData();
  }, []);

  if (isLoading || !metrics) {
    return <div className="p-5 text-center">Loading Inventory Dashboard...</div>;
  }

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Store / Inventory Dashboard
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
                <li className="breadcrumb-item active">Dashboard</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <MetricCard
            title="Raw Materials Value"
            value={metrics.totalRawMaterialValue.toLocaleString()}
            Icon={Box}
            colorClass="primary"
            prefix="$"
            subtitle=""
          />
          <MetricCard
            title="Finished Goods Value"
            value={metrics.totalFinishedGoodsValue.toLocaleString()}
            Icon={Archive}
            colorClass="secondary"
            prefix="$"
            subtitle=""
          />
          <MetricCard
            title="Low Stock Alerts"
            value={metrics.lowStockItemsCount}
            Icon={AlertTriangle}
            colorClass="danger"
            subtitle=""
          />
          <MetricCard
            title="Pending Allocations"
            value={metrics.pendingAllocations}
            Icon={Truck}
            colorClass="warning"
            subtitle=""
          />
        </div>

        <div className="row">
          <div className="col-xl-6 xl-100">
            <div className="card">
              <div className="card-header">
                <h5>Low Stock Alerts</h5>
              </div>
              <div className="card-body">
                <div className="table-responsive">
                  <table className="table table-borderless">
                    <thead>
                      <tr>
                        <th>Item</th>
                        <th>Type</th>
                        <th>Current Stock</th>
                        <th>Reorder Point</th>
                        <th>Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      {alerts.map((alert) => (
                        <tr key={alert.id}>
                          <td>{alert.itemName}</td>
                          <td><span className={`badge ${alert.category === 'Raw Material' ? 'badge-primary' : 'badge-secondary'}`}>{alert.category}</span></td>
                          <td><span className="text-danger fw-bold">{alert.currentStock}</span></td>
                          <td>{alert.reorderPoint}</td>
                          <td>
                            {alert.category === 'Raw Material' ? (
                              <Link href="/admin/procurement/orders/create" className="btn btn-sm btn-outline-primary">Order</Link>
                            ) : (
                              <Link href="/admin/production/orders/create" className="btn btn-sm btn-outline-secondary">Produce</Link>
                            )}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <div className="col-xl-6 xl-100">
            <div className="card">
              <div className="card-header d-flex justify-content-between align-items-center">
                <h5>Recent Movements</h5>
                <Link href="/admin/inventory/movements" className="btn btn-sm btn-light">View Ledger</Link>
              </div>
              <div className="card-body">
                <div className="table-responsive">
                  <table className="table table-borderless">
                    <thead>
                      <tr>
                        <th>Date</th>
                        <th>Item</th>
                        <th>Change</th>
                        <th>Source</th>
                      </tr>
                    </thead>
                    <tbody>
                      {movements.map((mov) => (
                        <tr key={mov.id}>
                          <td>{mov.date}</td>
                          <td>{mov.item}</td>
                          <td>
                            {mov.type === 'IN' && <span className="text-success fw-bold">+{mov.qtyChange}</span>}
                            {mov.type === 'OUT' && <span className="text-warning fw-bold">{mov.qtyChange}</span>}
                            {mov.type === 'ADJUSTMENT' && <span className="text-danger fw-bold">{mov.qtyChange}</span>}
                          </td>
                          <td><span className="badge badge-light text-dark">{mov.source}</span></td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
