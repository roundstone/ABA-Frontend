'use client';

import Link from 'next/link';
import { Settings, Plus, GripVertical, Trash2 } from 'lucide-react';
import { useState, useRef } from 'react';

type Stage = {
  id: string;
  key: string;
  name: string;
  desc: string;
};

export default function ProductionSettings() {
  const [stages, setStages] = useState<Stage[]>([
    { id: 'MATERIAL_ALLOCATED', key: 'MATERIAL_ALLOCATED', name: 'Material Allocated', desc: 'Raw materials gathered' },
    { id: 'IN_PROGRESS', key: 'IN_PROGRESS', name: 'In Progress', desc: 'Manufacturing active' },
    { id: 'QUALITY_CHECK', key: 'QUALITY_CHECK', name: 'Quality Check', desc: 'Awaiting QC sign-off' },
    { id: 'PACKAGING', key: 'PACKAGING', name: 'Packaging', desc: 'Boxing and labeling' },
  ]);

  const dragItem = useRef<number | null>(null);
  const dragOverItem = useRef<number | null>(null);

  const handleDragStart = (e: React.DragEvent<HTMLTableRowElement>, position: number) => {
    dragItem.current = position;
  };

  const handleDragEnter = (e: React.DragEvent<HTMLTableRowElement>, position: number) => {
    dragOverItem.current = position;
  };

  const handleDragEnd = () => {
    if (dragItem.current !== null && dragOverItem.current !== null) {
      const copyStages = [...stages];
      const dragItemContent = copyStages[dragItem.current];
      copyStages.splice(dragItem.current, 1);
      copyStages.splice(dragOverItem.current, 0, dragItemContent);
      dragItem.current = null;
      dragOverItem.current = null;
      setStages(copyStages);
    }
  };

  const handleAddStage = () => {
    const newId = `STAGE_${Date.now()}`;
    setStages([...stages, { id: newId, key: 'NEW_STAGE', name: 'New Stage', desc: 'Description' }]);
  };

  const handleDeleteStage = (id: string) => {
    setStages(stages.filter(stage => stage.id !== id));
  };

  const handleChange = (id: string, field: keyof Stage, value: string) => {
    setStages(stages.map(stage => stage.id === id ? { ...stage, [field]: value } : stage));
  };

  const handleSave = () => {
    console.log('Saving stages to API:', stages);
    alert('Configuration saved successfully!');
  };

  return (
    <>
      <div className="container-fluid">
        <div className="page-header">
          <div className="row">
            <div className="col-lg-6">
              <div className="page-header-left">
                <h3>Production Settings
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
                <li className="breadcrumb-item">Production</li>
                <li className="breadcrumb-item active">Settings</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid">
        <div className="row">
          <div className="col-sm-12">
            <div className="card tab2-card">
              <div className="card-header">
                <h5>Configure Production Workflow</h5>
              </div>
              <div className="card-body">
                <ul className="nav nav-tabs tab-coupon" id="myTab" role="tablist">
                  <li className="nav-item">
                    <a className="nav-link active show" id="stages-tab" data-bs-toggle="tab" href="#stages" role="tab" aria-controls="stages" aria-selected="true">
                      <Settings className="me-2" size={18} />WIP Stages Configuration
                    </a>
                  </li>
                </ul>
                <div className="tab-content" id="myTabContent">
                  <div className="tab-pane fade active show" id="stages" role="tabpanel" aria-labelledby="stages-tab">
                    <p className="text-muted mb-4">Drag and drop to reorder stages. These stages will appear on the WIP tracking board.</p>

                    <div className="table-responsive">
                      <table className="table table-borderless">
                        <thead>
                          <tr>
                            <th style={{ width: '50px' }}></th>
                            <th>Stage Key</th>
                            <th>Display Name</th>
                            <th>Description</th>
                            <th className="text-end">Action</th>
                          </tr>
                        </thead>
                        <tbody>
                          {stages.map((stage, index) => (
                            <tr
                              key={stage.id}
                              className="bg-light mb-2"
                              draggable
                              onDragStart={(e) => handleDragStart(e, index)}
                              onDragEnter={(e) => handleDragEnter(e, index)}
                              onDragEnd={handleDragEnd}
                              onDragOver={(e) => e.preventDefault()}
                              style={{ cursor: 'grab' }}
                            >
                              <td className="align-middle text-muted cursor-pointer">
                                <GripVertical size={18} />
                              </td>
                              <td className="align-middle">
                                <input
                                  type="text"
                                  className="form-control form-control-sm text-uppercase font-monospace"
                                  value={stage.key}
                                  onChange={(e) => handleChange(stage.id, 'key', e.target.value.toUpperCase().replace(/\s+/g, '_'))}
                                />
                              </td>
                              <td className="align-middle">
                                <input
                                  type="text"
                                  className="form-control form-control-sm"
                                  value={stage.name}
                                  onChange={(e) => handleChange(stage.id, 'name', e.target.value)}
                                />
                              </td>
                              <td className="align-middle">
                                <input
                                  type="text"
                                  className="form-control form-control-sm"
                                  value={stage.desc}
                                  onChange={(e) => handleChange(stage.id, 'desc', e.target.value)}
                                />
                              </td>
                              <td className="text-end align-middle">
                                <button
                                  className="btn btn-sm btn-outline-danger"
                                  onClick={() => handleDeleteStage(stage.id)}
                                >
                                  <Trash2 size={16} />
                                </button>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>

                    <button
                      className="btn btn-outline-primary d-flex align-items-center mt-3 gap-2"
                      onClick={handleAddStage}
                    >
                      <Plus size={18} /> Add Custom Stage
                    </button>

                    <div className="mt-4 pt-3 border-top text-end">
                      <button className="btn btn-primary" onClick={handleSave}>
                        Save Configuration
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
