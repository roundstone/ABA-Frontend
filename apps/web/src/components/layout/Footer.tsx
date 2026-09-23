'use client';

import Link from 'next/link';
import Image from 'next/image';

export default function Footer() {
  return (
    <footer>
      <div className="dark-layout">
        <div className="container">
          <section className="section-b-space border-b">
            <div className="row footer-theme2">
              <div className="col-lg-3">
                <div className="footer-title footer-mobile-title">
                  <h4>about</h4>
                </div>
                <div className="footer-content">
                  <Link href="/" className="footer-logo d-block">
                    <Image src="/images/bags/logo-white.png" alt="Logo" width={150} height={40} />
                  </Link>
                  <p>
                    Discover the latest fashion trends and enjoy seamless shopping with our carefully curated exclusive collections, designed to elevate your wardrobe.
                  </p>
                </div>
              </div>
              <div className="col-lg-6 subscribe-wrapper">
                <div className="subscribe-block">
                  <h2>newsletter</h2>
                  <form onSubmit={(e) => e.preventDefault()}>
                    <div className="form-group">
                      <input className="form-control" placeholder="Enter your email" type="email" required />
                      <button className="btn btn-solid" type="submit">
                        subscribe
                      </button>
                    </div>
                  </form>
                </div>
              </div>
              <div className="col-lg-3">
                <div className="footer-title">
                  <h4>store information</h4>
                </div>
                <div className="footer-content">
                  <ul className="contact-details">
                    <li>Multikart Demo Store, Demo store India 345-659</li>
                    <li>Call Us: 123-456-7898</li>
                    <li>
                      Email Us: <a href="mailto:Support@Multikart.com">Support@Multikart.com</a>
                    </li>
                    <li>Fax: 123456</li>
                  </ul>
                </div>
              </div>
            </div>
          </section>
        </div>
      </div>
      <div className="dark-layout">
        <div className="container">
          <section className="small-section">
            <div className="row footer-theme2">
              <div className="col p-set">
                <div className="footer-link">
                  <div className="footer-title">
                    <h4>my account</h4>
                  </div>
                  <div className="footer-content">
                    <ul>
                      <li><Link href="#!">mens</Link></li>
                      <li><Link href="#!">womans</Link></li>
                      <li><Link href="#!">clothing</Link></li>
                      <li><Link href="#!">accessories</Link></li>
                      <li><Link href="#!">featured</Link></li>
                    </ul>
                  </div>
                </div>
                <div className="footer-link-b">
                  <div className="footer-title">
                    <h4>why we choose</h4>
                  </div>
                  <div className="footer-content">
                    <ul>
                      <li><Link href="#!">shipping & return</Link></li>
                      <li><Link href="#!">secure shopping</Link></li>
                      <li><Link href="#!">gallery</Link></li>
                      <li><Link href="#!">affiliates</Link></li>
                      <li><Link href="#!">contacts</Link></li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </section>
        </div>
      </div>
      <div className="sub-footer darker-subfooter">
        <div className="container">
          <div className="row">
            <div className="col-xl-6 col-md-6 col-sm-12">
              <div className="footer-end">
                <p>
                  <i className="ri-copyright-line"></i> 2024 powered by Next.js
                </p>
              </div>
            </div>
            <div className="col-xl-6 col-md-6 col-sm-12">
              <div className="payment-card-bottom">
                <Image src="/images/payment.png" alt="Payment" width={250} height={25} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
