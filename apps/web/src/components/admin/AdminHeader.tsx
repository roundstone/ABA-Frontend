'use client';

import { useAdminStore } from '@/store/useAdminStore';
import { useAuthStore } from '@/store/useAuthStore';
import { AlignLeft, Bell, LogOut, Maximize2, MessageSquare, Search, Settings, User } from 'lucide-react';
import Link from 'next/link';

export default function AdminHeader() {
  const { toggleSidebar, toggleFullScreen, logout, user, isSidebarOpen } = useAdminStore();

  return (
    <div className={`page-main-header ${!isSidebarOpen ? 'open' : ''}`}>
      <div className="main-header-right row">
        <div className="main-header-left d-lg-none w-auto">
          <div className="logo-wrapper">
            <Link href="/admin">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img className="blur-up lazyloaded d-block d-lg-none" src="/admin-assets/images/dashboard/multikart-logo-black.png" alt="logo" />
            </Link>
          </div>
        </div>
        <div className="mobile-sidebar w-auto">
          <div className="media-body text-end switch-sm">
            <label className="switch">
              <a href="#!" onClick={(e) => { e.preventDefault(); toggleSidebar(); }}>
                <AlignLeft id="sidebar-toggle" />
              </a>
            </label>
          </div>
        </div>
        <div className="nav-right col">
          <ul className="nav-menus">
            <li>
              <form className="form-inline search-form">
                <div className="form-group">
                  <input className="form-control-plaintext" type="search" placeholder="Search.." />
                  <span className="d-sm-none mobile-search">
                    <Search />
                  </span>
                </div>
              </form>
            </li>
            <li>
              <a className="text-dark" href="#!" onClick={(e) => { e.preventDefault(); toggleFullScreen(); }}>
                <Maximize2 />
              </a>
            </li>
            <li className="onhover-dropdown">
              <a className="txt-dark" href="#!">
                <h6>EN</h6>
              </a>
              <ul className="language-dropdown onhover-show-div p-20">
                <li><a href="#!" data-lng="en"><i className="flag-icon flag-icon-us"></i>English</a></li>
              </ul>
            </li>
            <li className="onhover-dropdown">
              <Bell />
              <span className="badge badge-pill badge-primary pull-right notification-badge">3</span>
              <span className="dot"></span>
              <ul className="notification-dropdown onhover-show-div p-0">
                <li>Notification <span className="badge badge-pill badge-primary pull-right">3</span></li>
                <li className="txt-dark"><a href="#!">All</a> notification</li>
              </ul>
            </li>
            <li>
              <a href="#!">
                <MessageSquare className="right_side_toggle" />
                <span className="dot"></span>
              </a>
            </li>
            <li className="onhover-dropdown">
              <div className="media align-items-center">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img className="align-self-center pull-right img-50 blur-up lazyloaded" src="/admin-assets/images/dashboard/user3.jpg" alt="header-user" />
                <div className="dotted-animation">
                  <span className="animate-circle"></span>
                  <span className="main-circle"></span>
                </div>
              </div>
              <ul className="profile-dropdown onhover-show-div p-20 profile-dropdown-hover">
                <li>
                  <a href="#!">
                    <User />Edit Profile
                  </a>
                </li>
                <li>
                  <a href="#!">
                    <Settings />Settings
                  </a>
                </li>
                <li>
                  <a href="#!" onClick={(e) => { e.preventDefault(); logout(); }}>
                    <LogOut />Logout
                  </a>
                </li>
              </ul>
            </li>
          </ul>
          <div className="d-lg-none mobile-toggle pull-right" onClick={() => toggleSidebar()}>
            <AlignLeft />
          </div>
        </div>
      </div>
    </div>
  );
}
