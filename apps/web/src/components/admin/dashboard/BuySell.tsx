'use client';

import React, { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';

const ReactApexChart = dynamic(() => import('react-apexcharts'), { ssr: false });

export default function BuySell() {
  const [chartData, setChartData] = useState<any>(null);

  useEffect(() => {
    // Simulate API fetch
    const fetchData = async () => {
      await new Promise(resolve => setTimeout(resolve, 600));
      setChartData({
        series: [{
          name: 'Buy',
          data: [50, 40, 70, 70, 90, 80]
        }, {
          name: 'Sell',
          data: [30, 20, 50, 50, 70, 60]
        }],
        options: {
          chart: {
            height: 300,
            type: 'bar',
            toolbar: { show: false }
          },
          plotOptions: {
            bar: {
              horizontal: false,
              columnWidth: '55%',
              endingShape: 'rounded'
            },
          },
          dataLabels: { enabled: false },
          stroke: { show: true, width: 2, colors: ['transparent'] },
          xaxis: {
            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          },
          fill: { opacity: 1 },
          colors: ['#ff8084', '#13c9ca']
        }
      });
    };
    fetchData();
  }, []);

  return (
    <div className="col-sm-12">
      <div className="card">
        <div className="card-header">
          <h5>Buy / Sell</h5>
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
        <div className="card-body sell-graph" style={{ minHeight: '300px' }}>
          {chartData ? (
            <ReactApexChart 
              options={chartData.options} 
              series={chartData.series} 
              type="bar" 
              height={300} 
            />
          ) : (
            <div className="d-flex justify-content-center align-items-center h-100">
              <span className="text-muted">Loading chart data...</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
