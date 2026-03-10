# Agency Platform — AgentSquad Example

This example shows how to configure AgentSquad for a Python/FastAPI backend
with a Next.js frontend — a common agency stack.

## Stack

- Python 3.12 + FastAPI + PostgreSQL (backend)
- Next.js 14 + TypeScript + Tailwind + Shadcn/UI (frontend)
- Auth0 (multi-tenant auth)
- Fly.io + Vercel (deploy)

## How to use this example

1. Copy `CLAUDE.md` into your project root
2. Run `/init-agent-team` in Claude Code
3. Replace the generated `CLAUDE.md` with this one
4. Run `make team-health` to verify all agents respond

## Key difference from the SaaS starter

The default SKILL.md files assume Node.js/TypeScript for backend and React for
frontend. For this stack, include explicit stack constraints in every task prompt:

```bash
make backend TASK="You are working in a Python/FastAPI codebase.
  Implement the project listing endpoint per api-contracts/projects.md.
  Use SQLAlchemy models and follow the patterns in src/api/routes/clients.py.
  Output file: agent-output/backend-projects-$(date +%s).py"
```

Adding "Python/FastAPI" and a reference to an existing file keeps the agent on
the right stack.

## Example workflow: adding a client portal feature

```bash
# 1. Research what clients expect from approval portals
make consult TASK="What features do digital agency client portals need
  in 2026? What do Basecamp, Monday.com, and agency-specific tools like
  Function Point offer? Focus on approval workflows."

# 2. Design the API contract
# Write: api-contracts/client-portal.md

# 3. Parallel dispatch
TS=$(date +%s)
make backend TASK="Python/FastAPI. Implement client portal endpoints per
  api-contracts/client-portal.md. Reference src/api/routes/clients.py
  for existing patterns." &
make frontend TASK="Next.js 14 with Shadcn/UI. Build the client portal
  approval page per api-contracts/client-portal.md." &
wait

# 4. Review outputs

# 5. Tests
make qa TASK="Write pytest tests for the client portal endpoints in
  agent-output/backend-portal-${TS}.py"
```

## Multi-tenant check

Before integrating any Backend output, verify that every database query
includes a `workspace_id` filter. This is the most common mistake agents
make on multi-tenant schemas, and it's worth a quick scan before running
any migration.
