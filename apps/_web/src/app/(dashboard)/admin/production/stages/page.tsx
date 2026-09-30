'use client';

import Link from 'next/link';
import { useState } from 'react';

type Stage = {
  id: string;
  title: string;
  borderColor: string;
};

type Order = {
  id: string;
  orderNumber: string;
  product: string;
  qty: number;
  stageId: string;
  progress?: number;
};

const STAGES: Stage[] = [
  { id: 'MATERIAL_ALLOCATED', title: 'Material Allocated', borderColor: 'border-warning' },
  { id: 'IN_PROGRESS', title: 'In Progress', borderColor: 'border-primary' },
  { id: 'QUALITY_CHECK', title: 'Quality Check', borderColor: 'border-info' },
  { id: 'PACKAGING', title: 'Packaging', borderColor: 'border-success' },
];

const INITIAL_ORDERS: Order[] = [
  { id: '1', orderNumber: '#PROD-2026-0043', product: 'Orthopedic Soles', qty: 250, stageId: 'MATERIAL_ALLOCATED' },
  { id: '2', orderNumber: '#PROD-2026-0042', product: 'Premium Leather Sneakers', qty: 500, stageId: 'IN_PROGRESS', progress: 40 },
  { id: '3', orderNumber: '#PROD-2026-0040', product: 'Casual Loafers', qty: 300, stageId: 'PACKAGING' },
];

export default function ProductionStages() {
  const [orders, setOrders] = useState<Order[]>(INITIAL_ORDERS);

  const handleDragStart = (e: React.DragEvent<HTMLDivElement>, orderId: string) => {
    e.dataTransfer.setData('orderId', orderId);
  };

  const handleDragOver = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault(); // Necessary to allow dropping
  };

  const handleDrop = (e: React.DragEvent<HTMLDivElement>, stageId: string) => {
    const orderId = e.dataTransfer.getData('orderId');
    if (orderId) {
      setOrders((prev) =>
        prev.map((order) =>
          order.id === orderId ? { ...order, stageId } : order
        )
      );
      console.log(`API Call: Moved order ${orderId} to stage ${stageId}`);
    }
  };

  const handleActionClick = (orderId: string, currentStage: string) => {
    // Determine next stage
    const currentIndex = STAGES.findIndex(s => s.id === currentStage);
    if (currentIndex < STAGES.length - 1) {
      const nextStageId = STAGES[currentIndex + 1].id;
      setOrders(prev => prev.map(order => 
        order.id === orderId ? { ...order, stageId: nextStageId } : order
      ));
      console.log(`API Call: Action button moved order ${orderId} to ${nextStageId}`);
    } else {
      console.log(`API Call: Order ${orderId} is completed`);
      alert(`Order ${orderId} completed!`);
    }
  };

  const getActionButtonText = (stageId: string) => {
    switch (stageId) {
      case 'MATERIAL_ALLOCATED': return 'Start Production';
      case 'IN_PROGRESS': return 'Send to QC';
      case 'QUALITY_CHECK': return 'Approve QC';
      case 'PACKAGING': return 'Complete Order';
      default: return 'Next';
    }
  };

  const getActionButtonClass = (stageId: string) => {
    switch (stageId) {
      case 'MATERIAL_ALLOCATED': return 'btn-outline-primary';
      case 'IN_PROGRESS': return 'btn-outline-primary';
      case 'QUALITY_CHECK': return 'btn-outline-info';
      case 'PACKAGING': return 'btn-outline-success';
      default: return 'btn-outline-secondary';
    }
  };

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Work-in-Progress (WIP) Stages
                  <small>ABA ERP Admin panel</small>
                </h3>
              </div>
            </div>
            <div className="col-lg-6">
              <ol className="breadcrumb pull-right">
                <li className="breadcrumb-item">
                  <Link href="/admin">
                    <i data-feather="home"></i>
                  </Link>
                </li>
                <li className="breadcrumb-item">Production</li>
                <li className="breadcrumb-item active">WIP Stages</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          {STAGES.map((stage) => {
            const stageOrders = orders.filter((o) => o.stageId === stage.id);

            return (
              <div key={stage.id} className="col-lg-3 col-md-6 mb-4">
                <div
                  className={`card shadow-sm border-top ${stage.borderColor} border-3 h-100`}
                  onDragOver={handleDragOver}
                  onDrop={(e) => handleDrop(e, stage.id)}
                >
                  <div className="card-header pb-2 d-flex justify-content-between align-items-center">
                    <h6 className="mb-0">{stage.title}</h6>
                    <span className="badge badge-light text-dark">{stageOrders.length}</span>
                  </div>
                  <div className="card-body p-2 bg-light" style={{ minHeight: '300px' }}>
                    {stageOrders.length === 0 ? (
                      <div className="text-center p-3 text-muted">
                        <small>No orders in {stage.title}</small>
                      </div>
                    ) : (
                      stageOrders.map((order) => (
                        <div
                          key={order.id}
                          className="card mb-2 border-0 shadow-sm"
                          draggable
                          onDragStart={(e) => handleDragStart(e, order.id)}
                          style={{ cursor: 'grab' }}
                        >
                          <div className="card-body p-3">
                            <div className="d-flex justify-content-between mb-1">
                              <span className="fw-bold text-dark">{order.orderNumber}</span>
                              <span className="badge badge-light text-dark">Qty: {order.qty}</span>
                            </div>
                            <p className="mb-2 text-muted small">{order.product}</p>
                            
                            {order.progress !== undefined && (
                              <div className="progress mb-2" style={{ height: '5px' }}>
                                <div
                                  className="progress-bar bg-primary"
                                  role="progressbar"
                                  style={{ width: `${order.progress}%` }}
                                ></div>
                              </div>
                            )}
                            
                            <button 
                              className={`btn btn-sm w-100 ${getActionButtonClass(stage.id)}`}
                              onClick={() => handleActionClick(order.id, stage.id)}
                            >
                              {getActionButtonText(stage.id)}
                            </button>
                          </div>
                        </div>
                      ))
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </>
  );
}
