'use client';
import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

import Header from '@/components/layout/Header';
import Footer from '@/components/layout/Footer';

export default function AccountLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  
  const isActive = (path: string) => {
    return pathname?.includes(path) ? 'active' : '';
  };

  return (
    <>
      <Header />
      <div className="breadcrumb-section">
        <div className="container">
          <h2>dashboard</h2>
          <nav className="theme-breadcrumb">
            <ol className="breadcrumb">
              <li className="breadcrumb-item">
                <Link href="/">Home</Link>
              </li>
              <li className="breadcrumb-item active">dashboard</li>
            </ol>
          </nav>
        </div>
      </div>

      {/* dashboard section start */}
      <section className="dashboard-section section-b-space user-dashboard-section">
        <div className="container">
          <div className="row">
            <div className="col-lg-3">
              <div className="dashboard-sidebar">
                <button className="btn back-btn">
                  <i className="ri-close-line"></i><span>Close</span>
                </button>
                <div className="profile-top">
                  <div className="profile-top-box">
                    <div className="profile-image">
                      <div className="position-relative">
                        <div className="user-round">
                          <h4>J</h4>
                        </div>
                        <div className="user-icon"><input accept="image/*" type="file" /><i className="ri-image-edit-line d-lg-block d-none"></i><i className="ri-pencil-fill edit-icon d-lg-none"></i></div>
                      </div>
                    </div>
                  </div>
                  <div className="profile-detail">
                    <h5>John Due</h5>
                    <h6>john.customer@example.com</h6>
                  </div>
                </div>
                <div className="faq-tab">
                  <ul className="nav nav-tabs" id="pills-tab" role="tablist">

                    <li className="nav-item" role="presentation">
                      <Link href="/account/dashboard" className={`nav-link ${isActive('/account/dashboard')}`}>
                        <i className="ri-home-line"></i> Dashboard
                      </Link>
                    </li>
                    <li className="nav-item" role="presentation">
                      <Link href="/account/notifications" className={`nav-link ${isActive('/account/notifications')}`}>
                        <i className="ri-notification-line"></i> Notifications
                      </Link>
                    </li>
                    <li className="nav-item" role="presentation">
                      <Link href="/account/bank-details" className={`nav-link ${isActive('/account/bank-details')}`}>
                        <i className="ri-bank-line"></i> Bank Details
                      </Link>
                    </li>
                    <li className="nav-item" role="presentation">
                      <Link href="/account/wallet" className={`nav-link ${isActive('/account/wallet')}`}>
                        <i className="ri-wallet-line"></i> My Wallet
                      </Link>
                    </li>
                    <li className="nav-item" role="presentation">
                      <Link href="/account/earning" className={`nav-link ${isActive('/account/earning')}`}>
                        <i className="ri-coin-line"></i> Earning Points
                      </Link>
                    </li>
                    <li className="nav-item" role="presentation">
                      <Link href="/account/orders" className={`nav-link ${isActive('/account/orders')}`}>
                        <i className="ri-file-text-line"></i> My Orders
                      </Link>
                    </li>
                    <li className="nav-item" role="presentation">
                      <Link href="/account/refund" className={`nav-link ${isActive('/account/refund')}`}>
                        <i className="ri-money-dollar-circle-line"></i> Refund History
                      </Link>
                    </li>
                    <li className="nav-item" role="presentation">
                      <Link href="/account/address" className={`nav-link ${isActive('/account/address')}`}>
                        <i className="ri-map-pin-line"></i> Saved Address
                      </Link>
                    </li>
                    <li className="nav-item logout-cls" role="presentation">
                      <Link className="btn loagout-btn" data-bs-toggle="modal" href="/">
                        <i className="ri-logout-box-r-line"></i> Logout
                      </Link>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div className="col-lg-9">
              <button className="show-btn btn d-lg-none d-block">Show Menu</button>
              <div className="faq-content tab-content" id="myTabContent">
                {children}
              </div>
            </div>
          </div>
        </div>
      </section>
      <Footer />
    </>
  );
}
