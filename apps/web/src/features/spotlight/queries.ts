import { useQuery } from '@tanstack/react-query';
import { getSpotlightSettings, getSpotlightHistory, getStorefrontSpotlight, getCategorySpotlight } from './api';

export const spotlightKeys = {
  all: ['spotlight'] as const,
  settings: () => [...spotlightKeys.all, 'settings'] as const,
  history: () => [...spotlightKeys.all, 'history'] as const,
  storefront: () => [...spotlightKeys.all, 'storefront'] as const,
  category: (slug: string) => [...spotlightKeys.all, 'category', slug] as const,
};

export function useSpotlightSettings() {
  return useQuery({
    queryKey: spotlightKeys.settings(),
    queryFn: async () => (await getSpotlightSettings()).data,
  });
}

export function useSpotlightHistory() {
  return useQuery({
    queryKey: spotlightKeys.history(),
    queryFn: async () => (await getSpotlightHistory()).data,
  });
}

export function useStorefrontSpotlight() {
  return useQuery({
    queryKey: spotlightKeys.storefront(),
    queryFn: async () => (await getStorefrontSpotlight()).data,
  });
}

export function useCategorySpotlight(slug: string, enabled = true) {
  return useQuery({
    queryKey: spotlightKeys.category(slug),
    queryFn: async () => (await getCategorySpotlight(slug)).data,
    enabled,
  });
}
