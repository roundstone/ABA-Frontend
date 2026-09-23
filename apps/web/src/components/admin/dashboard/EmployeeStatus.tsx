'use client';

import React, { useEffect, useState } from 'react';
import Image from 'next/image';

interface Employee {
  id: string;
  name: string;
  designation: string;
  skillLevel: number;
  experience: string;
  status: string;
  avatar: string;
}

export default function EmployeeStatus() {
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Simulate API fetch
    const fetchEmployees = async () => {
      setIsLoading(true);
      await new Promise(resolve => setTimeout(resolve, 600));
      setEmployees([
        { id: '1', name: 'John Deo', designation: 'Designer', skillLevel: 30, experience: '2 Year', status: '14+ Online', avatar: '/admin-assets/images/dashboard/user2.jpg' },
        { id: '2', name: 'Holio Mako', designation: 'Developer', skillLevel: 70, experience: '3 Year', status: '250+ Online', avatar: '/admin-assets/images/dashboard/user1.jpg' },
        { id: '3', name: 'Mohsib lara', designation: 'Tester', skillLevel: 60, experience: '5 Month', status: '99+ Online', avatar: '/admin-assets/images/dashboard/user3.jpg' },
        { id: '4', name: 'Hileri Soli', designation: 'Designer', skillLevel: 30, experience: '3 Month', status: '150+ Online', avatar: '/admin-assets/images/dashboard/user.jpg' },
        { id: '5', name: 'Pusiz bia', designation: 'Designer', skillLevel: 90, experience: '5 Year', status: '14+ Online', avatar: '/admin-assets/images/dashboard/designer.jpg' },
      ]);
      setIsLoading(false);
    };
    fetchEmployees();
  }, []);

  return (
    <div className="col-xl-6 xl-100">
      <div className="card height-equal">
        <div className="card-header">
          <h5>Employee Status</h5>
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
          {isLoading ? (
            <div className="d-flex justify-content-center align-items-center" style={{ minHeight: '300px' }}>
              <span className="text-muted">Loading employee data...</span>
            </div>
          ) : (
            <div className="user-status table-responsive products-table">
              <table className="table table-bordernone mb-0">
                <thead>
                  <tr>
                    <th scope="col">Name</th>
                    <th scope="col">Designation</th>
                    <th scope="col">Skill Level</th>
                    <th scope="col">Experience</th>
                  </tr>
                </thead>
                <tbody>
                  {employees.map((emp, index) => (
                    <tr key={emp.id}>
                      <td className="bd-t-none u-s-tb">
                        <div className="align-middle image-sm-size">
                          <Image width={40} height={40} className="img-radius align-top m-r-15 rounded-circle" src={emp.avatar} alt={emp.name} />
                          <div className="d-inline-block">
                            <h6 className="mb-0">{emp.name} <span className="text-muted digits">({emp.status})</span></h6>
                          </div>
                        </div>
                      </td>
                      <td>{emp.designation}</td>
                      <td>
                        <div className="progress-showcase">
                          <div className="progress" style={{ height: '8px' }}>
                            <div 
                              className={`progress-bar ${index % 2 === 0 ? 'bg-primary' : 'bg-secondary'}`} 
                              role="progressbar" 
                              style={{ width: `${emp.skillLevel}%` }} 
                              aria-valuenow={emp.skillLevel} 
                              aria-valuemin={0} 
                              aria-valuemax={100}
                            ></div>
                          </div>
                        </div>
                      </td>
                      <td className="digits">{emp.experience}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
