'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';
import dynamic from 'next/dynamic';

const ReactApexChart = dynamic(() => import('react-apexcharts'), { ssr: false });

interface Transfer {
  id: string;
  name: string;
  date: string;
  total: number;
}

export default function AdminReports() {
  const [mounted, setMounted] = useState(false);
  const [transfers, setTransfers] = useState<Transfer[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [satisfaction, setSatisfaction] = useState(0);

  useEffect(() => {
    setMounted(true);
    
    // Simulate API call for reports data
    const fetchReportsData = async () => {
      setLoading(true);
      // Simulate network delay
      await new Promise(resolve => setTimeout(resolve, 800));
      
      setSatisfaction(75);
      setTransfers([
        { id: '14783112', name: 'Gray Brody', date: 'Nov 20, 2024', total: 745 },
        { id: '87541221', name: 'Perez Alonzo', date: 'Dec 25, 2024', total: 8136 },
        { id: '213514462', name: 'Woters Maxine', date: 'Feb 04, 2025', total: 564 },
        { id: '7512785568', name: 'Rowan Torres', date: 'Jan 07, 2025', total: 2364 }
      ]);
      setLoading(false);
    };

    fetchReportsData();
  }, []);

  if (!mounted) return null;

  const filteredTransfers = transfers.filter(
    (t) =>
      t.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      t.id.includes(searchQuery)
  );

  // Sales Summary Chart Config
  const salesChartOptions: ApexCharts.ApexOptions = {
    chart: { type: 'area', height: 300, toolbar: { show: false } },
    dataLabels: { enabled: false },
    stroke: { curve: 'smooth', width: 2 },
    xaxis: { 
      categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
      axisBorder: { show: false },
      axisTicks: { show: false },
    },
    colors: ['#ffbc58'],
    fill: { 
      type: 'gradient', 
      gradient: { shadeIntensity: 1, opacityFrom: 0.4, opacityTo: 0.05, stops: [50, 100] } 
    }
  };
  const salesChartSeries = [{ name: 'Sales', data: [15, 30, 22, 45, 30, 60, 45, 75, 60, 90, 75, 110] }];

  // Satisfaction Chart Config
  const satisfactionChartOptions: ApexCharts.ApexOptions = {
    chart: { type: 'radialBar', height: 245 },
    plotOptions: {
      radialBar: {
        hollow: { size: '60%' },
        dataLabels: {
          name: { show: false },
          value: { 
            fontSize: '24px', 
            fontWeight: 'bold', 
            color: '#2b2b2b',
            formatter: (val) => `${val}%` 
          }
        }
      }
    },
    colors: ['#13c9ca'],
    stroke: { lineCap: 'round' }
  };
  
  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Reports
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
                <li className="breadcrumb-item active">Reports</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-xl-8 col-md-6">
            <div className="card bg-white">
              <div className="card-header">
                <h5>Sales Summary</h5>
              </div>
              <div className="card-body sell-graph">
                {loading ? (
                  <div style={{ height: '300px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <p className="text-muted">Loading chart data...</p>
                  </div>
                ) : (
                  <ReactApexChart options={salesChartOptions} series={salesChartSeries} type="area" height={300} />
                )}
              </div>
            </div>
          </div>
          <div className="col-xl-4 col-md-6">
            <div className="card report-employee bg-white">
              <div className="card-header">
                <h2>{satisfaction}%</h2>
                <h6 className="mb-0">Employees Satisfied</h6>
              </div>
              <div className="card-body p-0">
                {loading ? (
                  <div style={{ height: '245px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <p className="text-muted">Loading...</p>
                  </div>
                ) : (
                  <ReactApexChart options={satisfactionChartOptions} series={[satisfaction]} type="radialBar" height={245} />
                )}
              </div>
            </div>
          </div>
          <div className="col-sm-12">
            <div className="card">
              <div className="card-header">
                <h5>Transfer Report</h5>
                <form className="form-inline search-form search-box">
                  <div className="form-group">
                    <input 
                      className="form-control-plaintext" 
                      type="search" 
                      placeholder="Search transfers..." 
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                    />
                  </div>
                </form>
              </div>

              <div className="card-body">
                <div className="table-responsive table-desi">
                  <table className="table report-table all-package table-category">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th>Transfer Id</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Option</th>
                      </tr>
                    </thead>

                    <tbody>
                      {loading ? (
                        <tr>
                          <td colSpan={5} className="text-center py-4">Loading transfers...</td>
                        </tr>
                      ) : filteredTransfers.length === 0 ? (
                        <tr>
                          <td colSpan={5} className="text-center py-4">No transfers found.</td>
                        </tr>
                      ) : (
                        filteredTransfers.map((transfer) => (
                          <tr key={transfer.id}>
                            <td>{transfer.name}</td>
                            <td>{transfer.id}</td>
                            <td>{transfer.date}</td>
                            <td>${transfer.total.toLocaleString()}</td>
                            <td>
                              <a href="#!" onClick={(e) => e.preventDefault()}>
                                <i className="fa fa-edit me-2" title="Edit"></i>
                              </a>
                              <a href="#!" onClick={(e) => e.preventDefault()}>
                                <i className="fa fa-trash font-danger" title="Delete"></i>
                              </a>
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
