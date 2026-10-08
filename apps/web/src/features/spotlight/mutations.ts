import { useMutation, useQueryClient } from '@tanstack/react-query';
import { updateSpotlightSettings, runSpotlightRefresh } from './api';
import { spotlightKeys } from './queries';
import { toast } from 'sonner';

export function useUpdateSpotlightSettings() {
  const queryClient = useQueryClient();


  return useMutation({
    mutationFn: updateSpotlightSettings,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: spotlightKeys.all });
      toast.success('Settings updated', {
        description: 'Spotlight configuration has been saved.',
      });
    },
    onError: (err: Error) => {
      toast.error('Update failed', {
        description: err.message || 'Failed to update settings.',
      });
    },
  });
}

export function useRunSpotlightRefresh() {
  const queryClient = useQueryClient();


  return useMutation({
    mutationFn: runSpotlightRefresh,
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: spotlightKeys.all });
      toast.success('Refresh Complete', {
        description: `Successfully regenerated ${res.data.generatedSlots} slots.`,
      });
    },
    onError: (err: Error) => {
      toast.error('Refresh failed', {
        description: err.message || 'Failed to refresh spotlight.',
      });
    },
  });
}
