const fs = require('fs');
const path = require('path');

const posDir = path.join(__dirname, 'apps/web/src/app/(pos)');
const posSubDir = path.join(posDir, 'pos');

fs.mkdirSync(posSubDir, { recursive: true });

// Move everything currently in (pos) into (pos)/pos, except layout.tsx (which applies to the route group) and the newly created pos dir.
const items = fs.readdirSync(posDir);

items.forEach(item => {
  if (item === 'pos' || item === 'layout.tsx') return;
  const oldPath = path.join(posDir, item);
  const newPath = path.join(posSubDir, item);
  fs.renameSync(oldPath, newPath);
});

console.log('Fixed POS routing by moving routes inside the pos path segment.');
