# SaaS Starter — AgentSquad Example

This example shows how to configure AgentSquad for a multi-tenant B2B SaaS project.

## Stack

- Node.js/TypeScript + Express + PostgreSQL (backend)
- React 18 + Vite + Tailwind CSS (frontend)
- Stripe Subscriptions (billing)
- Railway + Vercel (deploy)

## How to use this example

1. Copy `CLAUDE.md` into your project root
2. Run `/init-agent-team` in Claude Code — it generates `TEAM.md`, `Makefile`, and `.gemini/settings.json`
3. Replace the generated `CLAUDE.md` with this one (it has SaaS-specific routing rules)
4. Run `make team-health` to verify all agents respond

## Example workflow: adding a new feature

```bash
# 1. Research the market (before committing to an approach)
make consult TASK="What are the standard subscription tier structures for
  B2B project management SaaS tools in 2026? Per-seat vs flat-rate?
  Cite real products and pricing pages."

# 2. You read the research, design the API contract
# Write: api-contracts/subscriptions.md

# 3. Parallel: database schema + frontend billing page
TS=$(date +%s)
make backend  TASK="$(cat api-contracts/subscriptions.md)
  Implement the subscription database schema using Prisma.
  Output to agent-output/backend-billing-${TS}.prisma" &
make frontend TASK="Build the billing settings page per
  api-contracts/subscriptions.md.
  Output to agent-output/frontend-billing-${TS}.tsx" &
wait

# 4. Review both outputs before integrating

# 5. Sequential: tests after backend schema is confirmed
make qa TASK="Write Vitest unit tests for the subscription service
  in agent-output/backend-billing-${TS}.prisma"

# 6. DevOps: CI update
make devops TASK="Add STRIPE_SECRET_KEY and STRIPE_WEBHOOK_SECRET
  to .env.example and the GitHub Actions CI pipeline"
```

## Routing decisions

Auth logic and Stripe webhooks stay with you (Claude). These are the two areas
where the cost of an agent mistake is highest. Everything else can be delegated.

See `CLAUDE.md` for the full routing table.
