
export class ApiError extends Error {
  constructor(public status: number, message: string, public code?: string) {
    super(message);
    this.name = 'ApiError';
  }
}

export const API_MODE = process.env.NEXT_PUBLIC_API_MODE || 'mock';

export async function fetchApi<T>(endpoint: string, options?: RequestInit): Promise<T> {
  // Mock logic placeholder
  if (API_MODE === 'mock') {
    return {} as T;
  }
  const res = await fetch(endpoint, options);
  if (!res.ok) {
    throw new ApiError(res.status, await res.text());
  }
  return res.json();
}
