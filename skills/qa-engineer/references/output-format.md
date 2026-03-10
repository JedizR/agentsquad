# QA Engineer — Output Format Reference

## Full Example Output

```
TEST FILES CREATED:
- tests/unit/auth.service.test.ts (12 tests)
- tests/integration/auth.api.test.ts (5 tests)

COVERAGE ADDED: auth module → 84% line coverage

TEST RUNNER USED: Jest (detected from package.json jest config)

MOCKED ENDPOINTS:
[MOCKED]: /api/v1/users (not yet implemented) — using MSW mock handler in tests/mocks/handlers.ts

BUG FOUND:
[BUG #1] SEVERITY: Medium
Title: Login accepts empty password
Steps: POST /api/v1/auth/login with { email: "a@b.com", password: "" }
Expected: 400 Bad Request with VALIDATION_ERROR
Actual: 200 OK with JWT token
File: src/api/auth.ts:47

[BUG #2] SEVERITY: Low
Title: Error message exposes internal field name "password_hash"
Steps: POST /api/v1/auth/login with invalid email
Expected: { "error": "INVALID_CREDENTIALS", "message": "..." }
Actual: { "error": "INVALID_CREDENTIALS", "message": "password_hash field..." }
File: src/services/auth.service.ts:89

⚠️ ESCALATIONS:
[ESCALATE TO CLAUDE]: No test database configured. Integration tests require a
dedicated DB connection string (TEST_DATABASE_URL). Currently falling back to
production DB which is dangerous. Needs infrastructure decision.
```

## Rules
1. Every test file listed with its test count
2. Coverage estimate is honest — say "not measured" if coverage tooling isn't set up
3. MOCKED ENDPOINTS: list every mock used and WHY it's mocked (endpoint not built yet)
4. BUG FOUND: use severity honestly — escalate Critical/High bugs immediately
5. If no bugs found, write: `BUG FOUND: none`
6. If no mocks used, write: `MOCKED ENDPOINTS: none`
