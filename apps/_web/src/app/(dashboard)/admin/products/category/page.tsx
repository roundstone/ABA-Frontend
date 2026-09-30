'use client';

import Link from 'next/link';
import { useState } from 'react';

export default function CategoryPage() {
  const [isModalOpen, setIsModalOpen] = useState(false);

  const categories = [
    { id: 1, name: 'Electronics', status: 'Success', image: '/images/dashboard/product/1.jpg', description: 'Gadgets and electronics' },
    { id: 2, name: 'Fashion', status: 'Success', image: '/images/dashboard/product/2.jpg', description: 'Clothing and apparel' },
    { id: 3, name: 'Home & Decor', status: 'Pending', image: '/images/dashboard/product/3.jpg', description: 'Furniture and decor' },
    { id: 4, name: 'Sports', status: 'Success', image: '/images/dashboard/product/4.jpg', description: 'Sports equipment' },
    { id: 5, name: 'Books', status: 'Success', image: '/images/dashboard/product/5.jpg', description: 'Novels and textbooks' },
  ];

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Category
                  <small>ABA ERP Admin panel</small>
                </h3>
              </div>
            </div>
            <div className="col-lg-6">
              <ol className="breadcrumb pull-right">
                <li className="breadcrumb-item">
                  <Link href="/admin"><i data-feather="home"></i></Link>
                </li>
                <li className="breadcrumb-item">Physical</li>
                <li className="breadcrumb-item active">Category</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-sm-12">
            <div className="card">
              <div className="card-header">
                <form className="form-inline search-form search-box">
                  <div className="form-group">
                    <input className="form-control-plaintext" type="search" placeholder="Search.." />
                  </div>
                </form>

                <button
                  type="button"
                  className="btn btn-primary add-row mt-md-0 mt-2"
                  onClick={() => setIsModalOpen(true)}
                >
                  Add Category
                </button>
              </div>

              <div className="card-body">
                <div className="table-responsive table-desi">
                  <table className="table all-package table-category" id="editableTable">
                    <thead>
                      <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Option</th>
                      </tr>
                    </thead>
                    <tbody>
                      {categories.map((cat) => (
                        <tr key={cat.id}>
                          <td>
                            {/* eslint-disable-next-line @next/next/no-img-element */}
                            <img src={cat.image} alt={cat.name} style={{ width: '50px', height: '50px', objectFit: 'cover' }} />
                          </td>
                          <td data-field="name">{cat.name}</td>
                          <td data-field="description">{cat.description}</td>
                          <td className={cat.status === 'Success' ? 'order-success' : 'order-warning'} data-field="status">
                            <span>{cat.status}</span>
                          </td>
                          <td>
                            <a href="#!">
                              <i className="fa fa-edit" title="Edit"></i>
                            </a>
                            <a href="#!">
                              <i className="fa fa-trash" title="Delete"></i>
                            </a>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {isModalOpen && (
        <>
          <div className="modal-backdrop fade show" style={{ display: 'block' }}></div>
          <div className="modal fade show" style={{ display: 'block' }} tabIndex={-1} role="dialog">
            <div className="modal-dialog" role="document">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title f-w-600">Add Category</h5>
                  <button className="btn-close" type="button" onClick={() => setIsModalOpen(false)}>
                    <span aria-hidden="true">×</span>
                  </button>
                </div>
                <div className="modal-body">
                  <form className="needs-validation">
                    <div className="form">
                      <div className="form-group">
                        <label className="mb-1">Category Name :</label>
                        <input className="form-control" type="text" />
                      </div>
                      <div className="form-group mb-0">
                        <label className="mb-1">Category Image :</label>
                        <input className="form-control" type="file" />
                      </div>
                    </div>
                  </form>
                </div>
                <div className="modal-footer">
                  <button className="btn btn-primary" type="button" onClick={() => setIsModalOpen(false)}>Save</button>
                  <button className="btn btn-secondary" type="button" onClick={() => setIsModalOpen(false)}>Close</button>
                </div>
              </div>
            </div>
          </div>
        </>
      )}
    </>
  );
}
