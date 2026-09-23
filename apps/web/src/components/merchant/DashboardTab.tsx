'use client';

import dynamic from 'next/dynamic';
import { ApexOptions } from 'apexcharts';
import Image from 'next/image';

const ReactApexChart = dynamic(() => import('react-apexcharts'), { ssr: false });

export default function DashboardTab() {
  const revenueOptions: ApexOptions = {
    chart: {
      type: 'area',
      height: 250,
      zoom: { enabled: false },
      toolbar: { show: true },
    },
    dataLabels: { enabled: false },
    markers: { size: 0 },
    grid: { borderColor: 'transparent' },
    xaxis: {
      type: 'datetime',
      tickAmount: 6,
      labels: {
        offsetX: 0,
        offsetY: 0
      }
    },
    yaxis: {
      opposite: true,
      labels: {
        offsetX: 0,
        offsetY: 0
      }
    },
    stroke: { width: 2 },
    title: { text: 'Total Revenue', align: 'left' },
    subtitle: { text: 'Price Movements', align: 'left' },
    tooltip: { x: { format: 'dd MMM yyyy' } },
    colors: ['#ff4c3b'],
    fill: {
      type: 'gradient',
      gradient: {
        shadeIntensity: 1,
        opacityFrom: 0.6,
        opacityTo: 0.5,
        stops: [0, 100]
      }
    },
  };

  const revenueSeries = [{
    name: "Revenue",
    data: [
      [1351202400000, 37.30], [1351638000000, 37.60], [1351724400000, 37.50], [1351810800000, 37.55],
      [1352070000000, 37.40], [1352256400000, 37.55], [1352342800000, 37.45], [1352429200000, 37.60],
      [1352515600000, 37.50], [1352624000000, 37.30], [1352761200000, 37.20], [1353134000000, 37.25],
      [1353220400000, 37.22], [1353279600000, 37.30], [1353466000000, 37.23], [1353632400000, 37.30],
      [1353757200000, 37.28], [1353857200000, 37.30], [1353957200000, 37.28], [1354021500000, 37.10],
      [1354175600000, 37.28], [1354262000000, 37.22], [1354748400000, 37.50], [1354834800000, 37.55],
      [1354894000000, 37.65], [1355080400000, 37.50], [1355166800000, 37.40], [1355353200000, 37.50],
      [1355439600000, 37.45], [1355698800000, 37.51], [1355785200000, 37.40],
    ]
  }];

  const salesOptions: ApexOptions = {
    chart: { type: 'donut', height: 250 },
    dataLabels: { enabled: false },
    title: { text: "Overall Sales" },
    labels: ['Recent Order', 'Pending Payments', 'Received Payments'],
    colors: ['#f7bfc1', '#c8c8c8', '#ff8181'],
    responsive: [
      { breakpoint: 1430, options: { chart: { width: 280, height: 285 }, legend: { position: 'bottom' } } },
      { breakpoint: 1199, options: { chart: { width: 250, height: 290 }, legend: { position: 'bottom' } } }
    ]
  };

  const salesSeries = [20, 25, 55];

  return (
    <div className="tab-pane fade show active" id="dashboard">
      <div className="counter-section">
        <div className="row">
          <div className="col-md-4">
            <div className="counter-box">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img alt="" className="img-fluid" src="/assets/images/icon/dashboard/order.png" />
              <div>
                <h3>25</h3>
                <h5>total products</h5>
              </div>
            </div>
          </div>
          <div className="col-md-4">
            <div className="counter-box">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img alt="" className="img-fluid" src="/assets/images/icon/dashboard/sale.png" />
              <div>
                <h3>12500</h3>
                <h5>total sales</h5>
              </div>
            </div>
          </div>
          <div className="col-md-4">
            <div className="counter-box">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img alt="" className="img-fluid" src="/assets/images/icon/dashboard/homework.png" />
              <div>
                <h3>50</h3>
                <h5>order pending</h5>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="row">
        <div className="col-md-7">
          <div className="card">
            <div className="card-body">
              <ReactApexChart options={revenueOptions} series={revenueSeries} type="area" height={250} />
            </div>
          </div>
        </div>
        <div className="col-md-5">
          <div className="card">
            <div className="card-body">
              <ReactApexChart options={salesOptions} series={salesSeries} type="donut" height={250} />
            </div>
          </div>
        </div>
      </div>

      <div className="row g-sm-4 g-3 mt-1">
        <div className="col-12">
          <div className="dashboard-table">
            <div className="wallet-table">
              <div className="top-sec mb-3">
                <h3>trending products</h3>
              </div>
              <div className="table-responsive">
                <table className="table cart-table order-table">
                  <thead>
                    <tr>
                      <th>image</th>
                      <th>product name</th>
                      <th>price</th>
                      <th>sales</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td className="image-box">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img alt="" className="blur-up lazyloaded" src="/assets/images/fashion-1/product/5.jpg" />
                      </td>
                      <td>neck velvet dress</td>
                      <td>$205</td>
                      <td>1000</td>
                    </tr>
                    <tr>
                      <td className="image-box">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img alt="" className="blur-up lazyloaded" src="/assets/images/fashion-1/product/13.jpg" />
                      </td>
                      <td>belted trench coat</td>
                      <td>$350</td>
                      <td>800</td>
                    </tr>
                    <tr>
                      <td className="image-box">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img alt="" className="blur-up lazyloaded" src="/assets/images/fashion-1/product/9.jpg" />
                      </td>
                      <td>man print tee</td>
                      <td>$150</td>
                      <td>750</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
        <div className="col-12 mt-4">
          <div className="dashboard-table">
            <div className="wallet-table">
              <div className="top-sec mb-3">
                <h3>recent orders</h3>
              </div>
              <div className="table-responsive">
                <table className="table cart-table order-table">
                  <thead>
                    <tr>
                      <th>order id</th>
                      <th>product details</th>
                      <th>status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>#21515</td>
                      <td>neck velvet dress</td>
                      <td>
                        <span className="badge bg-pending custom-badge rounded-0">pending</span>
                      </td>
                    </tr>
                    <tr>
                      <td>#78153</td>
                      <td>belted trench coat</td>
                      <td>
                        <span className="badge bg-debit custom-badge rounded-0">cancelled</span>
                      </td>
                    </tr>
                    <tr>
                      <td>#51512</td>
                      <td>man print tee</td>
                      <td>
                        <span className="badge bg-credit custom-badge rounded-0">shipped</span>
                      </td>
                    </tr>
                    <tr>
                      <td>#78153</td>
                      <td>belted trench coat</td>
                      <td>
                        <span className="badge bg-pending custom-badge rounded-0">pending</span>
                      </td>
                    </tr>
                    <tr>
                      <td>#51512</td>
                      <td>man print tee</td>
                      <td>
                        <span className="badge bg-credit custom-badge rounded-0">shipped</span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
