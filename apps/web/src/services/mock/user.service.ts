export interface User {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  role: 'Customer' | 'Admin';
  lastLogin: string;
  avatar: string;
}

// Mock Data
let mockUsers: User[] = [
  {
    id: 'usr_1',
    firstName: 'Rowan',
    lastName: 'Torres',
    email: 'Rowan.torres@gmail.com',
    role: 'Customer',
    lastLogin: '6 Days ago',
    avatar: '/images/dashboard/user.jpg'
  },
  {
    id: 'usr_2',
    firstName: 'Alonzo',
    lastName: 'Perez',
    email: 'Perez.Alonzo@gmail.com',
    role: 'Customer',
    lastLogin: '2 Days ago',
    avatar: '/images/dashboard/user1.jpg'
  },
  {
    id: 'usr_3',
    firstName: 'Skylar',
    lastName: 'Lane',
    email: 'Lane.Skylar@gmail.com',
    role: 'Customer',
    lastLogin: '1 Days ago',
    avatar: '/images/dashboard/user2.jpg'
  },
  {
    id: 'usr_4',
    firstName: 'Brody',
    lastName: 'Gray',
    email: 'Gray.Brody@gmail.com',
    role: 'Admin',
    lastLogin: '3 Days ago',
    avatar: '/images/dashboard/user3.jpg'
  }
];

export const UserService = {
  getUsers: (): User[] => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('aba_mock_users');
      if (stored) return JSON.parse(stored);
      localStorage.setItem('aba_mock_users', JSON.stringify(mockUsers));
    }
    return mockUsers;
  },

  createUser: (userData: Omit<User, 'id' | 'lastLogin' | 'avatar'>): User => {
    const newUser: User = {
      ...userData,
      id: `usr_${Math.random().toString(36).substr(2, 9)}`,
      lastLogin: 'Just now',
      avatar: '/images/dashboard/user.jpg' // Default avatar
    };

    const users = UserService.getUsers();
    const updatedUsers = [newUser, ...users];
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_users', JSON.stringify(updatedUsers));
    }
    mockUsers = updatedUsers;
    
    return newUser;
  },

  deleteUser: (userId: string): void => {
    const users = UserService.getUsers();
    const updatedUsers = users.filter(u => u.id !== userId);
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_users', JSON.stringify(updatedUsers));
    }
    mockUsers = updatedUsers;
  }
};
