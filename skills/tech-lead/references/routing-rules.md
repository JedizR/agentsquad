# Tech Lead — Routing Rules Reference

## Decision Tree: Delegate vs. Handle Directly

```
Is this a security-sensitive decision?
  → YES: Handle yourself (never delegate auth, payments, cryptography design)
  → NO: Is this pure execution (code that follows a clear spec)?
      → YES: Delegate to the appropriate agent
      → NO: Is this a design or architecture decision?
          → YES: Handle yourself, then delegate the implementation
          → NO: Delegate and let the agent decide implementation details
```

## Route to: Backend Engineer
- REST/GraphQL endpoint implementation (after api-contract.md is written)
- Database schema changes and migrations
- Service layer business logic
- Third-party integrations (Stripe, SendGrid, S3)
- Input validation schemas
- OpenAPI/Swagger documentation

## Route to: Frontend Engineer
- UI component implementation
- Page layout and navigation
- Client-side state management
- Form implementation
- API integration (fetch/mutation calls)
- Responsive design implementation
- Accessibility implementation

## Route to: QA Engineer
- Test writing for completed Backend or Frontend code
- Coverage audits after a feature is built
- Bug reproduction and reporting
- E2E test scenarios for a completed user flow

## Route to: DevOps Engineer
- Dockerfile and docker-compose creation
- GitHub Actions pipeline setup
- Deployment configuration for a new service
- Environment variable management (.env.example updates)
- Database backup and restore scripts

## Route to: Business Consultant
- Market research (before major feature or product direction decisions)
- Competitor analysis (before starting a feature that might already exist)
- Pricing strategy research (before publishing pricing)
- Regulatory research (GDPR, CCPA, HIPAA — always ends with "consult a lawyer")
- Technology landscape analysis (is our chosen stack the right fit?)

## Never Delegate (Always Claude)
| Decision | Why |
|---------|-----|
| System architecture | Affects everything downstream |
| API contracts | Must be consistent across agents |
| Security design | Auth flows, token strategy, encryption |
| Cross-domain types (/src/types/shared/) | Prevents type conflicts |
| Final code review | Claude sees the full picture |
| Escalation resolution | Agents escalate TO Claude |
| Production deployments | Irreversible — requires judgment |

## Parallel vs. Sequential Dispatch

**Parallel** (same sprint):
- Backend endpoint implementation + Frontend UI scaffold (different files, no conflict)
- QA test writing + Frontend form implementation (different files)
- DevOps CI/CD setup + any feature work (different files)

**Sequential** (must wait):
- Backend implements endpoint → QA writes tests (QA needs real code to test)
- Backend implements endpoint → Frontend integrates API (Frontend needs real response shape)
- Business Consultant researches → Claude designs architecture → Backend implements

**Never parallel**:
- Two agents modifying the same file
- Frontend integration before Backend endpoint exists (use mocks instead)
- Any auth-related work without Claude security review first
