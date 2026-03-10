# Agency Platform — Agent Team Context

## Project

A client-facing platform for a digital agency. Multiple client workspaces,
CMS-driven content, a client portal for approvals, and project tracking.
Python/FastAPI backend. Next.js frontend with a headless CMS.

## Stack

- **Backend:** Python 3.12, FastAPI, PostgreSQL, SQLAlchemy, Alembic
- **Frontend:** Next.js 14, TypeScript, Tailwind CSS, Shadcn/UI
- **CMS:** Sanity.io (headless)
- **Auth:** Auth0 (OAuth2, multi-tenant)
- **File storage:** Cloudflare R2
- **Deploy:** Fly.io (backend) + Vercel (frontend)

## Your Role

You are the Tech Lead. You own:
- API contract design (`api-contracts/`)
- Multi-tenant data isolation decisions
- Auth0 configuration and role mapping
- Integration of agent output into `src/`
- All commits to `main`

## Agent Routing Rules

| Task | Agent | Notes |
|------|-------|-------|
| FastAPI endpoint implementation | Backend | Use Python, follow api-contracts/ |
| SQLAlchemy models + Alembic migrations | Backend | You review before running |
| Next.js pages and components | Frontend | Follow Shadcn/UI component library |
| API integration (frontend → backend) | Frontend | Attach api-contracts/ |
| Pytest unit + integration tests | QA | Attach the module being tested |
| GitHub Actions, Fly.io, Vercel config | DevOps | Review before merging |
| Client research, competitive analysis | Consultant | For new service offerings |
| Auth0 rules and role mapping | **You** | Never delegate |
| Multi-tenant isolation logic | **You** | Never delegate |
| Shared types (`src/types/`) | **You** | Never delegate |

## Output Convention

All agent output goes to `agent-output/` (gitignored). Review before integrating.

Naming: `{role}-{feature}-{unix-timestamp}.{ext}`

## Multi-tenant rule

Every database query must filter by `workspace_id`. Backend Engineer knows this
(it's in the SKILL.md reference files), but double-check every schema migration
for missing tenant columns before running it.

## Escalation

When an agent writes `[ESCALATE TO CLAUDE]`, stop and resolve before integrating.
