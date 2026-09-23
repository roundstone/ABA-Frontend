'use client';

import Breadcrumb from '@/components/ui/Breadcrumb';
import UserSidebar from '@/components/layout/UserSidebar';
import { useAuthStore } from '@/store/useAuthStore';

export default function ProfilePage() {
  const { user } = useAuthStore();

  return (
    <>
      <Breadcrumb
        title="Profile"
        items={[{ label: 'Home', url: '/' }, { label: 'Profile' }]}
      />
      <section className="contact-page register-page">
        <div className="container">
          <div className="row">
            <div className="col-lg-3">
              <UserSidebar />
            </div>
            <div className="col-sm-9">
              <h3>PERSONAL DETAIL</h3>
              <form className="theme-form">
                <div className="row">
                  <div className="col-md-6 mb-3">
                    <label htmlFor="name">First Name</label>
                    <input type="text" className="form-control" id="name" placeholder="Enter Your name" defaultValue={user?.firstName} required />
                  </div>
                  <div className="col-md-6 mb-3">
                    <label htmlFor="last-name">Last Name</label>
                    <input type="text" className="form-control" id="last-name" placeholder="Last Name" defaultValue={user?.lastName} required />
                  </div>
                  <div className="col-md-6 mb-3">
                    <label htmlFor="email">Email</label>
                    <input type="email" className="form-control" id="email" placeholder="Email" defaultValue={user?.email} required />
                  </div>
                  <div className="col-md-6 mb-3">
                    <label htmlFor="role">Role</label>
                    <input type="text" className="form-control font-bold" id="role" value={user?.role || 'Guest'} disabled />
                  </div>
                  
                  {user?.referralCode && (
                    <div className="col-md-12 mb-3">
                      <div className="p-3 bg-blue-50 border border-blue-200 rounded">
                        <h4 className="text-blue-800 text-lg mb-2">Your Referral Code</h4>
                        <p className="mb-0 text-sm">Share this code with others to earn commissions!</p>
                        <div className="d-flex align-items-center mt-2">
                          <code className="text-lg bg-white px-3 py-2 border rounded font-bold me-3">
                            {user.referralCode}
                          </code>
                          <button 
                            type="button" 
                            className="btn btn-sm btn-outline"
                            onClick={() => navigator.clipboard.writeText(user.referralCode!)}
                          >
                            Copy
                          </button>
                        </div>
                      </div>
                    </div>
                  )}

                  <div className="col-md-12">
                    <button type="button" className="btn btn-solid">Save Profile</button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
