'use client';

import Link from 'next/link';
import { Edit, Trash } from 'lucide-react';
import { useState, useEffect } from 'react';
import { PublicService, PublicProduct } from '@/services/mock/public.service';

export default function AdminProductsList() {
  const [products, setProducts] = useState<PublicProduct[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchProducts = async () => {
      setIsLoading(true);
      const fetchedProducts = await PublicService.getProducts();
      setProducts(fetchedProducts);
      setIsLoading(false);
    };
    fetchProducts();
  }, []);

  const handleDelete = (id: string) => {
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

      <div className="row mb-4">
        <div className="col-12 text-end">
          <Link href="/admin/products/add" className="btn btn-primary">Add Product</Link>
        </div>
      </div>

      {isLoading ? (
        <div className="row text-center mt-5">
          <div className="col-12">
            <div className="spinner-border text-primary" role="status">
              <span className="visually-hidden">Loading...</span>
            </div>
          </div>
        </div>
      ) : (
        <div className="row products-admin ratio_asos">
          {products.map(product => (
            <div className="col-xl-3 col-sm-6" key={product.id}>
              <div className="card bg-white rounded">
                <div className="card-body product-box">
                  <div className="img-wrapper">
                    <div className="front">
                      <a href="#!">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img 
                          src={product.imageUrl} 
                          className="img-fluid w-100" 
                          style={{ aspectRatio: '3/4', objectFit: 'cover' }} 
                          alt={product.name} 
                        />
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
                    <h4>${product.price.toFixed(2)} {product.originalPrice && <del>${product.originalPrice.toFixed(2)}</del>}</h4>
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
      )}
    </div>
  );
}
