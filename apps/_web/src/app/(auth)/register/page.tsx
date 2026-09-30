'use client';

import Breadcrumb from '@/components/ui/Breadcrumb';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { useAuthStore } from '@/store/useAuthStore';

export default function RegisterPage() {
  const router = useRouter();
  const login = useAuthStore((state) => state.login);
  
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [referralCode, setReferralCode] = useState(''); // Optional captured referral code

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Auto-generate a personal referral code for the new user
    const generatedReferralCode = `ABA-${Math.floor(Math.random() * 10000)}-SHOE`;

    // Simulate registration by logging them in
    login({
      id: `usr_${Math.random().toString(36).substr(2, 9)}`,
      firstName,
      lastName,
      email,
      role: 'CUSTOMER', // Default role on signup
      isVerified: true,
      referralCode: generatedReferralCode,
    });
    
    // We would normally also store the referral relationship here if referralCode is provided.
    // For now, we just redirect.
    router.push('/');
  };

  return (
    <>
      <Breadcrumb
        title="Register"
        items={[{ label: 'Home', url: '/' }, { label: 'Register' }]}
      />
      <section className="register-page section-b-space">
        <div className="container">
          <div className="row">
            <div className="col-lg-12">
              <h3>Create Account</h3>
              <div className="theme-card">
                <form className="theme-form" onSubmit={handleSubmit}>
                  <div className="row">
                    <div className="col-md-6">
                      <label htmlFor="fname">First Name</label>
                      <input type="text" className="form-control" id="fname" placeholder="First Name" required value={firstName} onChange={e => setFirstName(e.target.value)} />
                    </div>
                    <div className="col-md-6">
                      <label htmlFor="lname">Last Name</label>
                      <input type="text" className="form-control" id="lname" placeholder="Last Name" required value={lastName} onChange={e => setLastName(e.target.value)} />
                    </div>
                  </div>
                  <div className="row mt-3">
                    <div className="col-md-6">
                      <label htmlFor="email">Email</label>
                      <input type="email" className="form-control" id="email" placeholder="Email" required value={email} onChange={e => setEmail(e.target.value)} />
                    </div>
                    <div className="col-md-6">
                      <label htmlFor="password">Password</label>
                      <input type="password" className="form-control" id="password" placeholder="Enter your password" required value={password} onChange={e => setPassword(e.target.value)} />
                    </div>
                  </div>
                  <div className="row mt-3">
                    <div className="col-md-12">
                      <label htmlFor="referral">Referral Code (Optional)</label>
                      <input type="text" className="form-control" id="referral" placeholder="e.g. ABA-10245-SHOE" value={referralCode} onChange={e => setReferralCode(e.target.value)} />
                    </div>
                    <div className="col-md-12 mt-4">
                      <button type="submit" className="btn btn-solid">Create Account</button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
