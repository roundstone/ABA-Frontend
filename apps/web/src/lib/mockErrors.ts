import { ApiError } from '@/lib/api';

/**
 * Mock-mode error injection (Doc 01 §16 / build rules §4).
 * Enable from the browser console:  localStorage.setItem('mock_inject_error', 'directory')
 * Keys are comma separated. Clear with localStorage.removeItem('mock_inject_error').
 * Holds no secrets or tokens.
 */
export function maybeInjectMockError(key: string): void {
  if (typeof window === 'undefined') return;
  const keys = (window.localStorage.getItem('mock_inject_error') ?? '').split(',').map(k => k.trim());
  if (keys.includes(key) || keys.includes('all')) {
    throw new ApiError(500, 'Injected mock error', 'INJECTED_ERROR');
  }
}
