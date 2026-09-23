"use client";

import Link from 'next/link';

interface ReceiptItem {
  id: string;
  name?: string;
  productName?: string;
  quantity: number;
  price: number;
  image?: string;
}

interface GenericOrder {
  id?: string;
  orderId?: string;
  createdAt?: string;
  date?: string;
  total: number;
  subtotal: number;
  tax?: number;
  shipping?: number;
  items: ReceiptItem[];
  shippingAddress?: string;
  paymentMethod?: string;
  customerName?: string;
  customerEmail?: string;
  referralCode?: string;
}

interface ReceiptProps {
  orderData?: GenericOrder;
  order?: GenericOrder; // fallback for backwards compatibility
  type?: 'ONLINE' | 'POS';
}

export default function Receipt({ orderData, order, type = 'ONLINE' }: ReceiptProps) {
  // Use orderData or order
  const data = orderData || order;
  
  if (!data) return null;

  const orderId = data.id || data.orderId || 'UNKNOWN';
  const orderDate = data.createdAt || data.date || new Date().toISOString();

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="receipt-container">
      {/* Hide these sections when printing */}
      <style dangerouslySetInnerHTML={{__html: `
        @media print {
          body * {
            visibility: hidden;
          }
          .receipt-container, .receipt-container * {
            visibility: visible;
          }
          .receipt-container {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
          }
          .no-print {
            display: none !important;
          }
        }
      `}} />

      <section className="section-b-space light-layout">
        <div className="container">
          <div className="row">
            <div className="col-md-12">
              <div className="success-text">
                <div className="checkmark no-print">
                  <svg className="checkmark__check" height="36" viewBox="0 0 48 36" width="48" xmlns="http://www.w3.org/2000/svg">
                    <path d="M47.248 3.9L43.906.667a2.428 2.428 0 0 0-3.344 0l-23.63 23.09-9.554-9.338a2.432 2.432 0 0 0-3.345 0L.692 17.654a2.236 2.236 0 0 0 .002 3.233l14.567 14.175c.926.894 2.42.894 3.342.01L47.248 7.128c.922-.89.922-2.34 0-3.23" />
                  </svg>
                  <svg className="checkmark__background" height="115" viewBox="0 0 120 115" width="120" xmlns="http://www.w3.org/2000/svg">
                    <path d="M107.332 72.938c-1.798 5.557 4.564 15.334 1.21 19.96-3.387 4.674-14.646 1.605-19.298 5.003-4.61 3.368-5.163 15.074-10.695 16.878-5.344 1.743-12.628-7.35-18.545-7.35-5.922 0-13.206 9.088-18.543 7.345-5.538-1.804-6.09-13.515-10.696-16.877-4.657-3.398-15.91-.334-19.297-5.002-3.356-4.627 3.006-14.404-1.208-19.962C10.93 67.576 0 63.442 0 57.5c0-5.943 10.93-10.076 12.668-15.438 1.798-5.557-4.564-15.334-1.21-19.96 3.387-4.674 14.646-1.605 19.298-5.003C35.366 13.73 35.92 2.025 41.45.22c5.344-1.743 12.628 7.35 18.545 7.35 5.922 0 13.206-9.088 18.543-7.345 5.538 1.804 6.09 13.515 10.696 16.877 4.657 3.398 15.91.334 19.297 5.002 3.356 4.627-3.006 14.404-1.208 19.962C109.07 47.424 120 51.562 120 57.5c0 5.943-10.93 10.076-12.668 15.438z" />
                  </svg>
                </div>
                <h2>{type === 'POS' ? 'Sale Completed' : 'Thank You'}</h2>
                <p>{type === 'POS' ? 'Offline sale processed successfully.' : 'Payment is successfully processed and your order is on the way.'}</p>
                <p className="font-weight-bold">Transaction ID: {orderId}</p>
                
                <div className="mt-4 no-print">
                  <button className="btn btn-solid me-3" onClick={handlePrint}>
                    <i className="ri-printer-line me-2"></i> Print Receipt
                  </button>
                  {type === 'ONLINE' && (
                    <Link href={`/track-order?id=${orderId}`} className="btn btn-outline">
                      Track Order
                    </Link>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="section-b-space">
        <div className="container">
          <div className="row">
            <div className="col-lg-6">
              <div className="product-order">
                <table className="table product-order-table">
                  <thead>
                    <tr>
                      <th className="no-print"></th>
                      <th>Product Name</th>
                      <th>Quantity</th>
                      <th>Price</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data.items.map(item => (
                      <tr key={item.id}>
                        <td className="no-print">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img alt={item.productName || item.name} className="img-fluid blur-up lazyloaded" src={item.image || '/images/pro3/1.jpg'} />
                        </td>
                        <td>{item.productName || item.name}</td>
                        <td>{item.quantity}</td>
                        <td>₦{(item.price || 0).toLocaleString()}</td>
                      </tr>
                    ))}
                  </tbody>
                  <tfoot>
                    <tr>
                      <td colSpan={2} className="no-print"></td>
                      <td className="fw-bold">Subtotal</td>
                      <td className="fw-bold">₦{(data.subtotal || 0).toLocaleString()}</td>
                    </tr>
                    {type === 'ONLINE' && data.shipping !== undefined && (
                      <tr>
                        <td colSpan={2} className="no-print"></td>
                        <td className="fw-bold">Shipping</td>
                        <td className="fw-bold">₦{(data.shipping || 0).toLocaleString()}</td>
                      </tr>
                    )}
                    {data.tax !== undefined && data.tax > 0 && (
                      <tr>
                        <td colSpan={2} className="no-print"></td>
                        <td className="fw-bold">Tax</td>
                        <td className="fw-bold">₦{(data.tax || 0).toLocaleString()}</td>
                      </tr>
                    )}
                    <tr>
                      <td colSpan={2} className="no-print"></td>
                      <td className="fw-bold fs-5">Total</td>
                      <td className="fw-bold fs-5 text-primary">₦{(data.total || 0).toLocaleString()}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </div>
            <div className="col-lg-6">
              <div className="order-success-sec">
                <div className="row">
                  <div className="col-sm-6">
                    <h4>Summary</h4>
                    <ul className="order-detail">
                      <li>Order ID: {orderId}</li>
                      <li>Order Date: {new Date(orderDate).toLocaleDateString()}</li>
                      <li>Order Total: ₦{(data.total || 0).toLocaleString()}</li>
                    </ul>
                  </div>
                  
                  {type === 'ONLINE' && (
                    <div className="col-sm-6">
                      <h4>Shipping Address</h4>
                      <ul className="order-detail">
                        <li>{data.shippingAddress || 'N/A'}</li>
                      </ul>
                    </div>
                  )}

                  {type === 'POS' && (
                    <div className="col-sm-6">
                      <h4>Customer Details</h4>
                      <ul className="order-detail">
                        <li>Name: {data.customerName || 'Walk-in Customer'}</li>
                        <li>Email: {data.customerEmail || 'N/A'}</li>
                        <li>Referral: {data.referralCode || 'None'}</li>
                      </ul>
                    </div>
                  )}
                  
                  <div className="col-sm-12 payment-mode">
                    <h4>Payment Method</h4>
                    <p>{data.paymentMethod || (type === 'POS' ? 'OFFLINE PAYMENT' : 'ONLINE PAYMENT')}</p>
                  </div>
                  
                  {type === 'ONLINE' && (
                    <div className="col-md-12 no-print">
                      <div className="delivery-sec">
                        <h3>Expected date of delivery: <span>{new Date(Date.now() + 86400000 * 5).toLocaleDateString()}</span></h3>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
