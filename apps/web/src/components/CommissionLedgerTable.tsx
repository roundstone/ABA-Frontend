"use client";

import React, { useState, useMemo } from 'react';
import { CommissionLedgerEntry } from '@/services/mock/commission.service';

interface Props {
  entries: CommissionLedgerEntry[];
  showRecipient?: boolean;
  isAdmin?: boolean;
  onApprove?: (ids: string[]) => void;
  onReject?: (ids: string[]) => void;
}

const ITEMS_PER_PAGE = 10;

export default function CommissionLedgerTable({ entries, showRecipient = true, isAdmin = false, onApprove, onReject }: Props) {
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [statusFilter, setStatusFilter] = useState<string>('ALL');
  const [currentPage, setCurrentPage] = useState<number>(1);

  // Filter and sort entries
  const filteredEntries = useMemo(() => {
    let result = entries;
    if (statusFilter !== 'ALL') {
      result = result.filter(e => e.status === statusFilter);
    }
    // Sort by date descending
    return result.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  }, [entries, statusFilter]);

  // Pagination
  const totalPages = Math.ceil(filteredEntries.length / ITEMS_PER_PAGE);
  const paginatedEntries = filteredEntries.slice((currentPage - 1) * ITEMS_PER_PAGE, currentPage * ITEMS_PER_PAGE);

  const toggleSelectAll = () => {
    if (selectedIds.size === paginatedEntries.length && paginatedEntries.length > 0) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(paginatedEntries.map(e => e.id)));
    }
  };

  const toggleSelect = (id: string) => {
    const newSelected = new Set(selectedIds);
    if (newSelected.has(id)) {
      newSelected.delete(id);
    } else {
      newSelected.add(id);
    }
    setSelectedIds(newSelected);
  };

  const handleApprove = () => {
    if (onApprove && selectedIds.size > 0) {
      onApprove(Array.from(selectedIds));
      setSelectedIds(new Set());
    }
  };

  const handleReject = () => {
    if (onReject && selectedIds.size > 0) {
      onReject(Array.from(selectedIds));
      setSelectedIds(new Set());
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'PENDING': return <span className="badge bg-warning text-dark">Pending</span>;
      case 'APPROVED': return <span className="badge bg-info text-dark">Approved</span>;
      case 'PAID': return <span className="badge bg-success">Paid</span>;
      case 'REVERSED': return <span className="badge bg-danger">Reversed</span>;
      default: return <span className="badge bg-secondary">{status}</span>;
    }
  };

  return (
    <div>
      <div className="d-flex justify-content-between align-items-center mb-3">
        <div className="d-flex align-items-center gap-2">
          <label className="fw-bold mb-0">Status:</label>
          <select 
            className="form-select form-select-sm w-auto" 
            value={statusFilter} 
            onChange={(e) => {
              setStatusFilter(e.target.value);
              setCurrentPage(1);
              setSelectedIds(new Set());
            }}
          >
            <option value="ALL">All</option>
            <option value="PENDING">Pending</option>
            <option value="APPROVED">Approved</option>
            <option value="PAID">Paid</option>
            <option value="REVERSED">Reversed</option>
          </select>
        </div>

        {isAdmin && selectedIds.size > 0 && (
          <div className="d-flex gap-2">
            <button className="btn btn-sm btn-success" onClick={handleApprove}>
              <i className="ri-check-line me-1"></i> Approve Selected ({selectedIds.size})
            </button>
            <button className="btn btn-sm btn-danger" onClick={handleReject}>
              <i className="ri-close-line me-1"></i> Reject
            </button>
          </div>
        )}
      </div>

      {filteredEntries.length === 0 ? (
        <div className="text-center p-4 bg-light rounded text-muted border">No commission records found matching the filter.</div>
      ) : (
        <>
          <div className="table-responsive">
            <table className="table table-striped table-bordered text-sm align-middle mb-0">
              <thead className="bg-light">
                <tr>
                  {isAdmin && (
                    <th className="text-center" style={{ width: '40px' }}>
                      <input 
                        type="checkbox" 
                        className="form-check-input cursor-pointer" 
                        checked={paginatedEntries.length > 0 && selectedIds.size === paginatedEntries.length}
                        onChange={toggleSelectAll}
                      />
                    </th>
                  )}
                  <th>Date</th>
                  <th>Order ID</th>
                  {showRecipient && <th>Recipient</th>}
                  <th>Purchaser</th>
                  <th>Level</th>
                  <th className="text-end">Amount (NGN)</th>
                  <th className="text-center">Status</th>
                </tr>
              </thead>
              <tbody>
                {paginatedEntries.map((entry) => (
                  <tr key={entry.id}>
                    {isAdmin && (
                      <td className="text-center">
                        <input 
                          type="checkbox" 
                          className="form-check-input cursor-pointer"
                          checked={selectedIds.has(entry.id)}
                          onChange={() => toggleSelect(entry.id)}
                        />
                      </td>
                    )}
                    <td>{new Date(entry.createdAt).toLocaleDateString()}</td>
                    <td><code className="bg-light px-2 py-1 rounded text-dark">{entry.orderId}</code></td>
                    {showRecipient && <td className="fw-bold">{entry.recipientId}</td>}
                    <td>{entry.purchaserId}</td>
                    <td><span className="badge bg-light text-dark border">Level {entry.level}</span></td>
                    <td className="fw-bold text-success text-end">
                      ₦{entry.amount.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                    </td>
                    <td className="text-center">{getStatusBadge(entry.status)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {totalPages > 1 && (
            <div className="d-flex justify-content-between align-items-center mt-3">
              <span className="text-muted text-sm">
                Showing {(currentPage - 1) * ITEMS_PER_PAGE + 1} to {Math.min(currentPage * ITEMS_PER_PAGE, filteredEntries.length)} of {filteredEntries.length} entries
              </span>
              <ul className="pagination pagination-sm mb-0">
                <li className={`page-item ${currentPage === 1 ? 'disabled' : ''}`}>
                  <button className="page-link" onClick={() => setCurrentPage(p => Math.max(1, p - 1))}>Previous</button>
                </li>
                {Array.from({ length: totalPages }, (_, i) => i + 1).map(page => (
                  <li key={page} className={`page-item ${currentPage === page ? 'active' : ''}`}>
                    <button className="page-link" onClick={() => setCurrentPage(page)}>{page}</button>
                  </li>
                ))}
                <li className={`page-item ${currentPage === totalPages ? 'disabled' : ''}`}>
                  <button className="page-link" onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}>Next</button>
                </li>
              </ul>
            </div>
          )}
        </>
      )}
    </div>
  );
}
