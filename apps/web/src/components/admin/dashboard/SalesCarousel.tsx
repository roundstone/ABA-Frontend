'use client';

import React, { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';
import { Briefcase, CreditCard, ShoppingCart, Calendar } from 'lucide-react';

const ReactApexChart = dynamic(() => import('react-apexcharts'), { ssr: false });

export default function SalesCarousel() {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    // Simulate API fetch
    const fetchData = async () => {
      await new Promise(resolve => setTimeout(resolve, 800));

      const sparklineOptions = {
        chart: { type: 'area', sparkline: { enabled: true } },
        stroke: { curve: 'smooth', width: 2 },
        fill: { opacity: 0.3 },
        tooltip: {
          fixed: { enabled: false },
          x: { show: false },
          y: { title: { formatter: function (seriesName: string) { return '' } } },
          marker: { show: false }
        }
      };

      setData({
        sales: {
          series: [{ data: [25, 66, 41, 89, 63, 25, 44, 12, 36, 9, 54] }],
          options: { ...sparklineOptions, colors: ['#ff8084'] }
        },
        purchase: {
          series: [{ data: [12, 14, 2, 47, 42, 15, 47, 75, 65, 19, 14] }],
          options: { ...sparklineOptions, colors: ['#13c9ca'] }
        },
        cash: {
          series: [{ data: [47, 45, 74, 14, 56, 74, 14, 11, 7, 39, 82] }],
          options: { ...sparklineOptions, colors: ['#f8d62b'] }
        },
        deposits: {
          series: [{ data: [15, 75, 47, 65, 14, 2, 41, 54, 4, 27, 15] }],
          options: { ...sparklineOptions, colors: ['#ff8084'] } // Danger color normally #ff4c3b, using primary for now
        }
      });
    };
    fetchData();
  }, []);

  return (
    <>
      <div className="col-xl-3 col-md-6 xl-50">
        <div className="card order-graph sales-carousel">
          <div className="card-header b-header">
            <h6>Total Sales</h6>
            <div className="row">
              <div className="col-6">
                <div className="small-chartjs">
                  <div style={{ height: '70px' }}>
                    {data ? <ReactApexChart options={data.sales.options} series={data.sales.series} type="area" height={70} /> : null}
                  </div>
                </div>
              </div>
              <div className="col-6">
                <div className="value-graph">
                  <h3>42% <span><i className="fa fa-angle-up font-primary"></i></span></h3>
                </div>
              </div>
            </div>
          </div>
          <div className="card-body">
            <div className="media">
              <div className="media-body">
                <span>Sales Last Month</span>
                <h2 className="mb-0">9054</h2>
                <p>0.25% <span><i className="fa fa-angle-up"></i></span></p>
              </div>
              <div className="bg-primary">
                <div className="small-box">
                  <Briefcase />
                </div>
              </div>
            </div>
            <div className="sales-contain">
              <h5 className="f-w-600">Gross sales of August</h5>
              <p>Lorem Ipsum is simply dummy text of the printing and typesetting</p>
            </div>
          </div>
        </div>
      </div>
      <div className="col-xl-3 col-md-6 xl-50">
        <div className="card order-graph sales-carousel">
          <div className="card-header b-header">
            <h6>Total purchase</h6>
            <div className="row">
              <div className="col-6">
                <div className="small-chartjs">
                  <div style={{ height: '70px' }}>
                    {data ? <ReactApexChart options={data.purchase.options} series={data.purchase.series} type="area" height={70} /> : null}
                  </div>
                </div>
              </div>
              <div className="col-6">
                <div className="value-graph">
                  <h3>20% <span><i className="fa fa-angle-up font-secondary"></i></span></h3>
                </div>
              </div>
            </div>
          </div>
          <div className="card-body">
            <div className="media">
              <div className="media-body">
                <span>Monthly purchase</span>
                <h2 className="mb-0">2154</h2>
                <p>0.13% <span><i className="fa fa-angle-up"></i></span></p>
              </div>
              <div className="bg-secondary">
                <div className="small-box">
                  <CreditCard />
                </div>
              </div>
            </div>
            <div className="sales-contain">
              <h5 className="f-w-600">Avg Gross purchase</h5>
              <p>Lorem Ipsum is simply dummy text of the printing and typesetting</p>
            </div>
          </div>
        </div>
      </div>
      <div className="col-xl-3 col-md-6 xl-50">
        <div className="card order-graph sales-carousel">
          <div className="card-header b-header">
            <h6>Total cash transaction</h6>
            <div className="row">
              <div className="col-6">
                <div className="small-chartjs">
                  <div style={{ height: '70px' }}>
                    {data ? <ReactApexChart options={data.cash.options} series={data.cash.series} type="area" height={70} /> : null}
                  </div>
                </div>
              </div>
              <div className="col-6">
                <div className="value-graph">
                  <h3>28% <span><i className="fa fa-angle-up font-warning"></i></span></h3>
                </div>
              </div>
            </div>
          </div>
          <div className="card-body">
            <div className="media">
              <div className="media-body">
                <span>Cash on hand</span>
                <h2 className="mb-0">4672</h2>
                <p>0.8% <span><i className="fa fa-angle-up"></i></span></p>
              </div>
              <div className="bg-warning">
                <div className="small-box">
                  <ShoppingCart />
                </div>
              </div>
            </div>
            <div className="sales-contain">
              <h5 className="f-w-600">Details about cash</h5>
              <p>Lorem Ipsum is simply dummy text of the printing and typesetting</p>
            </div>
          </div>
        </div>
      </div>
      <div className="col-xl-3 col-md-6 xl-50">
        <div className="card order-graph sales-carousel">
          <div className="card-header b-header">
            <h6>Daily Deposits</h6>
            <div className="row">
              <div className="col-6">
                <div className="small-chartjs">
                  <div style={{ height: '70px' }}>
                    {data ? <ReactApexChart options={data.deposits.options} series={data.deposits.series} type="area" height={70} /> : null}
                  </div>
                </div>
              </div>
              <div className="col-6">
                <div className="value-graph">
                  <h3>75% <span><i className="fa fa-angle-up font-danger"></i></span></h3>
                </div>
              </div>
            </div>
          </div>
          <div className="card-body">
            <div className="media">
              <div className="media-body">
                <span>Security Deposits</span>
                <h2 className="mb-0">0782</h2>
                <p>0.25% <span><i className="fa fa-angle-up"></i></span></p>
              </div>
              <div className="bg-danger">
                <div className="small-box">
                  <Calendar />
                </div>
              </div>
            </div>
            <div className="sales-contain">
              <h5 className="f-w-600">Gross sales of June</h5>
              <p>Lorem Ipsum is simply dummy text of the printing and typesetting</p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
