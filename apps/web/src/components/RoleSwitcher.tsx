"use client";

import React, { useState } from 'react';
import { useAuthStore, UserRole } from '@/store/useAuthStore';

const ROLES: UserRole[] = [
  'CUSTOMER', 'DISTRIBUTOR', 'MERCHANT', 'SALES',
  'PROCUREMENT', 'PRODUCTION', 'STORE', 'FINANCE',
  'ADMIN', 'MANAGEMENT', 'SUPPORT'
];

export default function RoleSwitcher() {
  const { user, switchRole, logout } = useAuthStore();
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div style={{ position: 'fixed', bottom: '1rem', right: '1rem', zIndex: 9999 }}>
      {isOpen && (
        <div style={{ backgroundColor: 'white', border: '1px solid #ccc', borderRadius: '8px', boxShadow: '0 4px 6px rgba(0,0,0,0.1)', padding: '1rem', marginBottom: '0.5rem', minWidth: '250px' }}>
          <h3 style={{ fontWeight: 'bold', fontSize: '1.125rem', margin: '0 0 0.5rem 0' }}>Dev Role Switcher</h3>
          <p style={{ fontSize: '0.875rem', color: '#6b7280', margin: '0 0 1rem 0' }}>
            Current: <span style={{ fontWeight: 'bold', color: '#2563eb' }}>{user?.role || 'Logged Out'}</span>
          </p>
          <div style={{ maxHeight: '300px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
            {ROLES.map(role => (
              <button
                key={role}
                onClick={() => {
                  switchRole(role);
                  setIsOpen(false);
                }}
                style={{
                  textAlign: 'left',
                  padding: '0.5rem 0.75rem',
                  fontSize: '0.875rem',
                  borderRadius: '4px',
                  border: 'none',
                  cursor: 'pointer',
                  backgroundColor: user?.role === role ? '#dbeafe' : 'transparent',
                  color: user?.role === role ? '#1e40af' : '#374151',
                  fontWeight: user?.role === role ? '500' : 'normal',
                }}
              >
                {role}
              </button>
            ))}
          </div>
          {user && (
            <button
              onClick={() => {
                logout();
                setIsOpen(false);
              }}
              style={{
                marginTop: '1rem',
                width: '100%',
                textAlign: 'center',
                padding: '0.5rem 0.75rem',
                fontSize: '0.875rem',
                color: '#dc2626',
                backgroundColor: 'transparent',
                border: 'none',
                borderRadius: '4px',
                cursor: 'pointer'
              }}
            >
              Log Out
            </button>
          )}
        </div>
      )}
      
      <button
        onClick={() => setIsOpen(!isOpen)}
        style={{
          width: '3rem',
          height: '3rem',
          borderRadius: '50%',
          backgroundColor: '#2563eb',
          color: 'white',
          boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          border: 'none',
          cursor: 'pointer'
        }}
        aria-label="Toggle role switcher"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
          <circle cx="9" cy="7" r="4"></circle>
          <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
          <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
        </svg>
      </button>
    </div>
  );
}
