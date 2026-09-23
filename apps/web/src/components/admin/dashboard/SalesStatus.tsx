'use client';

import React, { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';

const ReactApexChart = dynamic(() => import('react-apexcharts'), { ssr: false });

export default function SalesStatus() {
  const [pieData, setPieData] = useState<any>(null);
  const [donutData, setDonutData] = useState<any>(null);
  const [lineData, setLineData] = useState<any>(null);

  useEffect(() => {
    // Simulate API fetch
    const fetchData = async () => {
      await new Promise(resolve => setTimeout(resolve, 800));

      setPieData({
        series: [157, 347, 468, 742, 672],
        options: {
          chart: { type: 'pie', height: 250 },
          labels: ['Saint Lucia', 'Kenya', 'Liberia', 'Christmas Island', 'Svalbard'],
          colors: ['#ff8084', '#13c9ca', '#f8d62b', '#51bb25', '#a5a5a5'],
          legend: { show: false },
          dataLabels: { enabled: false }
        }
      });

      setDonutData({
        series: [157, 347, 468, 742, 672],
        options: {
          chart: { type: 'donut', height: 250 },
          labels: ['Saint Lucia', 'Kenya', 'Liberia', 'Christmas Island', 'Svalbard'],
          colors: ['#ff8084', '#13c9ca', '#f8d62b', '#51bb25', '#a5a5a5'],
          legend: { show: false },
          dataLabels: { enabled: false },
          plotOptions: {
            pie: { donut: { size: '70%' } }
          }
        }
      });

      setLineData({
        series: [{
          name: 'Revenue',
          data: [10, 20, 15, 30, 25, 40, 35]
        }],
        options: {
          chart: { type: 'line', height: 250, toolbar: { show: false } },
          stroke: { curve: 'smooth', width: 3 },
          colors: ['#13c9ca'],
          xaxis: { categories: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] }
        }
      });
    };
    fetchData();
  }, []);

  return (
    <div className="col-sm-12">
      <div className="card">
        <div className="card-header">
          <h5>Sales Status</h5>
          <div className="card-header-right">
            <ul className="list-unstyled card-option">
              <li><i className="icofont icofont-simple-left"></i></li>
              <li><i className="view-html fa fa-code"></i></li>
              <li><i className="icofont icofont-maximize full-card"></i></li>
              <li><i className="icofont icofont-minus minimize-card"></i></li>
              <li><i className="icofont icofont-refresh reload-card"></i></li>
              <li><i className="icofont icofont-error close-card"></i></li>
            </ul>
          </div>
        </div>
        <div className="card-body">
          <div className="row">
            <div className="col-xl-3 col-sm-6 xl-50">
              <div className="order-graph">
                <h6>Sales By Location</h6>
                <div className="chart-block chart-vertical-center text-center">
                  <div style={{ height: '250px' }}>
                    {pieData ? (
                      <ReactApexChart options={pieData.options} series={pieData.series} type="pie" height={250} />
                    ) : (
                      <span className="text-muted">Loading...</span>
                    )}
                  </div>
                </div>
                <div className="order-graph-bottom text-center">
                  <div className="media">
                    <div className="order-color-primary"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Saint Lucia <span className="pull-right">$157</span></h6>
                    </div>
                  </div>
                  <div className="media">
                    <div className="order-color-secondary"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Kenya <span className="pull-right">$347</span></h6>
                    </div>
                  </div>
                  <div className="media">
                    <div className="order-color-danger"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Liberia<span className="pull-right">$468</span></h6>
                    </div>
                  </div>
                  <div className="media">
                    <div className="order-color-warning"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Christmas Island<span className="pull-right">$742</span></h6>
                    </div>
                  </div>
                  <div className="media">
                    <div className="order-color-info"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Svalbard <span className="pull-right">$672</span></h6>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-xl-3 col-sm-6 xl-50">
              <div className="order-graph sm-order-space">
                <h6>Sales By Location</h6>
                <div className="peity-chart-dashboard text-center">
                  <div style={{ height: '250px' }}>
                    {donutData ? (
                      <ReactApexChart options={donutData.options} series={donutData.series} type="donut" height={250} />
                    ) : (
                      <span className="text-muted">Loading...</span>
                    )}
                  </div>
                </div>
                <div className="order-graph-bottom text-center">
                  <div className="media">
                    <div className="order-color-primary"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Saint Lucia <span className="pull-right">$157</span></h6>
                    </div>
                  </div>
                  <div className="media">
                    <div className="order-color-secondary"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Kenya <span className="pull-right">$347</span></h6>
                    </div>
                  </div>
                  <div className="media">
                    <div className="order-color-danger"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Liberia<span className="pull-right">$468</span></h6>
                    </div>
                  </div>
                  <div className="media">
                    <div className="order-color-warning"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Christmas Island<span className="pull-right">$742</span></h6>
                    </div>
                  </div>
                  <div className="media">
                    <div className="order-color-info"></div>
                    <div className="media-body">
                      <h6 className="mb-0">Svalbard <span className="pull-right">$672</span></h6>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-xl-6 xl-100">
              <div className="order-graph xl-space">
                <h6>Revenue for last month</h6>
                <div className="ct-4 flot-chart-container text-center">
                  <div style={{ height: '250px' }}>
                    {lineData ? (
                      <ReactApexChart options={lineData.options} series={lineData.series} type="line" height={250} />
                    ) : (
                      <span className="text-muted">Loading...</span>
                    )}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
