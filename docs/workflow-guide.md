# Workflow guide

How to use AgentSquad day-to-day. This covers the four dispatch patterns from the blueprint and gives real examples for each.

## Starting a session

```bash
source ~/.agent-team/.env.team    # load credentials
~/.agent-team/scripts/health-check.sh  # verify agents are up
claude                            # open Claude Code in your project
```

That's it. If health check passes, you're ready.

---

## The four patterns

### Pattern A: Sequential (dependency chain)

Use when task B needs task A's output.

```
Claude writes api-contract.md
  → Backend implements endpoints
  → Claude reviews the output
  → QA writes tests using the reviewed code
```

In practice:
```bash
# 1. Claude writes api-contracts/auth.md first

# 2. Dispatch Backend
make backend TASK="$(cat agent-output/task-backend-auth.md)"

# 3. Review agent-output/backend-*.md before continuing

# 4. Dispatch QA with context
make qa TASK="Write tests for the auth endpoints in agent-output/backend-1234567.ts"
```

---

### Pattern B: Parallel (independent domains)

Use when tasks don't share files. Backend and Frontend working on the same feature can usually go parallel because they own different directories.

```bash
TS=$(date +%s)

# Dispatch all three simultaneously
GEMINI_API_KEY=$GEMINI_API_KEY \
  gemini -m gemini-2.5-flash --prompt "$(cat agent-output/task-backend.md)" \
  --approval-mode=yolo > agent-output/backend-${TS}.ts &
PID_BACKEND=$!

GEMINI_API_KEY=$GEMINI_API_KEY \
  gemini -m gemini-2.5-flash --prompt "$(cat agent-output/task-frontend.md)" \
  --approval-mode=yolo > agent-output/frontend-${TS}.tsx &
PID_FRONTEND=$!

GEMINI_API_KEY=$GEMINI_API_KEY \
  gemini -m gemini-2.5-flash-lite --prompt "$(cat agent-output/task-qa.md)" \
  --approval-mode=yolo > agent-output/qa-${TS}.ts &
PID_QA=$!

# Wait with exit code checking
wait "$PID_BACKEND"  || echo "⚠️  Backend failed"
wait "$PID_FRONTEND" || echo "⚠️  Frontend failed"
wait "$PID_QA"       || echo "⚠️  QA failed"

# Verify ALL files exist before integrating (v1.3 rule)
ls -lt agent-output/*-${TS}.*
```

**Before integrating:** check that all three files exist and are non-empty. If one failed silently, re-run it before merging anything.

---

### Pattern C: Research then build

Use before major features or architecture decisions. Run the Consultant first to get real data, then let that inform the implementation task.

```bash
# Research first
make consult TASK="What is the standard B2B SaaS subscription model in 2026?
  Per-seat vs flat-rate? Cite real product pricing pages and URLs."

# Read agent-output/consult-*.md
# Make the architecture decision based on what you find
# Then dispatch Backend/Frontend
```

Run the Consultant at project start, before pricing decisions, and before entering a new market. Not for every feature — 100 RPD on the free Pro tier goes fast.

---

### Pattern D: Git worktree isolation

Use for two features that would create file conflicts if developed in the same branch simultaneously.

```bash
# Create isolated branches for each feature
git worktree add -b feature/auth /tmp/worktrees/auth
git worktree add -b feature/billing /tmp/worktrees/billing

# Each agent works in its own worktree
GEMINI_API_KEY=$GEMINI_API_KEY \
  gemini -m gemini-2.5-flash \
  --prompt "Work in /tmp/worktrees/auth. $(cat task-auth.md)" \
  --approval-mode=yolo > agent-output/auth-summary.md &

GEMINI_API_KEY=$GEMINI_API_KEY \
  gemini -m gemini-2.5-flash \
  --prompt "Work in /tmp/worktrees/billing. $(cat task-billing.md)" \
  --approval-mode=yolo > agent-output/billing-summary.md &

wait

# Claude reviews both, then merges
git worktree remove /tmp/worktrees/auth
git worktree remove /tmp/worktrees/billing
```

---

## Naming convention for output files

All files in `agent-output/` follow this pattern:

```
{role}-{feature}-{unix-timestamp}.{ext}
```

Examples:
```
backend-auth-1741234567.ts
frontend-login-form-1741234567.tsx
qa-auth-tests-1741234567.ts
devops-ci-1741234567.yml
consult-pricing-1741234567.md
```

The timestamp makes it easy to match a set of parallel outputs (`ls -lt agent-output/`). Use `date +%s` to generate it before dispatching.

---

## Full example: subscription billing feature

**You say:** "Add Stripe subscription billing."

**Claude's plan:**
1. Consultant → research SaaS billing norms
2. Claude → design multi-tenant subscription model, write `api-contracts/billing.md`
3. Backend + Frontend UI scaffold → parallel
4. Backend Stripe webhook handler → sequential (security, Claude handles this)
5. QA → tests for billing API
6. DevOps → add `STRIPE_SECRET_KEY` to `.env.example` and CI

```bash
# Step 1
make consult TASK="Standard B2B SaaS billing model in 2026. Per-seat vs flat-rate pricing benchmarks. Cite real companies."

# Step 2: Claude reads research, designs, writes api-contracts/billing.md

# Step 3: parallel
TS=$(date +%s)
GEMINI_API_KEY=$GEMINI_API_KEY gemini -m gemini-2.5-flash \
  --prompt "$(cat agent-output/task-billing-schema.md)" \
  --approval-mode=yolo > agent-output/backend-billing-${TS}.sql &
GEMINI_API_KEY=$GEMINI_API_KEY gemini -m gemini-2.5-flash \
  --prompt "$(cat agent-output/task-billing-ui.md)" \
  --approval-mode=yolo > agent-output/frontend-billing-${TS}.tsx &
wait

# Step 4: Claude writes Stripe webhook handler directly

# Step 5: sequential
make qa TASK="Write tests for billing schema in agent-output/backend-billing-${TS}.sql"

# Step 6:
make devops TASK="Add STRIPE_SECRET_KEY and STRIPE_WEBHOOK_SECRET to .env.example and CI"
```

---

## Handling escalations

When an agent can't make a decision, it writes `[ESCALATE TO CLAUDE]` in its output. The `gemini-call.sh` wrapper catches this and prints a warning.

```
🚨 ESCALATION REQUIRED — agent flagged a decision in: agent-output/backend-auth-1234.ts
   Search for [ESCALATE TO CLAUDE] and resolve before integrating.
```

Open the file, find the escalation, make the decision, then re-dispatch with the answer included in the next task prompt.

---

## Reviewing agent output

Before integrating anything from `agent-output/`, run through this checklist:

- [ ] The output contract block is present at the end (FILES MODIFIED, SUMMARY, etc.)
- [ ] No `[ESCALATE TO CLAUDE]` flags that haven't been resolved
- [ ] Dependencies added are legitimate packages, not hallucinations
- [ ] Shared types (`/src/types/shared/`) weren't touched (that's Claude's domain)
- [ ] Error shapes match the `api-contract.md` spec
