const fs = require('fs');
const file = 'docs/PROGRESS.md';
let content = fs.readFileSync(file, 'utf8');
content = content.replace(/\| Foundation \| 0 \| 988 \| \d+ \|/, '| Foundation | 0 | 988 | 470 |');
fs.writeFileSync(file, content);
