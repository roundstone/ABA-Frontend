import { NetworkNodeData } from './types';

// Full flat list of all users in the network for easy lookup
export const mockNetworkUsers: Record<string, NetworkNodeData> = {
  'ABA-492': {
    id: 'ABA-492',
    name: 'Aisha Bello',
    code: 'ABA-492',
    active: true,
    sales: 450000000,
    downlineCount: 24,
    level: 0,
    children: [
      {
        id: 'ABA-881',
        name: 'Michael Okon',
        code: 'ABA-881',
        active: true,
        sales: 120500000,
        downlineCount: 8,
        level: 1,
        children: [
          {
            id: 'ABA-211',
            name: 'Sarah Jane',
            code: 'ABA-211',
            active: true,
            sales: 4500000,
            downlineCount: 1,
            level: 2,
            children: [
              {
                id: 'ABA-999',
                name: 'Peter Obi',
                code: 'ABA-999',
                active: true,
                sales: 500000,
                downlineCount: 0,
                level: 3,
              }
            ]
          },
          {
            id: 'ABA-902',
            name: 'David Mark',
            code: 'ABA-902',
            active: false,
            sales: 0,
            downlineCount: 0,
            level: 2,
          }
        ]
      },
      {
        id: 'ABA-112',
        name: 'John Doe',
        code: 'ABA-112',
        active: true,
        sales: 8900000,
        downlineCount: 3,
        level: 1,
      }
    ]
  },
  'ABA-881': {
    id: 'ABA-881',
    name: 'Michael Okon',
    code: 'ABA-881',
    active: true,
    sales: 120500000,
    downlineCount: 8,
    level: 0,
    children: [
      {
        id: 'ABA-211',
        name: 'Sarah Jane',
        code: 'ABA-211',
        active: true,
        sales: 4500000,
        downlineCount: 1,
        level: 1,
      },
      {
        id: 'ABA-902',
        name: 'David Mark',
        code: 'ABA-902',
        active: false,
        sales: 0,
        downlineCount: 0,
        level: 1,
      }
    ]
  },
  'ABA-211': {
    id: 'ABA-211',
    name: 'Sarah Jane',
    code: 'ABA-211',
    active: true,
    sales: 4500000,
    downlineCount: 1,
    level: 0,
    children: [
      {
        id: 'ABA-999',
        name: 'Peter Obi',
        code: 'ABA-999',
        active: true,
        sales: 500000,
        downlineCount: 0,
        level: 1,
      }
    ]
  },
};
