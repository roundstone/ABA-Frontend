'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';
import MobileMenu from './MobileMenu';
import { MENU_ITEMS } from '@/data/menu';

import { useAuthStore } from '@/store/useAuthStore';
import { useWishlistStore } from '@/store/useWishlistStore';
import { useCartStore } from '@/store/useCartStore';

export default function Header() {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const { user, isAuthenticated, logout } = useAuthStore();
  const wishlistItems = useWishlistStore((state) => state.items);
  const cartCount = useCartStore((state) => state.getItemCount());
  
  // Hydration fix
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  return (
    <header>
      <div className="mobile-fix-option"></div>
      <div className="top-header top-header-dark2">
        <div className="container">
          <div className="row">
            <div className="col-lg-6">
              <div className="header-contact">
                <ul>
                  <li>Welcome to Our store ABA</li>
                  <li>
                    <i className="ri-phone-fill"></i>Call Us: 123 - 456 - 7890
                  </li>
                </ul>
              </div>
            </div>
            <div className="col-lg-6 text-end">
              <ul className="header-dropdown">
                <li className="mobile-wishlist">
                  <Link href="/wishlist">
                    <i className="ri-heart-fill"></i> wishlist
                    {mounted && wishlistItems.length > 0 && <span className="cart_qty_cls">{wishlistItems.length}</span>}
                  </Link>
                </li>
                <li className="onhover-dropdown mobile-account">
                  <i className="ri-user-fill"></i> {mounted && isAuthenticated ? `Hi, ${user?.firstName}` : 'My Account'}
                  <ul className="onhover-show-div">
                    {mounted && isAuthenticated ? (
                      <>
                        <li>
                          <Link href="/account/dashboard">Dashboard</Link>
                        </li>
                        <li>
                          <a href="#!" onClick={(e) => { e.preventDefault(); logout(); }}>Logout</a>
                        </li>
                      </>
                    ) : (
                      <>
                        <li>
                          <Link href="/login">Login</Link>
                        </li>
                        <li>
                          <Link href="/register">Register</Link>
                        </li>
                      </>
                    )}
                  </ul>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <div className="container">
        <div className="row">
          <div className="col-sm-12">
            <div className="main-menu">
              <div className="menu-left">
                <div className="navbar">
                  <button className="bg-transparent border-0" onClick={() => setIsMobileMenuOpen(true)}>
                    <i className="ri-bar-chart-horizontal-line sidebar-bar"></i>
                  </button>
                  <MobileMenu isOpen={isMobileMenuOpen} onClose={() => setIsMobileMenuOpen(false)} />
                </div>
                <div className="brand-logo">
                  <Link href="/">
                    <img alt="ABA" className="img-fluid" src="/images/logo.png" style={{ height: '50px', objectFit: 'contain' }} />
                  </Link>
                </div>
              </div>
              <div className="menu-left">
                <nav id="main-nav">
                  <div className="toggle-nav">
                    <i className="ri-bar-chart-horizontal-line sidebar-bar"></i>
                  </div>
                  <ul className="sm pixelstrap sm-horizontal" id="main-menu">
                    <li className="mobile-box">
                      <div className="mobile-back text-end">
                        Menu<i className="ri-close-line"></i>
                      </div>
                    </li>
                    {MENU_ITEMS.map((item, index) => (
                      <li key={index} className={`${item.megaMenu || item.children ? 'mega' : ''}`}>
                        {item.type === 'link' ? (
                          <Link href={item.path || '#!'}>{item.title}</Link>
                        ) : (
                          <>
                            <a href="#" className="cursor-pointer" onClick={(e) => {
                              e.preventDefault();
                              const ul = e.currentTarget.nextElementSibling as HTMLElement;
                              if (ul) {
                                ul.style.display = ul.style.display === 'block' ? 'none' : 'block';
                              }
                            }}>
                              {item.title}
                            </a>
                            {item.children && (
                              <ul className={item.megaMenu ? 'mega-menu' : ''}>
                                {item.children.map((child, childIndex) => (
                                  <li key={childIndex}>
                                    <Link href={child.path || '#!'}>{child.title}</Link>
                                  </li>
                                ))}
                              </ul>
                            )}
                          </>
                        )}
                      </li>
                    ))}
                  </ul>
                </nav>
              </div>
              <div className="menu-right pull-right">
                <div>
                  <div className="icon-nav">
                    <ul>
                      <li className="onhover-div mobile-search" data-bs-toggle="modal" data-bs-target="#searchModal">
                        <div>
                          <i className="ri-search-line"></i>
                        </div>
                      </li>
                      <li className="onhover-div mobile-setting">
                        <div>
                          <i className="ri-settings-2-line"></i>
                        </div>
                        <div className="show-div setting">
                          <h6>language</h6>
                          <ul>
                            <li>
                              <a href="#!">english</a>
                            </li>
                            <li>
                              <a href="#!">french</a>
                            </li>
                          </ul>
                          <h6>currency</h6>
                          <ul className="list-inline">
                            <li>
                              <a href="#!">euro</a>
                            </li>
                            <li>
                              <a href="#!">rupees</a>
                            </li>
                            <li>
                              <a href="#!">pound</a>
                            </li>
                            <li>
                              <a href="#!">dollar</a>
                            </li>
                          </ul>
                        </div>
                      </li>
                      <li className="onhover-div mobile-cart" onClick={() => {
                        const offcanvas = document.getElementById('cartOffcanvas');
                        if (offcanvas) offcanvas.classList.add('show');
                      }}>
                        <div>
                          <i className="ri-shopping-cart-line"></i>
                        </div>
                        {mounted && cartCount > 0 && <span className="cart_qty_cls">{cartCount}</span>}
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
