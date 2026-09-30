'use client';

import React, { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';

const ReactApexChart = dynamic(() => import('react-apexcharts'), { ssr: false });

export default function MarketValue() {
  const [chartData, setChartData] = useState<any>(null);

  useEffect(() => {
    // Simulate API fetch
    const fetchData = async () => {
      await new Promise(resolve => setTimeout(resolve, 800));
      setChartData({
        series: [{
          name: 'Market Value',
          data: [20, 100, 40, 30, 50, 80, 33]
        }],
        options: {
          chart: {
            height: 300,
            type: 'area',
            toolbar: { show: false }
          },
          dataLabels: { enabled: false },
          stroke: { curve: 'smooth' },
          xaxis: {
            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul']
          },
          colors: ['#ff8084']
        }
      });
    };
    fetchData();
  }, []);

  return (
    <div className="col-xl-6 xl-100">
      <div className="card">
        <div className="card-header">
          <h5>Market Value</h5>
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
          <div className="market-chart" style={{ minHeight: '300px' }}>
            {chartData ? (
              <ReactApexChart 
                options={chartData.options} 
                series={chartData.series} 
                type="area" 
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
    </div>
  );
}
