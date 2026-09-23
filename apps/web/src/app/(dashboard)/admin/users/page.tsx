'use client';

import { UserService, User } from '@/services/mock/user.service';
import Link from 'next/link';
import { useEffect, useState } from 'react';

export default function AdminUserList() {
  const [users, setUsers] = useState<User[]>([]);
  const [mounted, setMounted] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    setMounted(true);
    setUsers(UserService.getUsers());
  }, []);

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this user?')) {
      UserService.deleteUser(id);
      setUsers(UserService.getUsers());
    }
  };

  if (!mounted) return null;

  const filteredUsers = users.filter(
    (u) =>
      u.firstName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      u.lastName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      u.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
      u.role.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>User List
                  <small>ABA ERP Admin panel</small>
                </h3>
              </div>
            </div>
            <div className="col-lg-6">
              <ol className="breadcrumb pull-right">
                <li className="breadcrumb-item">
                  <Link href="/admin">
                    <i data-feather="home"></i>
                  </Link>
                </li>
                <li className="breadcrumb-item">Users</li>
                <li className="breadcrumb-item active">User List</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <form className="form-inline search-form search-box">
              <div className="form-group mb-0">
                <input 
                  className="form-control-plaintext" 
                  type="search" 
                  placeholder="Search Users..." 
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>
            </form>

            <Link href="/admin/users/create" className="btn btn-primary">Create User</Link>
          </div>

          <div className="card-body">
            <div className="table-responsive table-desi">
              <table className="table all-package table-category">
                <thead>
                  <tr>
                    <th>Avatar</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Last Login</th>
                    <th>Role</th>
                    <th>Options</th>
                  </tr>
                </thead>

                <tbody>
                  {filteredUsers.length === 0 ? (
                    <tr>
                      <td colSpan={7} className="text-center py-4">No users found.</td>
                    </tr>
                  ) : (
                    filteredUsers.map((user) => (
                      <tr key={user.id}>
                        <td>
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img 
                            src={user.avatar || '/images/dashboard/user.jpg'} 
                            alt={`${user.firstName} ${user.lastName}`} 
                            className="img-fluid blur-up lazyloaded"
                            style={{ width: '50px', height: '50px', borderRadius: '50%', objectFit: 'cover' }}
                          />
                        </td>
                        <td>{user.firstName}</td>
                        <td>{user.lastName}</td>
                        <td>{user.email}</td>
                        <td>{user.lastLogin}</td>
                        <td>
                          <span className={`badge ${user.role === 'Admin' ? 'badge-primary' : 'badge-secondary'}`}>
                            {user.role}
                          </span>
                        </td>
                        <td>
                          <a href="#!" onClick={(e) => e.preventDefault()} className="me-2">
                            <i className="fa fa-edit" title="Edit"></i>
                          </a>
                          <a href="#!" onClick={(e) => { e.preventDefault(); handleDelete(user.id); }}>
                            <i className="fa fa-trash font-danger" title="Delete"></i>
                          </a>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
