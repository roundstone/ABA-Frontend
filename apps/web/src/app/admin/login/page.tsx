'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAdminStore } from '@/store/useAdminStore';
import Link from 'next/link';

export default function AdminLoginPage() {
  const router = useRouter();
  const login = useAdminStore((state) => state.login);
  const [formData, setFormData] = useState({ username: '', password: '' });
  const [error, setError] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (formData.username === 'admin' && formData.password === 'admin') {
      login({ id: '1', name: 'Super Admin', role: 'admin' });
      router.push('/admin');
    } else {
      setError('Invalid username or password (use admin/admin)');
    }
  };

  return (
    <div className="authentication-box">
      <div className="container">
        <div className="row justify-content-center align-items-center vh-100">
          <div className="col-md-6 p-0 card-right">
            <div className="card tab2-card card-login">
              <div className="card-body">
                <ul className="nav nav-tabs nav-material" id="top-tab" role="tablist">
                  <li className="nav-item">
                    <a className="nav-link active" id="top-profile-tab" data-bs-toggle="tab" href="#top-profile" role="tab" aria-controls="top-profile" aria-selected="true">
                      <span className="icon-user me-2"></span>Admin Login
                    </a>
                  </li>
                </ul>
                <div className="tab-content" id="top-tabContent">
                  <div className="tab-pane fade show active" id="top-profile" role="tabpanel" aria-labelledby="top-profile-tab">
                    <form className="form-horizontal auth-form" onSubmit={handleSubmit}>
                      {error && (
                        <div className="alert alert-danger p-2 mb-3 text-sm">
                          {error}
                        </div>
                      )}
                      <div className="form-group">
                        <input 
                          required
                          name="username"
                          type="text"
                          className="form-control"
                          placeholder="Username"
                          value={formData.username}
                          onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                        />
                      </div>
                      <div className="form-group">
                        <input
                          required
                          name="password"
                          type="password"
                          className="form-control"
                          placeholder="Password"
                          value={formData.password}
                          onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                        />
                      </div>
                      <div className="form-terms">
                        <div className="form-check mesm-2">
                          <input type="checkbox" className="form-check-input" id="customControlAutosizing" />
                          <label className="form-check-label ps-2" htmlFor="customControlAutosizing">Remember me</label>
                          <Link href="#" className="btn btn-default forgot-pass text-primary">Forgot Password!</Link>
                        </div>
                      </div>
                      <div className="form-button">
                        <button className="btn btn-primary" type="submit">Login</button>
                      </div>
                      <div className="form-footer mt-4 text-center">
                        <small className="text-muted">Return to <Link href="/" className="text-primary">Storefront</Link></small>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
