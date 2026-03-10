# QA Engineer — Testing Strategy Reference

## Test Priority Order (highest ROI first)
1. **Integration tests** for API endpoints — most bugs live at the boundary
2. **Unit tests** for business logic services — pure functions are easy to test
3. **Component tests** for UI components with complex logic
4. **E2E tests** for critical user flows only (login, checkout, core feature)
5. **Unit tests** for utilities and helpers — low value, but fast to write

## What to Test (and what NOT to)

### Test these:
- Happy path (valid input → expected output)
- Validation rejection (missing field → 400 error with correct error code)
- Auth boundaries (unauthenticated → 401, unauthorized role → 403)
- Edge cases (empty list, single item, max items, special characters in input)
- Error paths (DB down → graceful 500, not uncaught exception)

### Do NOT test:
- Framework internals (does Express route correctly? Yes — don't test it)
- Third-party library behavior (does bcrypt hash? Yes — don't test it)
- TypeScript types (that's the compiler's job)
- Private implementation details (test behavior, not implementation)

## Test File Naming
```
Unit:        src/services/__tests__/auth.service.test.ts
Integration: tests/integration/auth.api.test.ts
Component:   src/components/__tests__/LoginForm.test.tsx
E2E:         tests/e2e/auth.spec.ts
```

## Describe/It Pattern
```typescript
describe('AuthService', () => {
  describe('login()', () => {
    it('should return JWT when credentials are valid', async () => { ... });
    it('should throw INVALID_CREDENTIALS when password is wrong', async () => { ... });
    it('should throw INVALID_CREDENTIALS when email does not exist', async () => { ... });
    it('should throw ACCOUNT_DISABLED when user is suspended', async () => { ... });
  });
});
```

## Mocking Missing Endpoints (MSW)
```typescript
// When Backend hasn't implemented an endpoint yet:
import { rest } from 'msw';
import { setupServer } from 'msw/node';

// [MOCKED]: /api/v1/users — Backend to implement in Phase 2
const server = setupServer(
  rest.get('/api/v1/users', (req, res, ctx) => {
    return res(ctx.json({ data: mockUsers, pagination: { page: 1, total: 2 } }));
  })
);
```
