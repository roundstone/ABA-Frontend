import React from 'react';
import { Navigation, Box, MessageSquare, Users } from 'lucide-react';

export default function TopMetrics() {
  return (
    <>
      <div className="col-xxl-3 col-md-6 xl-50">
        <div className="card o-hidden">
          <div className="warning-box card-body">
            <div className="media static-top-widget align-items-center">
              <div className="icons-widgets">
                <div className="align-self-center text-center">
                  <Navigation className="font-warning" />
                </div>
              </div>
              <div className="media-body media-doller">
                <span className="m-0">Earnings</span>
                <h3 className="mb-0">$ <span className="counter">6659</span><small> This Month</small></h3>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="col-xxl-3 col-md-6 xl-50">
        <div className="card o-hidden">
          <div className="secondary-box card-body">
            <div className="media static-top-widget align-items-center">
              <div className="icons-widgets">
                <div className="align-self-center text-center">
                  <Box className="font-secondary" />
                </div>
              </div>
              <div className="media-body media-doller">
                <span className="m-0">Products</span>
                <h3 className="mb-0">$ <span className="counter">9856</span><small> This Month</small></h3>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="col-xxl-3 col-md-6 xl-50">
        <div className="card o-hidden">
          <div className="primary-box card-body">
            <div className="media static-top-widget align-items-center">
              <div className="icons-widgets">
                <div className="align-self-center text-center"><MessageSquare className="font-primary" /></div>
              </div>
              <div className="media-body media-doller"><span className="m-0">Messages</span>
                <h3 className="mb-0">$ <span className="counter">893</span><small> This Month</small></h3>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="col-xxl-3 col-md-6 xl-50">
        <div className="card o-hidden">
          <div className="danger-box card-body">
            <div className="media static-top-widget align-items-center">
              <div className="icons-widgets">
                <div className="align-self-center text-center"><Users className="font-danger" /></div>
              </div>
              <div className="media-body media-doller"><span className="m-0">New Merchants</span>
                <h3 className="mb-0">$ <span className="counter">5631</span><small> This Month</small></h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
