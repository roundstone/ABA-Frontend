'use client';

import React from 'react';

export default function ProductModals() {
  return (
    <>
      {/* Ask Question Modal */}
      <div className="modal fade question-answer-modal theme-modal-2" id="ask-question" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="fw-semibold">Ask A Question</h3>
              <button className="btn btn-close" data-bs-dismiss="modal" type="button">
                <i className="ri-close-line"></i>
              </button>
            </div>
            <div className="modal-body">
              <form className="product-review-form">
                <div className="product-wrapper">
                  <div className="product-image">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img alt="Product" className="img-fluid" src="/images/pro3/1.jpg" />
                  </div>
                  <div className="product-content">
                    <h5 className="name"> Sport Set </h5>
                    <div className="product-review-rating">
                      <div className="product-rating">
                        <h6 className="price-number">$32.79</h6>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="review-box form-box">
                  <label className="form-label" htmlFor="content">Your Questions *</label>
                  <textarea className="form-control" id="content" placeholder="Your Questions" rows={3}></textarea>
                </div>
              </form>
              <div className="modal-footer">
                <button className="btn btn-outline" data-bs-dismiss="modal" type="button">Cancel</button>
                <button className="btn btn-solid" data-bs-dismiss="modal" type="button">Submit</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Delivery & Return Modal */}
      <div className="modal fade theme-modal-2" id="return" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="fw-semibold">Delivery &amp; Return</h3>
              <button className="btn btn-close" data-bs-dismiss="modal" type="button">
                <i className="ri-close-line"></i>
              </button>
            </div>
            <div className="modal-body policy-body">
              <p>Shipping and Returns are integral parts of your shopping experience, and we aim to make them as smooth as possible. We prioritize efficient shipping, striving to deliver your orders promptly within the estimated delivery window, typically ranging from 5 to 7 days. We understand that sometimes your purchase may not meet your expectations, so we offer a straightforward return policy. If you find yourself unsatisfied with your order, eligible items can be returned within 30 days of purchase, ensuring you have ample time to make a decision. Our commitment is to ensure your satisfaction and convenience throughout your shopping journey with us, and we&apos;re here to assist you every step of the way.</p>
              <p><strong>Our Shipping Commitment:</strong></p>
              <ul>
                <li><p>Timely and reliable delivery within 5-7 days.</p></li>
                <li><p>Real-time tracking for your orders.</p></li>
                <li><p>Exceptional packaging to ensure your items arrive in perfect condition.</p></li>
              </ul>
              <p><strong>Our Hassle-Free Returns:</strong></p>
              <ul>
                <li><p>Eligible items can be returned within 30 days.</p></li>
                <li><p>Easy return initiation through our website.</p></li>
                <li><p>Prompt processing of returns for a hassle-free experience.</p></li>
              </ul>
              <p>We understand that your shopping needs may vary, and we are here to accommodate them while providing exceptional service.</p>
            </div>
          </div>
        </div>
      </div>

      {/* Share Modal */}
      <div className="modal fade theme-modal-2" id="share" tabIndex={-1}>
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="fw-semibold">Share Product</h3>
              <button className="btn btn-close" data-bs-dismiss="modal" type="button">
                <i className="ri-close-line"></i>
              </button>
            </div>
            <div className="modal-body">
              <div className="d-flex align-items-center justify-content-center gap-3">
                <a href="#!" className="btn btn-solid"><i className="ri-facebook-fill"></i></a>
                <a href="#!" className="btn btn-solid"><i className="ri-twitter-fill"></i></a>
                <a href="#!" className="btn btn-solid"><i className="ri-whatsapp-fill"></i></a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
