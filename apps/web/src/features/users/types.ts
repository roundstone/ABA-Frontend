export interface Permission {
  id: string;
  key: string;
  name: string;
  description: string;
  module: string;
}

export interface Role {
  id: string;
  name: string;
  description: string;
  isSystem: boolean;
  usersCount: number;
  permissions: string[];
  updatedAt: string;
}
