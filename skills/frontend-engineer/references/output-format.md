# Frontend Engineer — Output Format Reference

## Full Example Output

```
FILES MODIFIED:
- src/components/LoginForm.tsx (created)
- src/hooks/useAuth.ts (created)
- src/stores/useAuthStore.ts (created)

SUMMARY:
Implemented a login form with email/password fields, client-side zod validation,
and React Query mutation for the POST /api/v1/auth/login endpoint. The JWT token
is stored in Zustand (persisted to localStorage) — token storage escalation raised.

STATES HANDLED: loading ✓ | error ✓ | empty ✓ | success ✓

LOADING PATTERN USED: Spinner on submit button (disabled during request)

IMPORTS REQUIRED:
- src/types/api/auth.ts → AuthResponse (must exist — Backend creates this)
- src/lib/api.ts → api client (must exist with base URL configured)

🎨 DESIGN DECISIONS:
[DESIGN DECISION]: Used blue primary button (#3B82F6) for CTA. Change colorScheme
in src/styles/tokens.css if the design system uses a different primary color.
[DESIGN DECISION]: Error messages appear below the field (not toast) for better a11y.

⚠️ ESCALATIONS:
[ESCALATE TO CLAUDE]: Token storage — currently using localStorage via Zustand persist.
httpOnly cookie is more secure (prevents XSS). Needs architecture decision before
this goes to production.
```

## Rules
1. The output contract block is ALWAYS at the very end
2. All 4 states (loading/error/empty/success) are accounted for — mark each ✓
3. IMPORTS REQUIRED lists external dependencies the component has (not npm packages)
4. DESIGN DECISIONS are explicit about what was chosen and how to change it
5. ESCALATIONS are concrete — what decision is needed and why it matters
6. If no escalations, write: `⚠️ ESCALATIONS: none`
