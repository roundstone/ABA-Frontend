'use client';

import { VendorService, Merchant } from '@/services/mock/merchant.service';
import Link from 'next/link';
import { useEffect, useState } from 'react';

export default function AdminVendorList() {
  const [merchants, setVendors] = useState<Merchant[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    setVendors(VendorService.getVendors());
  }, []);

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this merchant?')) {
      VendorService.deleteVendor(id);
      setVendors(VendorService.getVendors());
    }
  };

  if (!mounted) return null;

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Merchant List
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
                <li className="breadcrumb-item">Merchants</li>
                <li className="breadcrumb-item active">Merchant List</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header">
            <form className="form-inline search-form search-box">
              <div className="form-group">
                <input className="form-control-plaintext" type="search" placeholder="Search.." />
                <span className="d-sm-none mobile-search">
                  <i data-feather="search"></i>
                </span>
              </div>
            </form>

            <Link href="/admin/merchants/create" className="btn btn-primary mt-md-0 mt-2">Create Merchant</Link>
          </div>

          <div className="card-body merchant-table">
            <div className="table-responsive">
              <table className="display table" id="basic-1">
                <thead>
                  <tr>
                    <th>Merchant</th>
                    <th>Products</th>
                    <th>Store Name</th>
                    <th>Create Date</th>
                    <th>Wallet Balance</th>
                    <th>Revenue</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  {merchants.map((merchant) => (
                    <tr key={merchant.id}>
                      <td>
                        <div className="d-flex merchant-list align-items-center">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img src={merchant.avatar || '/images/team/2.jpg'} alt="" className="img-fluid img-40 rounded-circle blur-up lazyloaded me-3" style={{ width: '40px', height: '40px', objectFit: 'cover' }} />
                          <span>{merchant.firstName} {merchant.lastName}</span>
                        </div>
                      </td>
                      <td>{merchant.products}</td>
                      <td>{merchant.storeName}</td>
                      <td>{merchant.createDate}</td>
                      <td>${merchant.walletBalance.toLocaleString()}</td>
                      <td>${merchant.revenue.toLocaleString()}</td>
                      <td>
                        <div className="d-flex align-items-center">
                          <Link href="#!">
                            <i className="fa fa-edit me-2 font-success" title="Edit"></i>
                          </Link>
                          <a href="#!" onClick={(e) => { e.preventDefault(); handleDelete(merchant.id); }}>
                            <i className="fa fa-trash font-danger ms-3" title="Delete"></i>
                          </a>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
