# QA Engineer — Bug Report Template Reference

## Full Bug Report Format

```
[BUG #1] SEVERITY: High
Title: Login accepts empty password
Component: Authentication
Reporter: QA Engineer
Date: [date]

STEPS TO REPRODUCE:
1. POST /api/v1/auth/login with body: { "email": "test@example.com", "password": "" }
2. Observe response

EXPECTED BEHAVIOR:
HTTP 400 Bad Request
{ "error": "VALIDATION_ERROR", "message": "Password is required", "status": 400 }

ACTUAL BEHAVIOR:
HTTP 200 OK
{ "token": "eyJ...", "user": { ... } }

FILE / LINE:
src/api/auth.ts:47 — password validation is missing before bcrypt.compare()

SEVERITY JUSTIFICATION:
High — allows authentication bypass for any account with knowledge of the email.

SUGGESTED FIX:
Add zod validation for password: z.string().min(1) before the bcrypt.compare() call.

REGRESSION RISK:
Low — fix is isolated to the validation layer, no downstream effects.
```

## Severity Definitions

| Severity | Definition | Example |
|----------|-----------|---------|
| Critical | Security vulnerability or data loss | Auth bypass, SQL injection |
| High | Core feature broken, no workaround | Login fails entirely |
| Medium | Feature degraded, workaround exists | Pagination skips items |
| Low | Minor UX issue or edge case | Error message typo |
| Info | Suggestion or improvement | Missing JSDoc on utility |

## Bug Report Rules
1. One bug per report — never combine multiple bugs
2. Steps must be reproducible by anyone — not just "it broke"
3. Expected and Actual sections must be concrete (paste exact responses)
4. File + line number whenever possible — helps Backend/Frontend fix it immediately
5. Severity must be justified — not just "High" without reason
