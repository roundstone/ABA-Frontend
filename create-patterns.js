const fs = require('fs');
const path = require('path');

const dir = path.join(__dirname, 'apps/web/src/components/patterns');
if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

const components = [
  'PageHeader', 'KpiCard', 'StatCardGroup', 'FilterBar', 'FilterDrawer', 
  'ChartCard', 'Timeline', 'ActivityFeed', 'DescriptionList', 
  'EntityLink', 'EntityCard', 'LineItemsEditor', 'ApprovalPanel', 
  'StepIndicator', 'EmptyState', 'ErrorState', 'NoPermission', 
  'ConfirmProvider', 'ExportMenu', 'DataTable'
];

components.forEach(name => {
  const filePath = path.join(dir, `${name}.tsx`);
  if (!fs.existsSync(filePath)) {
    fs.writeFileSync(filePath, `import React from 'react';\n\nexport function ${name}() {\n  return <div>${name} Component</div>;\n}\n`);
  }
});

// Form kit
const formDir = path.join(__dirname, 'apps/web/src/lib/form');
if (!fs.existsSync(formDir)) fs.mkdirSync(formDir, { recursive: true });
fs.writeFileSync(path.join(formDir, 'index.ts'), `// React Hook Form + Zod integrations\nexport * from 'react-hook-form';\nexport * from '@hookform/resolvers/zod';\nexport * from 'zod';\n`);

console.log('Created pattern files.');
