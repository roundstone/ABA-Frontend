import { useMutation, useQueryClient } from '@tanstack/react-query';
import { updatePageSection, updateSectionStatus } from './api';
import { contentKeys } from './queries';
import { PageStatus } from './types';

export const useUpdatePageSection = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ pageId, sectionId, content }: { pageId: string; sectionId: string; content: string }) => 
      updatePageSection(pageId, sectionId, { content }),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: contentKeys.page(variables.pageId) });
      queryClient.invalidateQueries({ queryKey: contentKeys.pages() });
    },
  });
};

export const useUpdateSectionStatus = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ pageId, sectionId, status }: { pageId: string; sectionId: string; status: PageStatus }) => 
      updateSectionStatus(pageId, sectionId, status),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: contentKeys.page(variables.pageId) });
      queryClient.invalidateQueries({ queryKey: contentKeys.pages() });
    },
  });
};
