'use client';

import Link from 'next/link';
import { Plus } from 'lucide-react';
import { useState } from 'react';

export default function AdminAddProduct() {
  const [formData, setFormData] = useState({
    title: '',
    price: '',
    productCode: '',
    size: 'Small',
    quantity: 1,
    description: '',
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log('Submitting Product:', formData);
    alert('Product added successfully!');
  };

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Add Products
                <small>ABA ERP Admin panel</small>
              </h3>
            </div>
          </div>
          <div className="col-lg-6">
            <ol className="breadcrumb pull-right">
              <li className="breadcrumb-item">
                <Link href="/admin"><i data-feather="home"></i></Link>
              </li>
              <li className="breadcrumb-item">Products</li>
              <li className="breadcrumb-item active">Add Product</li>
            </ol>
          </div>
        </div>
      </div>

      <div className="row">
        <div className="col-sm-12">
          <div className="card">
            <div className="card-body">
              <div className="row product-adding">
                <div className="col-xl-5">
                  <div className="add-product">
                    <div className="row">
                      <div className="col-xl-9 xl-50 col-sm-6 col-9">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img src="/admin-assets/images/pro3/1.jpg" alt="" className="img-fluid image_zoom_1 blur-up lazyloaded" />
                      </div>
                      <div className="col-xl-3 xl-50 col-sm-6 col-3">
                        <ul className="file-upload-product">
                          {[...Array(6)].map((_, i) => (
                            <li key={i}>
                              <div className="box-input-file">
                                <input className="upload" type="file" />
                                <Plus size={16} />
                              </div>
                            </li>
                          ))}
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="col-xl-7">
                  <form className="needs-validation add-product-form" onSubmit={handleSubmit}>
                    <div className="form">
                      <div className="form-group mb-3 row">
                        <label htmlFor="title" className="col-xl-3 col-sm-4 mb-0">Title :</label>
                        <div className="col-xl-8 col-sm-7">
                          <input className="form-control" id="title" name="title" type="text" required value={formData.title} onChange={handleChange} />
                        </div>
                      </div>
                      <div className="form-group mb-3 row">
                        <label htmlFor="price" className="col-xl-3 col-sm-4 mb-0">Price :</label>
                        <div className="col-xl-8 col-sm-7">
                          <input className="form-control" id="price" name="price" type="number" required value={formData.price} onChange={handleChange} />
                        </div>
                      </div>
                      <div className="form-group mb-3 row">
                        <label htmlFor="productCode" className="col-xl-3 col-sm-4 mb-0">Product Code :</label>
                        <div className="col-xl-8 col-sm-7">
                          <input className="form-control" id="productCode" name="productCode" type="text" required value={formData.productCode} onChange={handleChange} />
                        </div>
                      </div>
                    </div>
                    <div className="form">
                      <div className="form-group row">
                        <label htmlFor="size" className="col-xl-3 col-sm-4 mb-0">Select Size :</label>
                        <div className="col-xl-8 col-sm-7">
                          <select className="form-control digits" id="size" name="size" value={formData.size} onChange={handleChange}>
                            <option>Small</option>
                            <option>Medium</option>
                            <option>Large</option>
                            <option>Extra Large</option>
                          </select>
                        </div>
                      </div>
                      <div className="form-group row">
                        <label className="col-xl-3 col-sm-4 mb-0">Total Products :</label>
                        <fieldset className="qty-box col-xl-9 col-xl-8 col-sm-7">
                          <div className="input-group">
                            <input className="touchspin form-control" type="number" name="quantity" value={formData.quantity} onChange={handleChange} />
                          </div>
                        </fieldset>
                      </div>
                      <div className="form-group row">
                        <label className="col-xl-3 col-sm-4">Add Description :</label>
                        <div className="col-xl-8 col-sm-7 description-sm">
                          <textarea className="form-control" name="description" cols={10} rows={4} value={formData.description} onChange={handleChange}></textarea>
                        </div>
                      </div>
                      <div className="form-group row mt-4">
                        <div className="col-xl-8 col-sm-7 offset-xl-3 offset-sm-4">
                          <button type="submit" className="btn btn-primary me-2">Add</button>
                          <button type="button" className="btn btn-light" onClick={() => setFormData({
                            title: '', price: '', productCode: '', size: 'Small', quantity: 1, description: ''
                          })}>Discard</button>
                        </div>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
