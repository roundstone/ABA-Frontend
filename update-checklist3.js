const fs = require('fs');
const path = '/Users/macbookpro/Documents/Web/aba_project/docs/checklist/01.md';
let content = fs.readFileSync(path, 'utf8');

const ranges = [
  [124, 221],
  [510, 531]
];

for (const [start, end] of ranges) {
  for (let i = start; i <= end; i++) {
    const req = 'REQ-01-' + String(i).padStart(3, '0');
    content = content.replace('- [ ] ' + req, '- [x] ' + req);
  }
}
fs.writeFileSync(path, content);
console.log('Updated checklist');
