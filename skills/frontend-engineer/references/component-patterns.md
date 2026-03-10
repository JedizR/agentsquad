# Frontend Engineer — Component Patterns Reference

## Component File Structure (React/TypeScript)
```typescript
// 1. Imports (external → internal → types → styles)
import { useState } from 'react';
import { Button } from '@/components/ui/Button';
import type { UserProfile } from '@/types/ui/user';

// 2. Types (props interface always named ComponentNameProps)
interface UserCardProps {
  user: UserProfile;
  onEdit?: () => void;
  className?: string;
}

// 3. Component (named export, not default)
export function UserCard({ user, onEdit, className }: UserCardProps) {
  // 4. State (grouped at top)
  const [isLoading, setIsLoading] = useState(false);

  // 5. Handlers (named handle* or on*)
  const handleEdit = () => { ... };

  // 6. Render (clear, readable JSX)
  return (
    <div className={cn('...', className)}>
      ...
    </div>
  );
}
```

## State Handling — All 4 States Required
```tsx
function UserList() {
  const { data, isLoading, error } = useUsers();

  if (isLoading) return <UserListSkeleton />; // Never use spinners alone for list content
  if (error) return <ErrorMessage error={error} />;
  if (!data?.length) return <EmptyState message="No users yet." />;

  return <div>{data.map(user => <UserCard key={user.id} user={user} />)}</div>;
}
```

## Design Tokens (always use — never hardcode)
```tsx
// BAD
<div style={{ color: '#3B82F6', padding: '16px' }}>

// GOOD (Tailwind design system tokens)
<div className="text-blue-500 p-4">

// GOOD (CSS custom properties)
<div className="text-primary p-md">
```

## Accessibility Checklist
- All `<img>` must have `alt` (empty string `""` for decorative images)
- All interactive elements must be keyboard-accessible (focusable, Enter/Space triggers)
- All form inputs must have associated `<label>` (not just placeholder)
- Use `aria-label` when visible text is absent (icon buttons)
- Color contrast: ≥ 4.5:1 for normal text, ≥ 3:1 for large text (WCAG AA)

## Loading Skeleton Pattern
```tsx
// Use skeletons for content that has known shape
function UserCardSkeleton() {
  return (
    <div className="animate-pulse">
      <div className="h-4 bg-gray-200 rounded w-3/4 mb-2" />
      <div className="h-4 bg-gray-200 rounded w-1/2" />
    </div>
  );
}
```
