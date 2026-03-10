# Backend Engineer — Output Format Reference

## Full Example Output

When Backend Engineer completes a task, the response ends with this exact block:

```
FILES MODIFIED:
- src/api/auth.ts (created)
- src/services/auth.service.ts (created)
- src/types/api/auth.ts (created)
- src/db/migrations/001_create_users.sql (created)

SUMMARY:
Implemented JWT-based authentication with email/password login and registration.
Password hashing uses bcryptjs (12 rounds). Tokens expire in 7 days and are
returned in the response body — token storage strategy left to Frontend per contract.

ERROR SHAPE:
{ "error": "INVALID_CREDENTIALS", "message": "Email or password is incorrect", "status": 401 }
{ "error": "DUPLICATE_EMAIL", "message": "An account with this email already exists", "status": 409 }

DEPENDENCIES ADDED:
- bcryptjs@2.4.3 (password hashing)
- jsonwebtoken@9.0.2 (JWT creation and verification)

⚠️ ESCALATIONS:
[ESCALATE TO CLAUDE]: Session storage strategy — Redis vs. in-memory? The current
implementation uses in-memory token blacklisting which will not work across multiple
server instances. Architecture decision needed before moving to production.
```

## Rules
1. The output contract block is ALWAYS at the very end of the response
2. All created/modified files are listed — no omissions
3. Error shapes are concrete JSON, not abstract descriptions
4. DEPENDENCIES ADDED lists the exact version installed, not just package names
5. ESCALATIONS are written as [ESCALATE TO CLAUDE]: followed by the decision needed
6. If no escalations, write: `⚠️ ESCALATIONS: none`
7. If no new dependencies, write: `DEPENDENCIES ADDED: none`
