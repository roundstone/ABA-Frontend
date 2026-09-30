import { create } from 'zustand';

interface AdminUser {
  id: string;
  name: string;
  role: string;
}

interface AdminState {
  isAuthenticated: boolean;
  user: AdminUser | null;
  login: (user: AdminUser) => void;
  logout: () => void;
  isSidebarOpen: boolean;
  toggleSidebar: () => void;
  setSidebarOpen: (isOpen: boolean) => void;
  isFullScreen: boolean;
  toggleFullScreen: () => void;
}

export const useAdminStore = create<AdminState>((set) => ({
  isAuthenticated: true, // tempro
  user: null,
  login: (user) => set({ isAuthenticated: true, user }),
  logout: () => set({ isAuthenticated: false, user: null }),
  isSidebarOpen: true,
  toggleSidebar: () => set((state) => ({ isSidebarOpen: !state.isSidebarOpen })),
  setSidebarOpen: (isOpen) => set({ isSidebarOpen: isOpen }),
  isFullScreen: false,
  toggleFullScreen: () => {
    if (typeof window !== 'undefined') {
      if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen().catch((err) => {
          console.error(`Error attempting to enable fullscreen: ${err.message}`);
        });
        set({ isFullScreen: true });
      } else {
        if (document.exitFullscreen) {
          document.exitFullscreen();
          set({ isFullScreen: false });
        }
      }
    }
  },
}));
