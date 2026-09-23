'use client';

import React, { useEffect, useState } from 'react';
import { useAdminStore } from '@/store/useAdminStore';
import { useRouter } from 'next/navigation';
import AdminHeader from '@/components/admin/AdminHeader';
import AdminSidebar from '@/components/admin/AdminSidebar';

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  const { isSidebarOpen, isAuthenticated } = useAdminStore();
  const router = useRouter();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    if (!isAuthenticated) {
      router.push('/admin/login');
    }
  }, [isAuthenticated, router]);

  if (!mounted || !isAuthenticated) {
    return (
      <>
        {/* Render CSS links during SSR to prevent FOUC */}
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Work+Sans:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,500;1,600;1,700;1,800;1,900&display=swap" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/merchants/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/merchants/icofont.css" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/merchants/flag-icon.css" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/merchants/bootstrap.css" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/style.css" />
        
        <div style={{ height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', backgroundColor: '#f8f9fa' }}>
          <div className="spinner-border text-primary" role="status" style={{ width: '3rem', height: '3rem' }}>
            <span className="visually-hidden">Loading...</span>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
        {/* Load Admin Specific CSS overriding global styles where necessary */}
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Work+Sans:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,500;1,600;1,700;1,800;1,900&display=swap" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/merchants/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/merchants/icofont.css" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/merchants/flag-icon.css" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/merchants/bootstrap.css" />
        <link rel="stylesheet" type="text/css" href="/admin-assets/css/style.css" />
      
      {/* We apply a wrapper class that sets background and fixes body conflicts if needed */}
      <div className="admin-theme page-wrapper">
        <AdminHeader />
        <div className="page-body-wrapper">
          <AdminSidebar />
          <div className="page-body">
            {children}
          </div>
        </div>
      </div>
    </>
  );
}
