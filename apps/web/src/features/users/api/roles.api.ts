import { Role, Permission } from '../types';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_PERMISSIONS: Permission[] = [
  { id: 'p1', key: 'users.view', name: 'View Users', description: 'Can view the users directory', module: 'Users' },
  { id: 'p2', key: 'users.manage', name: 'Manage Users', description: 'Can create and edit users', module: 'Users' },
  { id: 'p3', key: 'roles.view', name: 'View Roles', description: 'Can view roles and permissions', module: 'Settings' },
  { id: 'p4', key: 'roles.manage', name: 'Manage Roles', description: 'Can create and edit roles', module: 'Settings' },
  { id: 'p5', key: 'inventory.view', name: 'View Inventory', description: 'Can view inventory items', module: 'Inventory' },
  { id: 'p6', key: 'inventory.manage', name: 'Manage Inventory', description: 'Can adjust stock levels', module: 'Inventory' },
];

const MOCK_ROLES: Role[] = [
  { id: 'rol-1', name: 'Super Admin', description: 'Full system access', isSystem: true, usersCount: 2, permissions: MOCK_PERMISSIONS.map(p => p.key), updatedAt: '2026-09-01T10:00:00Z' },
  { id: 'rol-2', name: 'Inventory Manager', description: 'Can manage warehouse stock', isSystem: false, usersCount: 5, permissions: ['inventory.view', 'inventory.manage'], updatedAt: '2026-09-15T10:00:00Z' },
];

export const getRoles = async (): Promise<Role[]> => {
  await delay(600);
  return MOCK_ROLES;
};

export const getRoleById = async (id: string): Promise<Role> => {
  await delay(500);
  const role = MOCK_ROLES.find(r => r.id === id);
  if (!role) throw new Error('Role not found');
  return role;
};

export const getPermissionsList = async (): Promise<Permission[]> => {
  await delay(400);
  return MOCK_PERMISSIONS;
};

export const updateRolePermissions = async (id: string, permissions: string[]): Promise<void> => {
  await delay(800);
  const role = MOCK_ROLES.find(r => r.id === id);
  if (role && role.isSystem) {
    throw new Error('System roles cannot be modified');
  }
};
