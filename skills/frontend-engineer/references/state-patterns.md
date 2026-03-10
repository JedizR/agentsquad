# Frontend Engineer — State Management Patterns Reference

## State Decision Tree

```
Is the state server data (fetched from API)?
  → YES: Use React Query (TanStack Query) or SWR
  → NO: Is it global UI state (modal open, theme, auth session)?
      → YES: Use Zustand (React) or Pinia (Vue)
      → NO: Is it local to one component?
          → YES: Use useState / useReducer
```

## React Query Pattern (server state)
```typescript
// hooks/useUsers.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/lib/api';

export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => api.get('/api/v1/users'),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}

export function useCreateUser() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: CreateUserDto) => api.post('/api/v1/users', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

## Zustand Pattern (global UI state)
```typescript
// stores/useAuthStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface AuthState {
  token: string | null;
  user: User | null;
  setAuth: (token: string, user: User) => void;
  clearAuth: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      user: null,
      setAuth: (token, user) => set({ token, user }),
      clearAuth: () => set({ token: null, user: null }),
    }),
    { name: 'auth-storage' }
  )
);
```

## Optimistic Update Pattern
```typescript
const mutation = useMutation({
  mutationFn: updateUser,
  onMutate: async (newUser) => {
    await queryClient.cancelQueries({ queryKey: ['users', newUser.id] });
    const previous = queryClient.getQueryData(['users', newUser.id]);
    queryClient.setQueryData(['users', newUser.id], newUser); // optimistic
    return { previous }; // rollback context
  },
  onError: (err, newUser, context) => {
    queryClient.setQueryData(['users', newUser.id], context?.previous); // rollback
  },
});
```
