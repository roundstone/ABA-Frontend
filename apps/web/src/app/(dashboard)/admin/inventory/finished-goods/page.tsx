'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';

interface FinishedGood {
  id: string;
  sku: string;
  name: string;
  category: string;
  qtyOnHand: number;
  allocatedQty: number;
  availableQty: number;
  unitValue: number;
}

export default function InventoryFinishedGoods() {
  const [goods, setGoods] = useState<FinishedGood[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchGoods = async () => {
      setIsLoading(true);
      await new Promise(resolve => setTimeout(resolve, 600));

      const rawGoods = [
        { id: 'FG-001', sku: 'SNKR-PRM-01', name: 'Premium Leather Sneakers', category: 'Footwear', qtyOnHand: 450, allocatedQty: 100, unitValue: 120.00 },
        { id: 'FG-002', sku: 'LOAF-CSL-02', name: 'Casual Loafers', category: 'Footwear', qtyOnHand: 300, allocatedQty: 250, unitValue: 95.00 },
        { id: 'FG-003', sku: 'RUN-SH-03', name: 'Running Shoes', category: 'Footwear', qtyOnHand: 5, allocatedQty: 0, unitValue: 85.00 },
        { id: 'FG-004', sku: 'CANV-HT-04', name: 'Canvas High Tops', category: 'Footwear', qtyOnHand: 800, allocatedQty: 50, unitValue: 65.00 },
      ];

      // Calculate available dynamically
      const processedGoods = rawGoods.map(g => ({
        ...g,
        availableQty: g.qtyOnHand - g.allocatedQty
      }));

      setGoods(processedGoods);
      setIsLoading(false);
    };

    fetchGoods();
  }, []);

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Finished Goods
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
                <li className="breadcrumb-item active">Finished Goods</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h5>Finished Goods Inventory</h5>
            <Link href="/admin/inventory/allocations" className="btn btn-primary">Manage Allocations</Link>
          </div>
          <div className="card-body">
            {isLoading ? (
              <div className="text-center p-5">Loading finished goods...</div>
            ) : (
              <div className="table-responsive">
                <table className="table">
                  <thead>
                    <tr>
                      <th>Product ID</th>
                      <th>SKU</th>
                      <th>Name</th>
                      <th>Category</th>
                      <th>Qty on Hand</th>
                      <th>Allocated Qty</th>
                      <th>Available Qty</th>
                      <th>Total Value</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {goods.map((item) => {
                      const totalValue = item.qtyOnHand * item.unitValue;
                      const isLowAvailable = item.availableQty < 20;

                      return (
                        <tr key={item.id}>
                          <td>{item.id}</td>
                          <td><code>{item.sku}</code></td>
                          <td className="fw-bold">{item.name}</td>
                          <td>{item.category}</td>
                          <td>{item.qtyOnHand}</td>
                          <td>
                            <span className="badge badge-warning">{item.allocatedQty}</span>
                          </td>
                          <td>
                            <span className={`fw-bold ${isLowAvailable ? 'text-danger' : 'text-success'}`}>
                              {item.availableQty}
                            </span>
                          </td>
                          <td>${totalValue.toLocaleString(undefined, { minimumFractionDigits: 2 })}</td>
                          <td>
                            <div className="d-flex gap-2">
                              <Link href="/admin/inventory/movements" className="btn btn-sm btn-light">Ledger</Link>
                            </div>
                          </td>
                        </tr>
                      );
                    })}
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
