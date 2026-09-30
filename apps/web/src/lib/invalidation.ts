
import { QueryClient } from '@tanstack/react-query';

export const queryKeys = {
  users: ['users'],
  orders: ['orders'],
};

export function invalidateAll(queryClient: QueryClient) {
  queryClient.invalidateQueries();
}
