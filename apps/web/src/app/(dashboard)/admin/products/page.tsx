'use client';

import Link from 'next/link';
import { Edit, Trash } from 'lucide-react';
import { useState } from 'react';

// Dummy products data
const initialProducts = [
  { id: 1, name: 'Slim Fit Cotton Shirt', price: 500, oldPrice: 600, image: '/admin-assets/images/pro3/34.jpg' },
  { id: 2, name: 'Wireless Headphones', price: 120, oldPrice: 150, image: '/admin-assets/images/electronics/product/1.jpg' },
  { id: 3, name: 'Wooden Chair', price: 250, oldPrice: 300, image: '/admin-assets/images/furniture/product/1.jpg' },
  { id: 4, name: 'Leather Jacket', price: 400, oldPrice: 550, image: '/admin-assets/images/fashion/product/17.jpg' },
];

export default function AdminProductsList() {
  const [products, setProducts] = useState(initialProducts);

  const handleDelete = (id: number) => {
    setProducts(products.filter(p => p.id !== id));
  };

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Product List
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
              <li className="breadcrumb-item">Products</li>
              <li className="breadcrumb-item active">Product List</li>
            </ol>
          </div>
        </div>
      </div>

      <div className="row products-admin ratio_asos">
        {products.map(product => (
          <div className="col-xl-3 col-sm-6" key={product.id}>
            <div className="card">
              <div className="card-body product-box">
                <div className="img-wrapper">
                  <div className="front">
                    <a href="#!">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={product.image} className="img-fluid blur-up lazyload bg-img" alt="" />
                    </a>
                    <div className="product-hover">
                      <ul>
                        <li>
                          <button className="btn" type="button" title="Edit">
                            <Edit size={16} />
                          </button>
                        </li>
                        <li>
                          <button className="btn" type="button" title="Delete" onClick={() => handleDelete(product.id)}>
                            <Trash size={16} />
                          </button>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
                <div className="product-detail">
                  <div className="rating">
                    <i className="fa fa-star"></i>
                    <i className="fa fa-star"></i>
                    <i className="fa fa-star"></i>
                    <i className="fa fa-star"></i>
                    <i className="fa fa-star"></i>
                  </div>
                  <a href="#!">
                    <h6>{product.name}</h6>
                  </a>
                  <h4>${product.price.toFixed(2)} <del>${product.oldPrice.toFixed(2)}</del></h4>
                  <ul className="color-variant">
                    <li className="bg-light0"></li>
                    <li className="bg-light1"></li>
                    <li className="bg-light2"></li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
