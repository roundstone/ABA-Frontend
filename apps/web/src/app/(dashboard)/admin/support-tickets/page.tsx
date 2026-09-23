'use client';

import { TicketService, Ticket } from '@/services/mock/ticket.service';
import Link from 'next/link';
import { useEffect, useState } from 'react';

export default function AdminSupportTickets() {
  const [tickets, setTickets] = useState<Ticket[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    setTickets(TicketService.getTickets());
  }, []);

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this ticket?')) {
      TicketService.deleteTicket(id);
      setTickets(TicketService.getTickets());
    }
  };

  if (!mounted) return null;

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Support Tickets
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
                <li className="breadcrumb-item">Support</li>
                <li className="breadcrumb-item active">Support Tickets</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-sm-12">
            <div className="card">
              <div className="card-header">
                <form className="form-inline search-form search-box">
                  <div className="form-group">
                    <input className="form-control-plaintext" type="search" placeholder="Search.." />
                  </div>
                </form>
              </div>

              <div className="card-body">
                <div className="table-responsive table-desi">
                  <table className="table support-ticket-table all-package">
                    <thead>
                      <tr>
                        <th>Ticket Number</th>
                        <th>Date</th>
                        <th>Subject</th>
                        <th>Status</th>
                        <th>Option</th>
                      </tr>
                    </thead>

                    <tbody>
                      {tickets.map((ticket) => (
                        <tr key={ticket.id}>
                          <td>{ticket.id}</td>
                          <td>{ticket.date}</td>
                          <td>{ticket.subject}</td>
                          <td className={ticket.status === 'Resolved' ? 'order-success' : 'order-warning'}>
                            <span>{ticket.status}</span>
                          </td>
                          <td>
                            <a href="#!" onClick={(e) => e.preventDefault()}>
                              <i className="fa fa-edit me-2" title="Edit"></i>
                            </a>
                            <a href="#!" onClick={(e) => { e.preventDefault(); handleDelete(ticket.id); }}>
                              <i className="fa fa-trash font-danger" title="Delete"></i>
                            </a>
                          </td>
                        </tr>
                      ))}
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
