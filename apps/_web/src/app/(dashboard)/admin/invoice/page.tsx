'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { Invoice, InvoiceService } from '@/services/mock/invoice.service';

export default function AdminInvoice() {
  const [invoices, setInvoices] = useState<Invoice[]>([]);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    setInvoices(InvoiceService.getInvoices());
  }, []);

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this invoice?')) {
      InvoiceService.deleteInvoice(id);
      setInvoices(InvoiceService.getInvoices());
    }
  };

  const filteredInvoices = invoices.filter(invoice =>
    invoice.invoiceId.toLowerCase().includes(searchTerm.toLowerCase()) ||
    invoice.date.includes(searchTerm)
  );

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Invoice
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
                <li className="breadcrumb-item active">Invoice</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-sm-12">
            <div className="card">
              <div className="card-header">
                <form className="form-inline search-form search-box">
                  <div className="form-group">
                    <input
                      className="form-control-plaintext"
                      type="search"
                      placeholder="Search by ID or Date.."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                    />
                  </div>
                </form>
              </div>

              <div className="card-body">
                <div className="table-responsive table-desi">
                  <table className="table all-package table-category current-table" id="editableTable">
                    <thead>
                      <tr>
                        <th>No.</th>
                        <th>Invoice</th>
                        <th>Date</th>
                        <th>Shipping</th>
                        <th>Amount</th>
                        <th>Tax</th>
                        <th>Total</th>
                        <th>Option</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredInvoices.map((invoice, index) => (
                        <tr key={invoice.id}>
                          <td data-field="number">{String(index + 1).padStart(2, '0')}</td>
                          <td data-field="number">{invoice.invoiceId}</td>
                          <td data-field="Date">{invoice.date}</td>
                          <td data-field="number">{invoice.shipping}</td>
                          <td data-field="number">{invoice.amount}</td>
                          <td data-field="number">{invoice.tax}</td>
                          <td data-field="number">{invoice.total}</td>
                          <td>
                            <a href="#!" onClick={(e) => e.preventDefault()}>
                              <i className="fa fa-edit" title="Edit"></i>
                            </a>
                            <a href="#!" onClick={(e) => { e.preventDefault(); handleDelete(invoice.id); }}>
                              <i className="fa fa-trash" title="Delete"></i>
                            </a>
                          </td>
                        </tr>
                      ))}
                      {filteredInvoices.length === 0 && (
                        <tr>
                          <td colSpan={8} className="text-center">No invoices found.</td>
                        </tr>
                      )}
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
