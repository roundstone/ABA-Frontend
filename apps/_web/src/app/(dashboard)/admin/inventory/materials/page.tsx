'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';

interface RawMaterial {
  id: string;
  name: string;
  category: string;
  qtyOnHand: number;
  unit: string;
  reorderPoint: number;
  valuePerUnit: number;
}

export default function InventoryMaterials() {
  const [materials, setMaterials] = useState<RawMaterial[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchMaterials = async () => {
      setIsLoading(true);
      await new Promise(resolve => setTimeout(resolve, 600));

      setMaterials([
        { id: 'RM-001', name: 'Premium Leather', category: 'Leather', qtyOnHand: 1200, unit: 'sq. m', reorderPoint: 500, valuePerUnit: 15.00 },
        { id: 'RM-002', name: 'Rubber Soles', category: 'Soles', qtyOnHand: 800, unit: 'pairs', reorderPoint: 300, valuePerUnit: 4.50 },
        { id: 'RM-003', name: 'Fabric Mesh', category: 'Textiles', qtyOnHand: 350, unit: 'm', reorderPoint: 200, valuePerUnit: 2.20 },
        { id: 'RM-004', name: 'Orthopedic Foam', category: 'Padding', qtyOnHand: 10, unit: 'kg', reorderPoint: 50, valuePerUnit: 8.00 },
        { id: 'RM-005', name: 'Packaging Boxes', category: 'Packaging', qtyOnHand: 150, unit: 'pcs', reorderPoint: 200, valuePerUnit: 0.50 },
      ]);
      setIsLoading(false);
    };

    fetchMaterials();
  }, []);

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Raw Materials
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
                <li className="breadcrumb-item active">Raw Materials</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h5>Raw Materials Stock</h5>
            <Link href="/admin/procurement/orders/create" className="btn btn-primary">Create Purchase Order</Link>
          </div>
          <div className="card-body">
            {isLoading ? (
              <div className="text-center p-5">Loading materials...</div>
            ) : (
              <div className="table-responsive">
                <table className="table">
                  <thead>
                    <tr>
                      <th>Material ID</th>
                      <th>Name</th>
                      <th>Category</th>
                      <th>Qty on Hand</th>
                      <th>Reorder Point</th>
                      <th>Unit Value</th>
                      <th>Total Value</th>
                      <th>Status</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {materials.map((mat) => {
                      const isLowStock = mat.qtyOnHand <= mat.reorderPoint;
                      const totalValue = mat.qtyOnHand * mat.valuePerUnit;
                      
                      return (
                        <tr key={mat.id}>
                          <td>{mat.id}</td>
                          <td className="fw-bold">{mat.name}</td>
                          <td>{mat.category}</td>
                          <td>
                            <span className={isLowStock ? 'text-danger fw-bold' : ''}>
                              {mat.qtyOnHand} {mat.unit}
                            </span>
                          </td>
                          <td>{mat.reorderPoint} {mat.unit}</td>
                          <td>${mat.valuePerUnit.toFixed(2)}</td>
                          <td>${totalValue.toLocaleString(undefined, { minimumFractionDigits: 2 })}</td>
                          <td>
                            {isLowStock ? (
                              <span className="badge badge-danger">Low Stock</span>
                            ) : (
                              <span className="badge badge-success">In Stock</span>
                            )}
                          </td>
                          <td>
                            <Link href="/admin/inventory/movements" className="btn btn-sm btn-light">View Ledger</Link>
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
