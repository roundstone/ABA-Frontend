'use client';
import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import Breadcrumb from '@/components/ui/Breadcrumb';
import Header from '@/components/layout/Header';
import Footer from '@/components/layout/Footer';

export default function MerchantLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  
  const isActive = (path: string) => {
    return pathname?.includes(path) ? 'active' : '';
  };

  return (
    <>
      <Header />
      <Breadcrumb
        title="Merchant Dashboard"
        items={[{ label: 'Home', url: '/' }, { label: 'Merchant Dashboard' }]}
      />

      <section className="dashboard-section section-b-space user-dashboard-section">
        <div className="container">
          <div className="row">
            <div className="col-lg-3">
              <div className="dashboard-sidebar">
                <div className="profile-top">
                  <div className="profile-image merchant-image">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img alt="" className="img-fluid" src="/assets/images/logos/17.png" />
                  </div>
                  <div className="profile-detail">
                    <h5>Fashion Store</h5>
                    <h6>750 followers | 10 review</h6>
                    <h6>mark.enderess@mail.com</h6>
                  </div>
                </div>
                <div className="faq-tab">
                  <ul className="nav nav-tabs" id="top-tab" role="tablist">
                    <li className="nav-item">
                      <Link href="/merchant/dashboard" className={`nav-link ${isActive('/merchant/dashboard')}`}>
                        <i className="ri-home-line"></i> Dashboard
                      </Link>
                    </li>
                    <li className="nav-item">
                      <Link href="/merchant/products" className={`nav-link ${isActive('/merchant/products')}`}>
                        <i className="ri-product-hunt-line"></i> Products
                      </Link>
                    </li>
                    <li className="nav-item">
                      <Link href="/merchant/orders" className={`nav-link ${isActive('/merchant/orders')}`}>
                        <i className="ri-file-text-line"></i> Orders
                      </Link>
                    </li>
                    <li className="nav-item">
                      <Link href="/merchant/pos" className={`nav-link ${isActive('/merchant/pos')}`}>
                        <i className="ri-store-2-line"></i> POS
                      </Link>
                    </li>
                    <li className="nav-item">
                      <Link href="/merchant/customers" className={`nav-link ${isActive('/merchant/customers')}`}>
                        <i className="ri-user-3-line"></i> Customers
                      </Link>
                    </li>
                    <li className="nav-item">
                      <Link href="/merchant/network" className={`nav-link ${isActive('/merchant/network')}`}>
                        <i className="ri-share-line"></i> Network
                      </Link>
                    </li>
                    <li className="nav-item">
                      <Link href="/merchant/earnings" className={`nav-link ${isActive('/merchant/earnings')}`}>
                        <i className="ri-wallet-line"></i> Earnings
                      </Link>
                    </li>
                    <li className="nav-item">
                      <Link href="/merchant/profile" className={`nav-link ${isActive('/merchant/profile')}`}>
                        <i className="ri-user-3-line"></i> Profile
                      </Link>
                    </li>
                    <li className="nav-item">
                      <Link href="/merchant/settings" className={`nav-link ${isActive('/merchant/settings')}`}>
                        <i className="ri-settings-line"></i> Settings
                      </Link>
                    </li>
                    <li className="nav-item logout-cls">
                      <Link href="/" className="btn loagout-btn">
                        <i className="ri-logout-box-r-line"></i> Logout
                      </Link>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            
            <div className="col-lg-9">
              <div className="faq-content tab-content" id="top-tabContent">
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
