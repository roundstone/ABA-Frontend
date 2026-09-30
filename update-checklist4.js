const fs = require('fs');
const path = '/Users/macbookpro/Documents/Web/aba_project/docs/checklist/01.md';
let content = fs.readFileSync(path, 'utf8');

for (let i = 584; i <= 629; i++) {
  const req = 'REQ-01-' + String(i).padStart(3, '0');
  content = content.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(path, content);
console.log('Updated checklist');
