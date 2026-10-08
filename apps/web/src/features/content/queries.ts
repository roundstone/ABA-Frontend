import { useQuery } from '@tanstack/react-query';
import { getPages, getPageById, getPageBySlug } from './api';

export const contentKeys = {
  all: ['content'] as const,
  pages: () => [...contentKeys.all, 'pages'] as const,
  page: (id: string) => [...contentKeys.pages(), id] as const,
  pageBySlug: (slug: string) => [...contentKeys.pages(), 'slug', slug] as const,
};

export const usePages = () => {
  return useQuery({
    queryKey: contentKeys.pages(),
    queryFn: getPages,
  });
};

export const usePage = (id: string) => {
  return useQuery({
    queryKey: contentKeys.page(id),
    queryFn: () => getPageById(id),
    enabled: !!id,
  });
};

export const usePageBySlug = (slug: string) => {
  return useQuery({
    queryKey: contentKeys.pageBySlug(slug),
    queryFn: () => getPageBySlug(slug),
    enabled: !!slug,
  });
};
