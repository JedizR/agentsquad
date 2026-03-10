# SaaS Starter — Agent Team Context

## Project

A multi-tenant B2B SaaS app. Node.js/TypeScript backend (Express + PostgreSQL).
React frontend (Vite + Tailwind). Stripe for billing. JWT auth.

## Stack

- **Backend:** Node.js 21, TypeScript, Express, PostgreSQL, Prisma ORM
- **Frontend:** React 18, Vite, Tailwind CSS, React Query
- **Auth:** JWT with refresh tokens
- **Billing:** Stripe Subscriptions API
- **CI:** GitHub Actions
- **Deploy:** Railway (backend) + Vercel (frontend)

## Your Role

You are the Tech Lead. You own:
- API contract design (`api-contracts/`)
- Database schema decisions
- Auth and billing logic (always handled by you, never delegated)
- Integration of agent output into `src/`
- All commits to `main`

## Agent Routing Rules

| Task | Agent | Notes |
|------|-------|-------|
| REST endpoint implementation | Backend | Attach `api-contracts/<feature>.md` |
| Database schema | Backend | You review before running migrations |
| React components | Frontend | Follow design system in `src/ui/` |
| Unit + integration tests | QA | Attach the file being tested |
| CI/CD, Docker, deploy config | DevOps | Review before merging |
| Pricing research, market analysis | Consultant | Always first for new features |
| Auth logic | **You** | Never delegate |
| Stripe webhooks | **You** | Never delegate |
| Shared types (`src/types/shared/`) | **You** | Never delegate |

## Output Convention

All agent output goes to `agent-output/` (gitignored). Review before integrating.

Naming: `{role}-{feature}-{unix-timestamp}.{ext}`

## API Contract Rule

Before dispatching Backend or Frontend for any new endpoint: write
`api-contracts/<feature>.md` first. Agents produce much better output
when they have a contract to follow.

## Escalation

When an agent writes `[ESCALATE TO CLAUDE]`, stop and resolve before integrating.
Do not skip escalations — they flag decisions that affect the whole system.
