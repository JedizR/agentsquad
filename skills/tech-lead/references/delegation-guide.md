# Tech Lead — Delegation Guide Reference

## How to Write Effective Gemini Task Prompts

### The 5-Part Task Prompt
Every task sent to a Gemini agent must include:

```
ROLE: [Which agent this is for]
SKILL: [SKILL.md reference path]
CONTEXT: [Relevant background — what already exists, what was decided]
TASK: [Exactly what to build/test/research — no ambiguity]
CONSTRAINTS: [What not to do, what patterns to follow, what to escalate]
```

### Example: Backend Task
```markdown
ROLE: Backend Engineer
SKILL: ~/.agent-team/skills/backend-engineer/SKILL.md

CONTEXT:
- Project: SaaS task management app (NestJS + PostgreSQL + TypeScript)
- Auth is already implemented (see src/api/auth.ts)
- Using Knex for DB queries (see src/db/knex.ts for patterns)
- API contract is at: api-contracts/tasks-api-contract.md

TASK:
Implement the tasks API following the contract at api-contracts/tasks-api-contract.md.
Create:
1. GET /api/v1/tasks (paginated list, filter by status, owned by authenticated user)
2. POST /api/v1/tasks (create task)
3. PATCH /api/v1/tasks/:id (update status, title, description — partial update)
4. DELETE /api/v1/tasks/:id (soft delete — set deleted_at)

CONSTRAINTS:
- Match existing code style in src/api/auth.ts (class-based controllers)
- Use existing Knex patterns in src/db/knex.ts
- Do NOT create new npm dependencies without escalating first
- Do NOT implement sharing/collaboration features — that is Phase 3
- Escalate if the api-contract.md is unclear on any endpoint
```

### Example: Frontend Task
```markdown
ROLE: Frontend Engineer
SKILL: ~/.agent-team/skills/frontend-engineer/SKILL.md

CONTEXT:
- Project: React + TypeScript + Tailwind CSS
- Design system: shadcn/ui components available at src/components/ui/
- Auth hook: useAuthStore (Zustand, see src/stores/useAuthStore.ts)
- API client: src/lib/api.ts (axios wrapper with auth token injection)
- Tasks API contract: api-contracts/tasks-api-contract.md
- Backend implementation output: agent-output/backend-tasks-[timestamp].ts (attached below)

TASK:
Build the Tasks dashboard page at src/pages/TasksPage.tsx:
1. List all tasks for the authenticated user (use GET /api/v1/tasks)
2. Filter tabs: All / Active / Completed
3. Create task button → inline form (title + status)
4. Mark complete checkbox on each task row → PATCH /api/v1/tasks/:id

CONSTRAINTS:
- Handle all 4 states: loading (skeleton), error, empty state, and populated list
- Use shadcn/ui Table, Button, Checkbox components — do not invent new UI primitives
- Mobile-first responsive (tasks list must work on 375px viewport)
- Escalate if token storage or auth flow decisions are needed
```

## When to Write an API Contract First
Always write an api-contract.md before dispatching Backend + Frontend for the same feature:
- Defines the endpoint before either agent writes code
- Prevents Backend and Frontend from having different assumptions
- Lives in api-contracts/ — always authored by Claude, never by agents
