'use client';

import Breadcrumb from '@/components/ui/Breadcrumb';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { useAuthStore, UserRole } from '@/store/useAuthStore';

export default function LoginPage() {
  const router = useRouter();
  const login = useAuthStore((state) => state.login);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Determine role and redirect path based on email for simulation
    const isVendor = email.toLowerCase().includes('distributor');
    const role = isVendor ? 'DISTRIBUTOR' : 'CUSTOMER' as UserRole;
    const redirectPath = isVendor ? '/merchant/dashboard' : '/account/dashboard';

    // Simulate login
    login({
      id: `usr_${Math.random().toString(36).substr(2, 9)}`,
      firstName: isVendor ? 'Merchant' : 'John',
      lastName: isVendor ? 'User' : 'Doe',
      email,
      role,
      isVerified: true,
      referralCode: `ABA-${Math.floor(Math.random() * 10000)}-SHOE`,
    });
    router.push(redirectPath);
  };

  return (
    <>
      <Breadcrumb
        title="Login"
        items={[{ label: 'Home', url: '/' }, { label: 'Login' }]}
      />
      <section className="login-page section-b-space">
        <div className="container">
          <div className="row">
            <div className="col-lg-6">
              <h3>Login</h3>
              <div className="theme-card">
                <form className="theme-form" onSubmit={handleSubmit}>
                  <div className="form-group">
                    <label htmlFor="email">Email</label>
                    <input type="email" className="form-control" id="email" placeholder="Email" required value={email} onChange={e => setEmail(e.target.value)} />
                  </div>
                  <div className="form-group">
                    <label htmlFor="review">Password</label>
                    <input type="password" className="form-control" id="review" placeholder="Enter your password" required value={password} onChange={e => setPassword(e.target.value)} />
                  </div>
                  <button type="submit" className="btn btn-solid">Login</button>
                  <Link href="/forgot-password" className="float-end mt-2">Forgot Password?</Link>
                </form>
              </div>
            </div>
            <div className="col-lg-6 right-login">
              <h3>New Customer</h3>
              <div className="theme-card authentication-right">
                <h6 className="title-font">Create A Account</h6>
                <p>Sign up for a free account at our store. Registration is quick and easy. It allows you to be able to order from our shop. To start shopping click register.</p>
                <Link href="/register" className="btn btn-solid">Create an Account</Link>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
