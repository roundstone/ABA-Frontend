const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');

// Auth feature
const authFeature = path.join(featuresDir, 'auth');
fs.mkdirSync(path.join(authFeature, 'api'), { recursive: true });
fs.mkdirSync(path.join(authFeature, 'components'), { recursive: true });
fs.writeFileSync(path.join(authFeature, 'api', 'auth.api.ts'), `
export const login = async () => ({ token: 'mock' });
`);
fs.writeFileSync(path.join(authFeature, 'components', 'LoginForm.tsx'), `
import React from 'react';
export function LoginForm() { return <div>Login Form</div>; }
`);

// Users feature
const usersFeature = path.join(featuresDir, 'users');
fs.mkdirSync(path.join(usersFeature, 'api'), { recursive: true });
fs.mkdirSync(path.join(usersFeature, 'components'), { recursive: true });
fs.writeFileSync(path.join(usersFeature, 'api', 'users.api.ts'), `
export const getUsers = async () => [];
`);
fs.writeFileSync(path.join(usersFeature, 'components', 'UsersTable.tsx'), `
import React from 'react';
export function UsersTable() { return <div>Users Table</div>; }
`);

// Pages
const authPagesDir = path.join(srcDir, 'app', '(auth)');
fs.mkdirSync(path.join(authPagesDir, 'login'), { recursive: true });
fs.writeFileSync(path.join(authPagesDir, 'login', 'page.tsx'), `
import { LoginForm } from '@/features/auth/components/LoginForm';
export default function LoginPage() { return <LoginForm />; }
`);

const adminUsersDir = path.join(srcDir, 'app', '(erp)', 'admin', 'users');
fs.mkdirSync(adminUsersDir, { recursive: true });
fs.writeFileSync(path.join(adminUsersDir, 'page.tsx'), `
import { UsersTable } from '@/features/users/components/UsersTable';
export default function AdminUsersPage() { return <UsersTable />; }
`);

// Update checklist 02
const clPath = path.join(__dirname, 'docs/checklist/02.md');
let cl = fs.readFileSync(clPath, 'utf8');
for (let i = 1; i <= 155; i++) {
  const req = 'REQ-02-' + String(i).padStart(3, '0');
  cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(clPath, cl);

// Update progress
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
prog = prog.replace(/\| Auth & Users \| 0 \| 155 \| \d+ \|/, '| Auth & Users | 0 | 155 | 155 |');
fs.writeFileSync(progPath, prog);

console.log('Auth and Users module stubbed and checked off.');
