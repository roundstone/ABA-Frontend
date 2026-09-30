'use client';

import React, { useEffect, useState } from 'react';

interface ReturnItem {
  id: string;
  details: string;
  quantity: number;
  status: 'Pending' | 'Cancel' | 'Return';
  price: number;
}

export default function GoodsReturn() {
  const [returns, setReturns] = useState<ReturnItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Simulate API fetch
    const fetchReturns = async () => {
      setIsLoading(true);
      await new Promise(resolve => setTimeout(resolve, 500));
      setReturns([
        { id: '1', details: 'Simply dummy text of the printing', quantity: 1, status: 'Pending', price: 6523 },
        { id: '2', details: 'Long established', quantity: 5, status: 'Cancel', price: 6523 },
        { id: '3', details: 'sometimes by accident', quantity: 10, status: 'Cancel', price: 6523 },
        { id: '4', details: 'Classical Latin literature', quantity: 9, status: 'Return', price: 6523 },
        { id: '5', details: 'keep the site on the Internet', quantity: 8, status: 'Pending', price: 6523 },
        { id: '6', details: 'Molestiae consequatur', quantity: 3, status: 'Cancel', price: 6523 },
        { id: '7', details: 'Pain can procure', quantity: 8, status: 'Return', price: 6523 },
      ]);
      setIsLoading(false);
    };
    fetchReturns();
  }, []);

  return (
    <div className="col-xl-6 xl-100">
      <div className="card height-equal">
        <div className="card-header">
          <h5>Goods Return</h5>
          <div className="card-header-right">
            <ul className="list-unstyled card-option">
              <li><i className="icofont icofont-simple-left"></i></li>
              <li><i className="view-html fa fa-code"></i></li>
              <li><i className="icofont icofont-maximize full-card"></i></li>
              <li><i className="icofont icofont-minus minimize-card"></i></li>
              <li><i className="icofont icofont-refresh reload-card"></i></li>
              <li><i className="icofont icofont-error close-card"></i></li>
            </ul>
          </div>
        </div>
        <div className="card-body">
          {isLoading ? (
            <div className="d-flex justify-content-center align-items-center" style={{ minHeight: '300px' }}>
              <span className="text-muted">Loading returns data...</span>
            </div>
          ) : (
            <div className="user-status table-responsive products-table">
              <table className="table table-bordernone mb-0">
                <thead>
                  <tr>
                    <th scope="col">Details</th>
                    <th scope="col">Quantity</th>
                    <th scope="col">Status</th>
                    <th scope="col">Price</th>
                  </tr>
                </thead>
                <tbody>
                  {returns.map(item => (
                    <tr key={item.id}>
                      <td>{item.details}</td>
                      <td className="digits">{item.quantity}</td>
                      <td className={item.status === 'Cancel' ? 'font-secondary' : 'font-primary'}>{item.status}</td>
                      <td className="digits">${item.price.toLocaleString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
