"use client";

import React, { useState } from 'react';

export interface NetworkUser {
  id: string;
  name: string;
  role: string;
  joinDate?: string;
  totalSales?: number;
  commissionsEarned?: number;
}

export interface TreeNode {
  user: NetworkUser;
  children?: TreeNode[];
}

interface NetworkTreeProps {
  data: TreeNode;
  level?: number;
  isExpandedDefault?: boolean;
}

export default function NetworkTree({ data, level = 0, isExpandedDefault = true }: NetworkTreeProps) {
  const [isExpanded, setIsExpanded] = useState(isExpandedDefault);
  const hasChildren = data.children && data.children.length > 0;

  const toggleExpand = () => {
    setIsExpanded(!isExpanded);
  };

  return (
    <div className="network-tree-node" style={{ marginLeft: level > 0 ? '20px' : '0' }}>
      <div className={`p-3 mb-2 border rounded position-relative ${level === 0 ? 'bg-primary text-white shadow-sm' : 'bg-white shadow-sm'}`} style={{ zIndex: 10 }}>
        <div className="d-flex justify-content-between align-items-center">
          <div className="d-flex align-items-center">
            <div className={`me-3 d-flex justify-content-center align-items-center rounded-circle ${level === 0 ? 'bg-white text-primary' : 'bg-light text-muted'}`} style={{ width: '40px', height: '40px' }}>
              <i className="ri-user-fill fs-5"></i>
            </div>
            <div>
              <h5 className="mb-0 text-sm fw-bold">
                {data.user.name} <span className="badge bg-secondary ms-2 text-xs">{data.user.role}</span>
              </h5>
              <span className={`text-xs ${level === 0 ? 'text-white-50' : 'text-muted'}`}>
                {level === 0 ? 'You (Root)' : `ID: ${data.user.id}`}
              </span>
            </div>
          </div>
          
          <div className="d-flex align-items-center gap-3">
            {data.user.commissionsEarned !== undefined && (
              <div className="text-end d-none d-sm-block">
                <span className={`text-xs d-block ${level === 0 ? 'text-white-50' : 'text-muted'}`}>Earned</span>
                <span className="fw-bold">₦{data.user.commissionsEarned.toLocaleString()}</span>
              </div>
            )}
            {hasChildren && (
              <button 
                onClick={toggleExpand}
                className={`btn btn-sm ${level === 0 ? 'btn-light text-primary' : 'btn-outline-primary'}`}
              >
                {isExpanded ? <i className="ri-subtract-line"></i> : <i className="ri-add-line"></i>}
              </button>
            )}
          </div>
        </div>
      </div>
      
      {hasChildren && isExpanded && (
        <div className="network-tree-children position-relative border-start border-2 ms-4 ps-4 pt-2">
          {data.children!.map((child) => (
            <div key={child.user.id} className="position-relative">
              <div 
                className="position-absolute border-bottom border-2" 
                style={{ width: '20px', left: '-24px', top: '25px', zIndex: 1 }}
              ></div>
              <NetworkTree data={child} level={level + 1} isExpandedDefault={false} />
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
