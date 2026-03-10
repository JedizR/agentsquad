# AgentSquad — Lean AI Startup Team Blueprint

> **Version:** 1.3 · **Author:** Natakorn (with Claude)
> **Reviewed by:** 4 specialized analysis agents (v1.1) + Gemini 3 Pro CTO Review × 2 (v1.2, v1.3)
> **Purpose:** A portable, human-driven, skills-based multi-agent co-working environment for building production SaaS/agency platforms. Stretch a Claude Pro subscription across a full 6-agent startup team using a single Gemini API key.

---

## Table of Contents

1. [Vision & Philosophy](#1-vision--philosophy)
2. [Team Roster Overview](#2-team-roster-overview)
3. [Agent Profiles (Detailed)](#3-agent-profiles-detailed)
4. [Google Account & Credential Strategy](#4-google-account--credential-strategy)
5. [Infrastructure Layout](#5-infrastructure-layout)
6. [Skills Architecture](#6-skills-architecture)
7. [Communication & Workflow Patterns](#7-communication--workflow-patterns)
8. [Day-to-Day Workflow](#8-day-to-day-workflow)
9. [Project Bootstrapping: `init-agent-team` Skill](#9-project-bootstrapping-init-agent-team-skill)
10. [Script Specifications](#10-script-specifications)
11. [Templates](#11-templates)
12. [Full Directory Structure](#12-full-directory-structure)
13. [Implementation Phases](#13-implementation-phases)
14. [GitHub Release Plan](#14-github-release-plan)
15. [Appendices](#15-appendices)

---

## 1. Vision & Philosophy

### The Problem
A solo developer on Claude Pro can build well, but Claude's token budget runs thin fast — leaving little room for learning, exploration, and keeping up with the rapidly evolving 2026 tech landscape.

### The Solution
A **lean, human-driven co-working environment** where:
- **You + Claude Code** act as the technical founder and lead — handling architecture, complex features, decisions, and final integration
- **Gemini CLI agents** (on Google's generous free tier) handle specialized execution: coding, testing, infrastructure, business research
- **Skills** give each agent deep domain expertise without burning context
- **The whole team bootstraps onto any new project in minutes** via a single Claude skill

### Guiding Principles
| Principle | Meaning |
|-----------|---------|
| **Lean** | Minimum agents that can ship production software. No bloat. |
| **Human-in-the-loop** | You drive everything. Agents work _for_ you, not autonomously. |
| **Skills over system prompts** | Expertise is encoded in versioned SKILL.md files, not burned into every prompt. |
| **One source of truth** | `~/.agent-team/` is the portable home — migratable across machines. |
| **Open for publication** | Built to GitHub-release-quality from day one. |

---

## 2. Team Roster Overview

| # | Agent | Runtime | Primary Role | Model | API Key |
|---|-------|---------|-------------|-------|---------|
| 1 | **You + Claude Code** | Anthropic Pro | Tech Founder / Head | Claude (latest) | Anthropic subscription |
| 2 | **Backend Engineer** | Gemini CLI | Server, APIs, Database | `gemini-2.5-flash` | `GEMINI_API_KEY` |
| 3 | **Frontend Engineer** | Gemini CLI | UI, Components, Client | `gemini-2.5-flash` | `GEMINI_API_KEY` |
| 4 | **QA Engineer** | Gemini CLI | Testing, Quality, Coverage | `gemini-2.5-flash-lite` | `GEMINI_API_KEY` |
| 5 | **DevOps Engineer** | Gemini CLI | Infrastructure, CI/CD, Deployment | `gemini-2.5-flash-lite` | `GEMINI_API_KEY` |
| 6 | **Business Consultant** | Gemini CLI (Google Search) | Strategy, Research, Second Opinion | `web-search` (Pro+Search) | `GEMINI_API_KEY` |

> **All 5 Gemini agents share one API key** — differentiated by model flag (`-m`), not separate accounts. Optional per-agent key overrides are supported for future quota isolation (see Section 4).

**Total: 6 agents** — the minimum viable team to take a startup product from idea to live production.

---

## 3. Agent Profiles (Detailed)

---

### 3.1 You + Claude Code — Tech Founder / Head

#### Identity
You are the founder, the product owner, and the technical director. Claude Code is your extended intelligence — your co-founder who never sleeps and never loses context. Together you form the decision-making center of the team.

#### Responsibilities
- **Product Strategy** — Define what gets built, in what order, and why (lean startup thinking)
- **Architecture Design** — System design, data modeling, technology stack decisions, API contracts
- **API Contract Authoring** — Before any Backend/Frontend work starts on a feature, produce a brief `api-contract.md` specifying: endpoint path, request/response shape, HTTP status codes, and error shapes. Both agents receive this as context.
- **Complex Feature Implementation** — Business logic too nuanced to delegate, security-sensitive code, multi-system integrations
- **Task Decomposition** — Break features into delegatable subtasks; write high-quality task prompts for Gemini agents
- **Code Review & Integration** — Review all Gemini output, merge, resolve conflicts, ensure coherence
- **Type Consolidation** — All shared TypeScript types that span Backend and Frontend are authored or approved by Claude and live in `/src/types/shared/`
- **Debugging & Bug Fixing** — Root-cause analysis, tracing errors across systems, fixing subtle bugs
- **Final QA Sign-off** — Approve code before it hits production
- **Team Coordination** — Decide when to run agents in parallel vs. sequential; manage rate limits
- **Second-Opinion Requests** — Route strategic questions to Business Consultant for additional perspective

#### Domain Ownership
- All files (Claude has full codebase visibility)
- `/src/types/shared/` — Cross-domain TypeScript interfaces
- `CLAUDE.md` — authoritative project configuration
- `TEAM.md` — team charter for contributors
- `api-contracts/` — API contract documents authored before implementation
- Architecture decision records (ADRs)

#### Skills to Install

| Skill | Source | Install Path | Purpose |
|-------|--------|-------------|---------|
| `lean-startup` | [Jeremy Longshore](https://github.com/jeremylongshore/claude-code-plugins-plus-skills) via `ccpi install lean-startup` | `~/.claude/skills/lean-startup/` | Build-Measure-Learn, MVP thinking |
| `skill-creator` | [Anthropic Official](https://github.com/anthropics/skills) | `~/.claude/skills/skill-creator/` | Build new SKILL.md files for the team |
| `mcp-builder` | [Anthropic Official](https://github.com/anthropics/skills) | `~/.claude/skills/mcp-builder/` | Create MCP servers to extend agent capabilities |
| `prompt-architect` | Available via `find-skills` or build custom | `~/.claude/skills/prompt-architect/` | Structure high-quality prompts when delegating to Gemini |
| `technical-writer` | Available via `find-skills` or build custom | `~/.claude/skills/technical-writer/` | Documentation, READMEs, ADRs, specs |
| `performance-optimization` | Available via `find-skills` or build custom | `~/.claude/skills/performance-optimization/` | Systematic code optimization during review |
| `frontend-design` | [Anthropic Official](https://github.com/anthropics/skills) | `~/.claude/skills/frontend-design/` | UI/design review and direction |
| `webapp-testing` | [Anthropic Official](https://github.com/anthropics/skills) | `~/.claude/skills/webapp-testing/` | End-to-end test review using Playwright |
| `init-agent-team` | **Built by this project** | `~/.claude/skills/init-agent-team/` | Bootstrap the full team onto any new repo |

**Install Anthropic official skills:**
```bash
# Clone the official skills repo and symlink into personal skills dir
git clone https://github.com/anthropics/skills /tmp/anthropic-skills
mkdir -p ~/.claude/skills
for skill in skill-creator mcp-builder frontend-design webapp-testing; do
  ln -sf /tmp/anthropic-skills/skills/$skill ~/.claude/skills/$skill
done

# Install via ccpi package manager (Jeremy Longshore's skills)
pnpm add -g @intentsolutionsio/ccpi
ccpi install lean-startup
```

#### Escalation Protocol (What comes TO Claude)
- Any architectural decision (database choice, service boundaries, API contracts)
- Security-sensitive code (auth, payments, data privacy)
- Unclear or ambiguous requirements from the client/user
- When Gemini output is low quality and needs rethinking
- Cross-domain integration work (anything spanning Backend + Frontend domains)
- Anything that touches production infrastructure

---

### 3.2 Backend Engineer

#### Identity
A senior full-stack backend engineer specialized in building reliable, scalable server-side systems. Focuses on clean APIs, robust data models, and maintainable business logic. Works within defined boundaries and escalates architecture decisions upward.

#### Responsibilities
- **API Development** — REST and GraphQL endpoints, request/response validation, pagination, filtering — always following the `api-contract.md` Claude provides
- **Database Schema & Migrations** — Table design, relationships, indexes, migration scripts
- **Business Logic Implementation** — Service layer, domain models, data transformation
- **Authentication & Authorization** — JWT, sessions, role-based access control (delegates security design to Claude)
- **Third-Party Integrations** — Payment gateways (Stripe), email (SendGrid), storage (S3), external APIs
- **Server Configuration** — Environment variables, middleware setup, CORS, rate limiting
- **Performance Optimization** — Query optimization, caching strategies, N+1 detection
- **API Documentation** — OpenAPI/Swagger specs, inline JSDoc/docstrings
- **Error Definitions** — Implement error codes, HTTP status codes, and error message formats exactly as specified in Claude's `api-contract.md`

#### Domain Ownership
```
/src/api/             — Route handlers, controllers
/src/services/        — Business logic layer
/src/db/              — Database models, migrations, seeds
/src/middleware/       — Auth, logging, error handling middleware
/src/integrations/    — Third-party service wrappers
/src/types/api/       — API-specific TypeScript types (request/response bodies)
/src/utils/           — Backend utility functions
```

> **Note on Types:** Backend Engineer owns `/src/types/api/` (API shapes only). `/src/types/shared/` is owned exclusively by Claude. Frontend owns `/src/types/ui/`.

#### Skills to Install

| Skill | Source Repo | Actual Directory Name | Purpose |
|-------|------------|----------------------|---------|
| `nestjs-expert` OR `fastapi-expert` OR `django-expert` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/nestjs-expert` | Framework best practices — pick one per project |
| `api-designer` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/api-designer` | REST conventions, versioning, error standards |
| `postgres-pro` OR `database-optimizer` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/postgres-pro` | Schema design, indexing, query optimization |
| `secure-code-guardian` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/secure-code-guardian` | OWASP compliance, injection prevention |
| `lean-startup` | [Jeremy Longshore](https://github.com/jeremylongshore/claude-code-plugins-plus-skills) | via ccpi | Avoid premature optimization |

**Install:**
```bash
git clone https://github.com/Jeffallan/claude-skills /tmp/jeff-skills
mkdir -p ~/.agent-team/skills/backend-engineer
# Copy chosen framework skill
cp -r /tmp/jeff-skills/skills/nestjs-expert ~/.agent-team/skills/backend-engineer/nestjs-expert
cp -r /tmp/jeff-skills/skills/api-designer ~/.agent-team/skills/backend-engineer/api-designer
cp -r /tmp/jeff-skills/skills/postgres-pro ~/.agent-team/skills/backend-engineer/postgres-pro
cp -r /tmp/jeff-skills/skills/secure-code-guardian ~/.agent-team/skills/backend-engineer/secure-code-guardian
```

**Installation path for the role SKILL.md:** `~/.agent-team/skills/backend-engineer/SKILL.md`
**Symlinked into project:** `.gemini/skills/backend-engineer/`

#### Output Contract (What Backend returns to Claude)
When a task is complete, always return in this format:

```
FILES MODIFIED:
- src/api/auth.ts (created)
- src/types/api/auth.ts (created)
- src/db/migrations/001_add_users.ts (created)

SUMMARY:
[2–3 sentences describing what was implemented]

ERROR SHAPE:
{ "error": "INVALID_CREDENTIALS", "message": "Email or password is incorrect", "status": 401 }

DEPENDENCIES ADDED:
- bcryptjs@2.4.3 (password hashing)

⚠️ ESCALATIONS:
[ESCALATE TO CLAUDE]: Session storage strategy — Redis vs. in-memory? Needs architecture decision.
```

Additional rules:
- No hallucinated packages — only use what is in `package.json` / `requirements.txt` or explicitly state what to add
- Flag every security-sensitive decision with `[ESCALATE TO CLAUDE]`

#### Escalation Protocol
Return control to Claude when:
- Database schema changes affect existing production data
- A new external service dependency needs to be introduced
- Authentication or authorization design decisions are needed
- Multi-service transaction logic spans multiple services

---

### 3.3 Frontend Engineer

#### Identity
A senior frontend engineer with strong UX sensibility. Builds clean, accessible, performant user interfaces. Makes bold design decisions and avoids generic aesthetics. Translates API contracts into delightful user experiences.

#### Responsibilities
- **Component Development** — Reusable UI components with props, slots, variants — always follows the design system tokens
- **Page Implementation** — Full page layouts, routing, navigation flows
- **State Management** — Client-side state, server state sync (React Query, Zustand, Pinia, etc.)
- **Form Handling** — Validation, error display, multi-step forms, file uploads. Uses error codes from Claude's `api-contract.md` for error display
- **API Integration** — Fetch/axios calls, loading states, error boundaries, optimistic updates
- **Responsive Design** — Mobile-first, breakpoint management, adaptive layouts
- **Accessibility (a11y)** — ARIA labels, keyboard navigation, screen reader support, color contrast ratios (minimum WCAG AA)
- **SEO** — Meta tags, og: tags, structured data, and `<head>` management for all public-facing pages
- **Animation & Micro-interactions** — Smooth transitions, loading skeletons, hover states

#### Domain Ownership
```
/src/components/   — Reusable UI components
/src/pages/        — Page-level components / route views
/src/layouts/      — Layout wrappers
/src/hooks/        — Custom React/Vue hooks
/src/stores/       — Client-side state (Zustand, Pinia)
/src/styles/       — Global CSS, theme tokens, utility classes
/src/assets/       — Static assets (icons, images)
/src/types/ui/     — UI-specific TypeScript types (component props, client state)
/public/           — Public-facing static files
```

> **Note on Types:** Frontend Engineer owns `/src/types/ui/` only. Cross-domain types in `/src/types/shared/` are owned by Claude.

#### Skills to Install

| Skill | Source Repo | Actual Directory Name | Purpose |
|-------|------------|----------------------|---------|
| `react-expert` OR `vue-expert` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/react-expert` | Framework-specific patterns |
| `nextjs-developer` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/nextjs-developer` ⚠️ (NOT `nextjs-expert`) | Next.js App Router patterns |
| `frontend-design` | [Anthropic Official](https://github.com/anthropics/skills) | `skills/frontend-design` | Bold design decisions, design systems |
| `web-artifacts-builder` | [Anthropic Official](https://github.com/anthropics/skills) | `skills/web-artifacts-builder` | React + Tailwind + shadcn/ui components |
| `lean-startup` | [Jeremy Longshore](https://github.com/jeremylongshore/claude-code-plugins-plus-skills) | via ccpi | Build the screen that matters, not all screens |

> ⚠️ **Naming warning:** The Next.js skill directory is called `nextjs-developer`, NOT `nextjs-expert`. The wrong name will cause a "directory not found" error.

**Install:**
```bash
cp -r /tmp/jeff-skills/skills/react-expert ~/.agent-team/skills/frontend-engineer/react-expert
cp -r /tmp/jeff-skills/skills/nextjs-developer ~/.agent-team/skills/frontend-engineer/nextjs-developer
# Anthropic skills (already cloned above)
cp -r /tmp/anthropic-skills/skills/frontend-design ~/.agent-team/skills/frontend-engineer/frontend-design
cp -r /tmp/anthropic-skills/skills/web-artifacts-builder ~/.agent-team/skills/frontend-engineer/web-artifacts-builder
```

#### Output Contract (What Frontend returns to Claude)

```
FILES MODIFIED:
- src/components/LoginForm.tsx (created)
- src/hooks/useAuth.ts (created)

SUMMARY:
[2–3 sentences describing what was built]

STATES HANDLED: loading ✓ | error ✓ | empty ✓ | success ✓

LOADING PATTERN USED: Skeleton screen (replace with spinner if preferred)

IMPORTS REQUIRED:
- src/types/api/auth.ts → AuthResponse (must exist before this renders)

🎨 DESIGN DECISIONS:
[DESIGN DECISION]: Used blue primary button for CTA. Change colorScheme in theme.ts if different.

⚠️ ESCALATIONS:
[ESCALATE TO CLAUDE]: Token storage — localStorage vs. httpOnly cookie? Security decision needed.
```

#### Escalation Protocol
Return control to Claude when:
- New routing structure or navigation architecture changes
- Design system / token changes that affect the entire app
- New third-party UI library introduction
- Authentication UI flows (login, signup, password reset) — these go through Claude for security review

---

### 3.4 QA Engineer

#### Identity
A methodical quality engineer who ensures the product works correctly, handles edge cases, and doesn't regress. Writes tests that serve as living documentation. Operates as the team's last line of defense before code ships.

#### Responsibilities
- **Unit Testing** — Test individual functions, services, and utilities in isolation
- **Integration Testing** — Test API endpoints, database interactions, service integrations
- **Component Testing** — Test UI components in isolation with mocked data
- **End-to-End Testing** — Test critical user flows from browser to database (via Playwright)
- **Test Coverage Audits** — Identify untested code paths, prioritize coverage improvements
- **Bug Reports** — Structured bug reports with reproduction steps, expected vs. actual behavior
- **Regression Testing** — Verify bug fixes don't break existing functionality
- **Test Data Management** — Factories, fixtures, seeds for consistent test environments
- **Handling Missing Endpoints** — When a test requires an endpoint that is not yet implemented, use mocks (MSW or jest.mock) rather than skipping. Note clearly: `[MOCKED]: /api/auth/login — implement when Backend finishes`.

#### Domain Ownership
```
/tests/unit/           — Unit tests
/tests/integration/    — Integration tests
/tests/e2e/            — End-to-end tests (Playwright)
/tests/fixtures/       — Shared test data, factories
/__tests__/            — Co-located tests (if the project uses this convention)
```

#### Skills to Install

| Skill | Source Repo | Actual Directory Name | Purpose |
|-------|------------|----------------------|---------|
| `test-master` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/test-master` | Comprehensive testing strategies, TDD |
| `webapp-testing` | [Anthropic Official](https://github.com/anthropics/skills) | `skills/webapp-testing` | Playwright E2E testing |
| `playwright-expert` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/playwright-expert` | Deep Playwright test writing |
| `security-reviewer` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/security-reviewer` | Security-focused code review |
| `lean-startup` | [Jeremy Longshore](https://github.com/jeremylongshore/claude-code-plugins-plus-skills) | via ccpi | Test critical paths, not 100% coverage |

#### Output Contract (What QA returns to Claude)

```
TEST FILES CREATED:
- tests/unit/auth.service.test.ts (12 tests)
- tests/integration/auth.api.test.ts (5 tests)

COVERAGE ADDED: auth module → 84% line coverage

TEST RUNNER USED: Jest (Vitest / Pytest — as detected from project)

MOCKED ENDPOINTS:
[MOCKED]: /api/users (not yet implemented) — using MSW mock handler

BUG FOUND:
[BUG #1] SEVERITY: Medium
Title: Login accepts empty password
Steps: POST /api/auth/login with { email: "a@b.com", password: "" }
Expected: 400 Bad Request
Actual: 200 OK with JWT token
File: src/api/auth.ts:47

⚠️ ESCALATIONS:
[ESCALATE TO CLAUDE]: No test database configured. Integration tests require a dedicated DB connection string.
```

#### Escalation Protocol
Return control to Claude when:
- Production bugs found (not test code issues)
- Security vulnerabilities discovered
- Architectural issues make testing impossible
- Missing test infrastructure (no mocking strategy, no test database, etc.)

---

### 3.5 DevOps Engineer

#### Identity
A pragmatic infrastructure engineer focused on shipping software reliably and repeatedly. Values simplicity, automation, and observability. Builds the pipes that move code from laptop to production.

#### Responsibilities
- **Containerization** — Dockerfiles, docker-compose for local dev, multi-stage builds for production
- **CI/CD Pipelines** — GitHub Actions / GitLab CI workflows for test, build, and deploy
- **Environment Management** — `.env` structure, secrets management strategy, staging vs. production separation
- **Deployment Configuration** — Hosting platform configs (Vercel, Railway, Render, AWS, GCP, DigitalOcean)
- **Database Operations** — Backup scripts, migration automation, restore procedures
- **Monitoring Setup** — Health check endpoints, error tracking (Sentry), uptime monitoring configs
- **Infrastructure as Code** — Terraform/Pulumi configs for cloud resources
- **Git Workflow** — Branch protection rules, worktree management for parallel agent work
- **Secrets Annotation** — Every config file that requires a new environment variable must include a `[REQUIRES MANUAL STEP]` annotation listing the variable name and where to set it (GitHub Secrets, cloud console, etc.)

#### Domain Ownership
```
/.github/workflows/    — CI/CD pipeline definitions
/docker/               — Dockerfiles, docker-compose files
/infra/                — Infrastructure as Code (Terraform, Pulumi)
/scripts/              — Deployment scripts, migration runners, backup scripts
/.env.example          — Environment variable template
/monitoring/           — Health checks, alerting configs
Makefile               — Common dev/ops commands (targets delegated to DevOps after init-agent-team generates the scaffold)
```

> **Makefile ownership:** `init-agent-team` generates the initial Makefile scaffold. After generation, ownership of the Makefile transfers to the DevOps Engineer. Subsequent modifications are DevOps domain.

#### Skills to Install

| Skill | Source Repo | Actual Directory Name | Purpose |
|-------|------------|----------------------|---------|
| `devops-engineer` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/devops-engineer` | CI/CD patterns, containerization, deployment |
| `terraform-engineer` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/terraform-engineer` | Infrastructure as Code |
| `monitoring-expert` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/monitoring-expert` | Observability, alerting configs |
| `manage-worktrees-skill` | [djacobsmeyer](https://github.com/djacobsmeyer/claude-skills-engineering) | `plugins/manage-worktrees-skill` ⚠️ | Git worktree management |
| `sandbox-manager` | [djacobsmeyer](https://github.com/djacobsmeyer/claude-skills-engineering) | `plugins/sandbox-manager` | Isolated environment management |
| `secure-code-guardian` | [Jeffallan](https://github.com/Jeffallan/claude-skills) | `skills/secure-code-guardian` | Secrets detection in CI |
| `lean-startup` | [Jeremy Longshore](https://github.com/jeremylongshore/claude-code-plugins-plus-skills) | via ccpi | Build the deployment pipeline you need now |

> ⚠️ **Naming warning:** The worktree skill directory is `manage-worktrees-skill` (NOT `manage-worktrees`). Copy path: `plugins/manage-worktrees-skill/`.

**Install:**
```bash
git clone https://github.com/djacobsmeyer/claude-skills-engineering /tmp/djacob-skills
cp -r /tmp/djacob-skills/plugins/manage-worktrees-skill ~/.agent-team/skills/devops-engineer/manage-worktrees-skill
cp -r /tmp/djacob-skills/plugins/sandbox-manager ~/.agent-team/skills/devops-engineer/sandbox-manager
cp -r /tmp/jeff-skills/skills/devops-engineer ~/.agent-team/skills/devops-engineer/devops-engineer
cp -r /tmp/jeff-skills/skills/terraform-engineer ~/.agent-team/skills/devops-engineer/terraform-engineer
cp -r /tmp/jeff-skills/skills/monitoring-expert ~/.agent-team/skills/devops-engineer/monitoring-expert
cp -r /tmp/jeff-skills/skills/secure-code-guardian ~/.agent-team/skills/devops-engineer/secure-code-guardian
```

#### Output Contract (What DevOps returns to Claude)

```
FILES CREATED:
- .github/workflows/deploy.yml
- docker/Dockerfile
- docker/docker-compose.yml

WHAT THIS ENABLES:
Push to main → automated tests run → Docker build → deploy to Railway

HOW TO TEST LOCALLY:
docker-compose up --build

[REQUIRES MANUAL STEP]: Add to GitHub Secrets:
  - RAILWAY_TOKEN (from railway.app dashboard)
  - DATABASE_URL (from production DB)

[COST IMPLICATION]: Railway Pro plan required for always-on instances (~$5/mo)

⚠️ ESCALATIONS:
[ESCALATE TO CLAUDE]: Multi-region deployment needed? Single region assumed.
```

#### Escalation Protocol
Return control to Claude when:
- Architecture decisions affect hosting (serverless vs. containerized, monolith vs. microservices)
- Cost-significant infrastructure changes
- Production database migrations (always escalate)
- Security policy decisions

---

### 3.6 Business Consultant

#### Identity
A sharp, data-driven business strategist and Google-powered research engine. Serves as Claude's second opinion on business decisions, product strategy, and market positioning. Challenges assumptions with real data. Invoked at project start, at major decision points, and before pivots — not on a per-feature basis.

**Key differentiator:** Gemini CLI has built-in Google Search grounding — this agent fetches real-time market data, competitor information, pricing benchmarks, and industry news.

**Rate limit note:** Using Gemini 2.5 Pro (100 RPD free), a single research session may consume 5–15 requests. Budget ~7–20 substantive research sessions per day. Reserve this for genuinely strategic questions.

#### Responsibilities
- **Market Research** — Research target markets, segment sizes, customer behavior, trends
- **Competitor Analysis** — Identify competitors, analyze their features, pricing, positioning, weaknesses
- **Pricing Strategy** — Research pricing benchmarks for SaaS, validate pricing models with data
- **Business Model Validation** — Challenge assumptions in product/pricing/go-to-market with evidence
- **Regulatory Research** — Research legal requirements, compliance standards, data privacy regulations (always ends with "Consult a lawyer" for legal specifics)
- **Technology Landscape** — Research tools, libraries, platforms — is the chosen tech the right fit?
- **Risk Assessment** — Identify business, technical, and market risks before they bite
- **Second Opinion** — Called by Claude before major decisions: "Does this make sense from a business perspective?"
- **Fact Checking** — Verify claims, statistics, and assumptions with real sources

#### Domain Ownership
```
/research/             — Market research outputs, competitor analysis docs
/docs/business/        — Business decisions, validated assumptions, ADRs (business layer)
```

#### Skills to Install

| Skill | Source Repo | Actual Directory | Purpose |
|-------|------------|-----------------|---------|
| `lean-startup` | [Jeremy Longshore](https://github.com/jeremylongshore/claude-code-plugins-plus-skills) | via ccpi | Apply Build-Measure-Learn to business questions |
| `competitive-intel` | [alirezarezvani](https://github.com/alirezarezvani/claude-skills) | `c-level-advisor/competitive-intel` | Competitive intelligence analysis |
| `ceo-advisor` | [alirezarezvani](https://github.com/alirezarezvani/claude-skills) | `c-level-advisor/ceo-advisor` | Strategic advisory, executive decision-making |
| `competitive-teardown` | [alirezarezvani](https://github.com/alirezarezvani/claude-skills) | `product-team/competitive-teardown` | Competitor feature/pricing breakdown |
| `market-researcher` | **TO BUILD** using `skill-creator` | Custom `~/.agent-team/skills/business-consultant/market-researcher/` | Structured market research methodology |

> ⚠️ **Skills correction:** The original blueprint listed `business-consultant` and `market-researcher` from alirezarezvani's repo — these directory names do NOT exist in that repo. Use the actual skill paths above. `market-researcher` must be built as a custom skill using Anthropic's `skill-creator`.

**Install:**
```bash
git clone https://github.com/alirezarezvani/claude-skills /tmp/alireza-skills
mkdir -p ~/.agent-team/skills/business-consultant
cp -r "/tmp/alireza-skills/c-level-advisor/competitive-intel" ~/.agent-team/skills/business-consultant/competitive-intel
cp -r "/tmp/alireza-skills/c-level-advisor/ceo-advisor" ~/.agent-team/skills/business-consultant/ceo-advisor
cp -r "/tmp/alireza-skills/product-team/competitive-teardown" ~/.agent-team/skills/business-consultant/competitive-teardown
# market-researcher: use skill-creator to build custom (see Appendix B)
```

#### Google Search Configuration

Gemini CLI has Google Search grounding as a built-in tool. The correct way to enable it in `settings.json` is via the `modelConfigs.customAliases` structure (not `modelAliases`):

```json
{
  "modelConfigs": {
    "customAliases": {
      "consultant": {
        "extends": "gemini-2.5-pro",
        "modelConfig": {
          "generateContentConfig": {
            "tools": [{ "googleSearch": {} }]
          }
        }
      }
    }
  }
}
```

Save this as `.gemini/settings.json` in each project, or as `~/.gemini/settings.json` for global use.

**Alternatively (simpler, no config required):** The built-in `web-search` alias already has Google Search enabled:
```bash
GEMINI_API_KEY=$GEMINI_KEY_CONSULTANT gemini -m web-search \
  -p "$(cat research_task.md)" --approval-mode=yolo
```

**Verify Google Search is active:**
```bash
GEMINI_API_KEY=$GEMINI_KEY_CONSULTANT gemini \
  -p "Search Google and tell me today's date and the current Gemini 2.5 Pro pricing per million tokens." \
  --approval-mode=yolo
# If it returns a real date and real pricing, Search is working.
```

#### Output Contract (What Business Consultant returns to Claude)
Every research output must follow this structure (max 500 words in primary findings; extended detail in appended sections):

```
QUESTION: [The specific question Claude asked]
VERDICT: Validated ✓ | Risky ⚠️ | Not Validated ✗

PRIMARY FINDINGS (≤500 words):
| Finding | Source | Date | Confidence |
|---------|--------|------|------------|
| SaaS B2B pricing median is $49/user/mo | stripe.com/atlas/guides/saas-pricing | Feb 2026 | High |

For each stat/claim:
QUOTE: "[verbatim excerpt from source supporting the claim]"
SOURCE: [URL]

WHAT I COULD NOT FIND:
- No reliable data on [X]. Marked as unverified.

RECOMMENDATION:
[1–3 sentences: what Claude should do with this information]

CONFIDENCE LEVEL: High (5+ sources) / Medium (2–4 sources) / Low (1 source or no sources)
```

#### Example Use Cases
```bash
# Before choosing a pricing model
GEMINI_API_KEY=$GEMINI_KEY_CONSULTANT gemini -m web-search \
  -p "$(cat research_pricing_model.md)" --approval-mode=yolo

# Before entering a market
GEMINI_API_KEY=$GEMINI_KEY_CONSULTANT gemini -m web-search \
  -p "What is the competitive landscape for AI-powered agency management platforms
  in Southeast Asia in 2026? Who are the main players, weaknesses, and what gap
  exists? Cite real company names and URLs." --approval-mode=yolo
```

#### Escalation Protocol
Return control to Claude when:
- A finding fundamentally changes the product direction
- Regulatory issues require legal advice (flag: "CONSULT A LAWYER — this is not legal advice")
- Market data is ambiguous or contradictory (present both sides, let Claude decide)

---

## 4. Google Account & Credential Strategy

> **v1.2 update:** Based on CTO review feedback, this section has been simplified from a 5-account strategy to a single-key approach. The original multi-account approach was flagged as high-friction and fragile (Google anti-abuse risk, IP flagging). One key is all you need to start.

### The Approach: One Key, One Account

Use **one Google account** with **one API key**. All 5 Gemini agents share the same key — differentiated by the `-m` model flag, not separate credentials.

**Why one key instead of five?**
- No incognito-window juggling across accounts
- No Google anti-abuse risk from multiple accounts on the same IP
- Free Flash tier (250 RPD) is plenty for solo sequential development
- Single credential to manage, rotate, and secure
- Upgrade path is seamless: add a credit card, same key, no code changes

### Step 1: Get Your API Key (One Time)

1. Go to [aistudio.google.com](https://aistudio.google.com)
2. Click **"Get API Key"** → **"Create API key in new project"**
3. Name the project: `agentsquad`
4. Copy the key — it will **not be shown again**
5. Paste into `~/.agent-team/.env.team` (see below)

### Step 2: Configure `.env.team`

```bash
# ~/.agent-team/.env.team — chmod 600, NEVER commit to git
# v1.2: One key shared by all agents

GEMINI_API_KEY=AIzaSy...your_key_here

# ── Optional: per-agent key overrides ────────────────────────────────────────
# Uncomment ONLY if you have separate Google accounts and want independent
# per-agent daily quotas (e.g., 250 RPD per agent instead of 250 RPD shared).
# The Makefile uses $(or $(GEMINI_KEY_BACKEND),$(GEMINI_API_KEY)) — per-agent
# keys automatically take precedence when set. No other changes needed.
#
# GEMINI_KEY_BACKEND=AIzaSy...
# GEMINI_KEY_FRONTEND=AIzaSy...
# GEMINI_KEY_QA=AIzaSy...
# GEMINI_KEY_DEVOPS=AIzaSy...
# GEMINI_KEY_CONSULTANT=AIzaSy...
# GEMINI_KEY_RESERVE_1=AIzaSy...
```

### Model Selection by Role (Free Tier, March 2026)

Each agent uses a different model via the `-m` flag — same key, different capability tier:

| Agent | Model Flag | Free RPM | Free RPD | Paid Cost (input) |
|-------|-----------|---------|---------|-------------------|
| Backend Engineer | `-m gemini-2.5-flash` | 15 | 250 | $0.15/1M tokens |
| Frontend Engineer | `-m gemini-2.5-flash` | 15 | 250 | $0.15/1M tokens |
| QA Engineer | `-m gemini-2.5-flash-lite` | 30 | 1,000 | $0.075/1M tokens |
| DevOps Engineer | `-m gemini-2.5-flash-lite` | 30 | 1,000 | $0.075/1M tokens |
| Business Consultant | `-m web-search` | 5 | 100 | $3.50/1M tokens |

> **Shared quota note:** RPD limits are shared across all agents on the same key. Flash's 250 RPD and Flash-Lite's 1,000 RPD are rarely a bottleneck for solo sequential work. Heavy parallel sprints may exhaust Flash's daily limit — upgrade to paid when that happens consistently.

### Cost Reality Check

A typical coding task uses ~5,000 input + 2,000 output tokens.

| Scenario | Tasks/Day | Est. Flash Cost/Day | Monthly |
|----------|-----------|---------------------|---------|
| Light (learning) | 20 | ~$0.04 | ~$1 |
| Normal (building) | 50 | ~$0.10 | ~$3 |
| Heavy (sprint) | 200 | ~$0.40 | ~$12 |

The engineering time saved by not fighting rate limits pays for the API cost in the first hour. When you consistently hit the 250 RPD free limit, add a credit card — set a $20/month cap for safety.

### When to Upgrade to Paid

1. Go to [aistudio.google.com](https://aistudio.google.com) → **Billing**
2. Add a payment method and set a monthly spend cap (`$20/mo` to start)
3. Same API key continues working — **no code changes needed**

### Making the Key Persistent

```bash
# Option A — Auto-source on shell start (convenient):
echo 'source ~/.agent-team/.env.team' >> ~/.zshrc

# Option B — Per-session alias (recommended for shared machines):
alias loadteam='source ~/.agent-team/.env.team'
# Run `loadteam` at the start of each work session

# Option C — direnv (per-project automation):
echo 'source ~/.agent-team/.env.team' > .envrc && direnv allow
```

### Optional Future Upgrade: Multi-Account for Higher Quotas

If you later want per-agent quota isolation (independent 250 RPD per agent), create separate Google accounts and add their keys to `.env.team`. The Makefile already handles this via `$(or $(GEMINI_KEY_BACKEND),$(GEMINI_API_KEY))` — no structural changes needed. Start simple, expand only when the limits hurt.

---

## 5. Infrastructure Layout

### Global Home: `~/.agent-team/`

```
~/.agent-team/
│
├── .gitignore                         # Protects .env.team if dir is ever git-tracked
│   # .env.team
│   # *.env
│
├── .env.team                          # 🔑 All API keys — NEVER committed
│   # GEMINI_KEY_BACKEND=AIzaSy...
│   # GEMINI_KEY_FRONTEND=AIzaSy...
│   # GEMINI_KEY_QA=AIzaSy...
│   # GEMINI_KEY_DEVOPS=AIzaSy...
│   # GEMINI_KEY_CONSULTANT=AIzaSy...
│   # GEMINI_KEY_RESERVE_1=AIzaSy...
│
├── .env.team.example                  # ✅ Template, safe to share
│
├── scripts/
│   ├── setup.sh                       # One-shot system setup
│   ├── health-check.sh                # Verify all 5 agents respond
│   ├── rotate-key.sh                  # Swap to backup on 429
│   ├── gemini-call.sh                 # Retry-with-backoff wrapper function
│   └── migrate.sh                     # Copy this dir to a new machine
│
└── skills/                            # Master skill library (source of truth)
    ├── tech-lead/
    │   ├── SKILL.md
    │   └── references/
    │       ├── delegation-guide.md    # How to write Gemini task prompts
    │       └── routing-rules.md      # When to delegate vs. handle directly
    ├── backend-engineer/
    │   ├── SKILL.md
    │   └── references/
    │       ├── api-patterns.md        # REST/GraphQL conventions
    │       ├── db-patterns.md         # Schema design patterns
    │       └── output-format.md       # The full output contract
    ├── frontend-engineer/
    │   ├── SKILL.md
    │   └── references/
    │       ├── component-patterns.md  # Component structure conventions
    │       ├── state-patterns.md      # State management patterns
    │       └── output-format.md
    ├── qa-engineer/
    │   ├── SKILL.md
    │   └── references/
    │       ├── testing-strategy.md    # What to test, in what order
    │       ├── bug-report-template.md # Exact bug report format
    │       └── output-format.md
    ├── devops-engineer/
    │   ├── SKILL.md
    │   └── references/
    │       ├── ci-cd-patterns.md      # GitHub Actions patterns
    │       ├── docker-patterns.md     # Multi-stage build templates
    │       └── output-format.md
    └── business-consultant/
        ├── SKILL.md
        └── references/
            ├── research-framework.md  # How to structure research queries
            ├── lean-canvas.md         # Lean Canvas template for analysis
            └── output-format.md       # The full output contract with quote requirement
```

### Personal Claude Skills: `~/.claude/skills/`

```
~/.claude/skills/
├── lean-startup/
├── skill-creator/
├── mcp-builder/
├── technical-writer/
├── prompt-architect/
├── frontend-design/
├── webapp-testing/
├── performance-optimization/
├── database-design/
└── init-agent-team/            # ⭐ Built by this project
    ├── SKILL.md
    └── templates/
        ├── CLAUDE.md.template
        ├── TEAM.md.template
        ├── Makefile.template
        └── settings.json.template
```

### Per-Project Layout (generated by `init-agent-team`)

```
<your-project>/
├── CLAUDE.md                      # Team configuration
├── TEAM.md                        # Human-readable team charter
├── Makefile                       # Developer convenience commands
├── agent-output/                  # Gemini output files (gitignored)
│   └── .gitkeep
│
├── api-contracts/                 # API contract docs (authored by Claude)
│   └── .gitkeep
│
├── research/                      # Business Consultant outputs (optional gitignore)
│   └── .gitkeep
│
├── .claude/
│   └── skills/                   # Project-specific skill overrides (optional)
│
├── .gemini/
│   ├── settings.json              # Model aliases, Google Search config
│   └── skills/                   # Symlinked or copied from ~/.agent-team/skills/
│
└── scripts/
    └── start-team.sh             # Project-specific wrapper with env loading
```

---

## 6. Skills Architecture

### The Skill Format (SKILL.md)

Both Claude Code and Gemini CLI use a shared open standard ([agentskills.io](https://agentskills.io)). The core format is identical; some extended frontmatter fields differ per platform.

**Required frontmatter fields:**

```markdown
---
name: backend-engineer          # Must match parent directory name exactly
version: 1.0.0                  # Track changes via semver
description: Activate when implementing server-side code, APIs, database
             schemas, migrations, or backend integrations. Do not activate
             for frontend components, deployment configs, or business research.
             Max 1024 characters.
---
```

**Full SKILL.md body structure:**

```markdown
# Role Title

## Identity
[Who this agent is. 2–3 sentences on personality, approach, working style.]

## Responsibilities
[Bulleted list of what this agent handles]

## Process
When given a task:
1. Read the api-contract.md or task file Claude provided
2. Check existing code patterns before writing new code
3. [role-specific steps...]

## Output Contract
> ⚠️ OUTPUT RULE: No preamble. No "Here is the code." Start immediately with
> DEPENDENCIES NEEDED (if any), then file content or the structured output block.

Always return in this exact format:
[paste the output contract block for this role]

## Escalation Triggers
Return control to Claude (using the escalation format below) when:
- [trigger 1]
- [trigger 2]

## Escalation Format
ESCALATION: [one-sentence summary of the trigger]
FILE: [file path being worked on]
DECISION NEEDED: [specific question Claude must answer]
CONTEXT: [what has been done so far]
OPTIONS: [2–3 possible approaches if applicable]

## References
- See references/output-format.md for the full output format
- See references/api-patterns.md for REST conventions
```

### Complete Example: `backend-engineer/SKILL.md`

```markdown
---
name: backend-engineer
version: 1.0.0
description: Activate when implementing server-side code including REST or GraphQL
             API endpoints, database schemas, migrations, business logic services,
             third-party integrations, or backend middleware. Do not activate for
             frontend UI components, Makefile targets, CI/CD pipelines, or
             business/market research.
---

# Backend Engineer

## Identity
You are a senior backend engineer with 8+ years of experience building scalable
server-side systems. You write clean, well-documented code that other engineers
can maintain. You follow the principle of least surprise: your APIs do exactly
what their names suggest. You never introduce a new external dependency without
flagging it as an escalation.

## Responsibilities
- REST and GraphQL API endpoints following the api-contract.md Claude provides
- Database schema design, migrations, and seed data
- Service layer business logic
- Input validation (zod, joi, or framework-native)
- Error handling with consistent error shapes
- Third-party integrations (Stripe, SendGrid, S3, etc.)
- OpenAPI/Swagger documentation generation
- API-level TypeScript types in /src/types/api/

## Process
When given a task:
0. **Pre-declare dependencies:** If the task requires packages NOT already in
   package.json / requirements.txt, list them as a DEPENDENCIES NEEDED block
   FIRST — before writing any code. Format:
   ```
   DEPENDENCIES NEEDED:
   - bcryptjs@2.4.3 (password hashing)
   - zod@3.22.0 (input validation)
   ```
   Then proceed with implementation. This prevents mid-task surprises.
1. Read the api-contract.md or task file Claude provided FIRST
2. Scan existing code: check /src/api/, /src/services/, /src/db/ for patterns
3. Match code style of existing files (naming, folder structure, import style)
4. Implement validation BEFORE business logic
5. Implement error handling for every code path (not just the happy path)
6. Write JSDoc for every exported function
7. Return the output contract block

## Output Contract
> ⚠️ **OUTPUT RULE:** Begin your response IMMEDIATELY with the DEPENDENCIES NEEDED
> block (if any), then the first file content. NO preamble. NO "Here is the code
> you requested." NO "Certainly!" NO conversational intro. The first line of your
> response after any DEPENDENCIES NEEDED block must be actual code or a file header.

Always return in exactly this format at the end of your response:

FILES MODIFIED:
- [path] (created | modified | deleted)

SUMMARY:
[2–3 sentences: what was implemented and how]

ERROR SHAPE:
{ "error": "ERROR_CODE", "message": "Human-readable message", "status": 4xx }

DEPENDENCIES ADDED:
- [package]@[version] ([reason]) — or "none"

⚠️ ESCALATIONS:
[List any [ESCALATE TO CLAUDE] items, or "none"]

## Escalation Triggers
Return control to Claude when:
- Schema changes affect existing production data (destructive migrations)
- A new external service dependency is needed
- Authentication or authorization design is ambiguous
- The api-contract.md is missing, unclear, or contradictory
- Multi-service transactions span more than one service file

## Escalation Format
ESCALATION: [one-sentence summary]
FILE: [file being worked on]
DECISION NEEDED: [specific question for Claude]
CONTEXT: [what has been done so far]
OPTIONS:
  A) [approach 1]
  B) [approach 2]

## References
- See references/api-patterns.md for REST conventions used in this project
- See references/db-patterns.md for schema design patterns
- See references/output-format.md for the full output format with examples
```

### Skill Installation Summary

```bash
# 1. Clone all source repos
git clone https://github.com/anthropics/skills /tmp/anthropic-skills
git clone https://github.com/Jeffallan/claude-skills /tmp/jeff-skills
git clone https://github.com/djacobsmeyer/claude-skills-engineering /tmp/djacob-skills
git clone https://github.com/alirezarezvani/claude-skills /tmp/alireza-skills

# 2. Install ccpi and lean-startup
pnpm add -g @intentsolutionsio/ccpi
ccpi install lean-startup   # Installs to ~/.claude/skills/lean-startup/

# 3. Symlink agent-team skills into personal Gemini skills
mkdir -p ~/.gemini/skills
for role in backend-engineer frontend-engineer qa-engineer devops-engineer business-consultant tech-lead; do
  ln -sf ~/.agent-team/skills/$role ~/.gemini/skills/$role 2>/dev/null \
    || cp -r ~/.agent-team/skills/$role ~/.gemini/skills/$role
done
```

---

## 7. Communication & Workflow Patterns

### Pattern A: Sequential Delegation (dependency chain)

```
Claude → task-1.md → Gemini Backend → agent-output/auth-endpoint.ts
  ↓ Claude reviews
Claude → task-2.md (includes agent-output/auth-endpoint.ts) → Gemini QA → agent-output/auth-tests.ts
  ↓ Claude reviews + integrates both
```

### Pattern B: Parallel Dispatch (independent domains)

> **Single-key tip:** The `${GEMINI_KEY_*:-$GEMINI_API_KEY}` expansion works for both setups — if a per-agent key is set it's used; otherwise falls back to the shared `GEMINI_API_KEY`. Or just use `make backend TASK="..."` which handles this automatically.

```bash
# Dispatch 3 independent tasks simultaneously
GEMINI_API_KEY=${GEMINI_KEY_BACKEND:-$GEMINI_API_KEY} \
  gemini -m gemini-2.5-flash -p "$(cat agent-output/task-backend.md)" --approval-mode=yolo \
  > agent-output/backend-out.ts & PIDS=($!)

GEMINI_API_KEY=${GEMINI_KEY_FRONTEND:-$GEMINI_API_KEY} \
  gemini -m gemini-2.5-flash -p "$(cat agent-output/task-frontend.md)" --approval-mode=yolo \
  > agent-output/frontend-out.tsx & PIDS+=($!)

GEMINI_API_KEY=${GEMINI_KEY_QA:-$GEMINI_API_KEY} \
  gemini -m gemini-2.5-flash-lite -p "$(cat agent-output/task-tests.md)" --approval-mode=yolo \
  > agent-output/tests-out.ts & PIDS+=($!)

# Wait and check each exit code
for pid in "${PIDS[@]}"; do
  wait "$pid" || echo "⚠️ Agent process $pid failed — check output file"
done
echo "All agents complete. Reviewing agent-output/..."
```

> **Output file convention:** All Gemini output goes to `./agent-output/` (project-local, gitignored). Use the naming pattern: `{agent}-{feature}-{timestamp}.{ext}` e.g., `backend-auth-1741234567.ts`.

### Pattern C: Research + Build (strategic decision first)

```
Claude → research task → Business Consultant (Google Search) → agent-output/research-billing.md
  ↓ Claude reads findings, makes decision
Claude → implementation task → Backend / Frontend agents
```

### Pattern D: Git Worktree Isolation (large parallel features)

```bash
# Create isolated branches for conflicting features
git worktree add agent-output/worktrees/feature-auth feature/auth
git worktree add agent-output/worktrees/feature-billing feature/billing

# Each agent works in its own worktree (parallel, no file conflicts)
GEMINI_API_KEY=$GEMINI_KEY_BACKEND \
  gemini -p "Work in agent-output/worktrees/feature-auth. $(cat task-auth.md)" \
  --approval-mode=yolo > agent-output/auth-summary.md &

# Claude merges worktrees when both done
git worktree remove agent-output/worktrees/feature-auth
```

> **Note on `git worktree add` syntax:** `git worktree add <path> <branch>` requires the branch to already exist. To create a new branch: `git worktree add -b feature/auth agent-output/worktrees/feature-auth`.

### Auth Feature Handoff Pattern (Security-Sensitive Sequential)

Because auth spans Backend and Frontend with security implications, always use this explicit sequential flow:

```
1. Claude authors api-contracts/auth-api-contract.md
   (endpoint paths, JWT structure, error codes, token expiry)

2. Claude → Backend Engineer: "Implement auth endpoints per api-contracts/auth-api-contract.md"
   ↓ Backend returns: agent-output/backend-auth.ts

3. Claude reviews agent-output/backend-auth.ts (security review)

4. Claude → Frontend Engineer: "Implement login form per api-contracts/auth-api-contract.md
   and using token structure from agent-output/backend-auth.ts (attached below)"
   ↓ Frontend returns: agent-output/frontend-auth-form.tsx

5. Claude reviews and integrates both
```

---

## 8. Day-to-Day Workflow

### Starting a Work Session

```bash
# 1. Load credentials
source ~/.agent-team/.env.team

# 2. Verify team is healthy
~/.agent-team/scripts/health-check.sh

# 3. Open Claude Code in project
claude

# 4. Run init-agent-team if new project
# In Claude Code: /init-agent-team
```

### Dispatching a Feature (Full Example)

**You say to Claude:** "Add a subscription billing system with Stripe."

**Claude's internal plan:**
```
1. Research (Business Consultant) — What's the standard SaaS billing model in 2026?
2. Architecture (Claude) — Multi-tenant subscription design, Stripe webhook strategy
3. API Contract (Claude) — Write api-contracts/billing-api-contract.md
4. Parallel: DB schema (Backend) + Billing UI scaffold (Frontend)
5. Sequential: Stripe webhook handler (Backend) — security, Claude handles this
6. Sequential: Tests for billing API (QA)
7. DevOps: Add STRIPE_SECRET_KEY to .env.example and CI secrets
8. Integration + review (Claude)
```

**Claude executes via bash:**
```bash
# Step 1: Research
# (${VAR:-$GEMINI_API_KEY} works for both single-key and multi-key setups)
GEMINI_API_KEY=${GEMINI_KEY_CONSULTANT:-$GEMINI_API_KEY} gemini -m web-search \
  -p "What is the standard billing model for B2B SaaS in 2026? Per-seat vs flat-rate?
  What price points are common? Cite real companies and URLs." \
  --approval-mode=yolo > agent-output/research-billing.md

# Step 2–3: Claude reads research, designs architecture, writes api-contract

# Step 4: Parallel dispatch
GEMINI_API_KEY=${GEMINI_KEY_BACKEND:-$GEMINI_API_KEY} \
  gemini -m gemini-2.5-flash -p "$(cat agent-output/task-billing-schema.md)" \
  --approval-mode=yolo > agent-output/backend-billing-schema.sql & PIDS=($!)

GEMINI_API_KEY=${GEMINI_KEY_FRONTEND:-$GEMINI_API_KEY} \
  gemini -m gemini-2.5-flash -p "$(cat agent-output/task-billing-ui.md)" \
  --approval-mode=yolo > agent-output/frontend-billing-ui.tsx & PIDS+=($!)

for pid in "${PIDS[@]}"; do wait "$pid" || echo "⚠️ process $pid failed"; done

# Step 5: Tests (sequential, depends on schema)
GEMINI_API_KEY=${GEMINI_KEY_QA:-$GEMINI_API_KEY} \
  gemini -m gemini-2.5-flash-lite \
  -p "Write tests for this billing schema: $(cat agent-output/backend-billing-schema.sql)
  Using project conventions: $(cat tests/CONVENTIONS.md)" \
  --approval-mode=yolo > agent-output/tests-billing.ts

# Step 7: DevOps config
GEMINI_API_KEY=${GEMINI_KEY_DEVOPS:-$GEMINI_API_KEY} \
  gemini -m gemini-2.5-flash-lite \
  -p "Add STRIPE_SECRET_KEY and STRIPE_WEBHOOK_SECRET to .env.example,
  add them as required secrets to .github/workflows/deploy.yml, and create a
  GitHub Actions step that validates the secrets are set." \
  --approval-mode=yolo > agent-output/devops-stripe-config.md

# Step 8: Claude reviews all outputs, integrates, and commits
# Tip: run `make backend TASK="..."` for a cleaner interface — same result.
```

---

## 9. Project Bootstrapping: `init-agent-team` Skill

### SKILL.md for `init-agent-team`

```markdown
---
name: init-agent-team
version: 1.0.0
description: Bootstrap the AgentSquad multi-agent team for a new project repository.
             Activate when the user says "set up the agent team", "init agent team",
             "bootstrap the team", or runs /init-agent-team. Generates CLAUDE.md,
             TEAM.md, Makefile, .gemini/settings.json, and .claude/skills/ symlinks.
             Requires ~/.agent-team/ to be set up (run setup.sh first if not done).
---

# init-agent-team

## Identity
You are a team configuration specialist. When activated, you analyze a new project,
ask 3 targeted questions, and generate all files needed to spin up the AgentSquad
team. You are systematic and produce complete, copy-paste-ready output.

## Process

### Step 1: Detect project context
Read these files if they exist: package.json, requirements.txt, go.mod, Cargo.toml,
pom.xml, build.gradle, composer.json, pubspec.yaml, mix.exs.
Read the root directory listing.
Infer: language, framework, type of project (SaaS, API, CLI, etc.).

### Step 2: Ask exactly these 3 questions in one message
"Before I set up the team, I need 3 quick answers:

1. **Product type**: SaaS platform / Agency platform / REST API service / Other: ___
2. **Tech stack** (confirm or correct): [paste detected stack]
3. **Active agents**: All 6 / Skip DevOps (add later) / Skip Consultant (research only when needed)

Reply with your answers and I'll generate everything."

### Step 3: Generate all files

Generate in this exact order:
1. `CLAUDE.md` — using CLAUDE.md.template, substituting all {{VARIABLES}}
2. `TEAM.md` — using TEAM.md.template
3. `Makefile` — using Makefile.template (substituting agent key names and model names)
4. `.gemini/settings.json` — using settings.json.template
5. `agent-output/.gitkeep` and `api-contracts/.gitkeep` and `research/.gitkeep`
6. Symlink or copy `.gemini/skills/` from `~/.agent-team/skills/`

### Step 4: Verify setup
Run in bash:
  source ~/.agent-team/.env.team && ~/.agent-team/scripts/health-check.sh

Report results to the user.

## Output Contract
After generating all files, summarize:
"✅ Team is ready. Generated:
- CLAUDE.md (team config, routing rules)
- TEAM.md (team charter)
- Makefile (agent dispatch commands)
- .gemini/settings.json (model config)
- agent-output/, api-contracts/, research/ directories (gitignored)
- Skills symlinked into .gemini/skills/

Health check: [PASS / FAIL — list which agents responded]

Next steps:
1. Review CLAUDE.md and adjust domain boundaries if needed
2. Try: make consult TASK='Research our target market'
3. Try: make backend TASK='Scaffold the initial API structure'"
```

---

## 10. Script Specifications

### `setup.sh` — Full Implementation Outline

```bash
#!/usr/bin/env bash
# AgentSquad Setup Script
# Installs gemini-cli, verifies structure, and runs health check.

set -e

# ── 1. OS Detection ──────────────────────────────────────────────────────────
OS=$(uname -s)
case $OS in
  Darwin) echo "✅ Detected: macOS" ;;
  Linux)  echo "✅ Detected: Linux" ;;
  *)      echo "❌ Unsupported OS: $OS. Use macOS or Linux (WSL2 on Windows)." && exit 1 ;;
esac

# ── 2. Check bash version (macOS ships bash 3.2 — warn) ──────────────────────
BASH_MAJOR=${BASH_VERSINFO[0]}
if [[ $BASH_MAJOR -lt 4 ]]; then
  echo "⚠️  bash $BASH_VERSION detected. Some features may not work."
  echo "   On macOS: brew install bash && chsh -s /opt/homebrew/bin/bash"
fi

# ── 3. Check Node.js >= 18 ───────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo "❌ Node.js not found. Install from https://nodejs.org (v18+)" && exit 1
fi
NODE_MAJOR=$(node -e "console.log(process.versions.node.split('.')[0])")
if [[ $NODE_MAJOR -lt 18 ]]; then
  echo "❌ Node.js $NODE_MAJOR found. Node.js >= 18 required." && exit 1
fi
echo "✅ Node.js $(node --version)"

# ── 4. Check GNU Make ────────────────────────────────────────────────────────
if ! make --version 2>&1 | grep -q "GNU"; then
  echo "⚠️  GNU Make not found. On macOS: brew install make (then use gmake)"
fi

# ── 5. Install gemini-cli if missing ────────────────────────────────────────
if ! command -v gemini &>/dev/null; then
  echo "Installing @google/gemini-cli..."
  npm install -g @google/gemini-cli
else
  echo "✅ gemini $(gemini --version 2>/dev/null || echo '(version unknown)')"
fi

# ── 6. Create ~/.agent-team/ structure ──────────────────────────────────────
mkdir -p ~/.agent-team/scripts
mkdir -p ~/.agent-team/skills/{tech-lead,backend-engineer,frontend-engineer,qa-engineer,devops-engineer,business-consultant}/{,references}
echo "✅ ~/.agent-team/ structure created"

# ── 7. Create .gitignore inside ~/.agent-team/ ───────────────────────────────
cat > ~/.agent-team/.gitignore <<'EOF'
.env.team
*.env
EOF
echo "✅ ~/.agent-team/.gitignore created"

# ── 8. Set up .env.team if it doesn't exist ──────────────────────────────────
if [[ ! -f ~/.agent-team/.env.team ]]; then
  cp "$(dirname "$0")/../.env.team.example" ~/.agent-team/.env.team 2>/dev/null \
    || cat > ~/.agent-team/.env.team <<'EOF'
# AgentSquad credentials — v1.2 single-key setup
# Get your key at: aistudio.google.com → Get API Key
GEMINI_API_KEY=your_key_here

# Optional: per-agent key overrides for independent quota pools.
# Uncomment and fill ONLY if using separate Google accounts per agent.
# GEMINI_KEY_BACKEND=your_key_here
# GEMINI_KEY_FRONTEND=your_key_here
# GEMINI_KEY_QA=your_key_here
# GEMINI_KEY_DEVOPS=your_key_here
# GEMINI_KEY_CONSULTANT=your_key_here
# GEMINI_KEY_RESERVE_1=your_key_here
EOF
  chmod 600 ~/.agent-team/.env.team
  echo "✅ ~/.agent-team/.env.team created — set GEMINI_API_KEY from aistudio.google.com"
else
  echo "✅ ~/.agent-team/.env.team already exists (not overwritten)"
fi

# ── 9. Make all scripts executable ───────────────────────────────────────────
chmod +x ~/.agent-team/scripts/*.sh 2>/dev/null || true
echo "✅ Scripts made executable"

# ── 10. Symlink skills into ~/.gemini/skills/ ────────────────────────────────
mkdir -p ~/.gemini/skills
for role in backend-engineer frontend-engineer qa-engineer devops-engineer business-consultant tech-lead; do
  target="$HOME/.gemini/skills/$role"
  source="$HOME/.agent-team/skills/$role"
  if [[ ! -e "$target" ]]; then
    ln -s "$source" "$target" 2>/dev/null \
      || cp -r "$source" "$target"
    echo "✅ Linked skill: $role"
  fi
done

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.agent-team/.env.team — set GEMINI_API_KEY from aistudio.google.com"
echo "  2. Add to your shell: source ~/.agent-team/.env.team"
echo "  3. Run: ~/.agent-team/scripts/health-check.sh"
```

### `health-check.sh` — Full Implementation Outline

```bash
#!/usr/bin/env bash
# Verify all agents are responding and not rate-limited.

source ~/.agent-team/.env.team 2>/dev/null || {
  echo "❌ ~/.agent-team/.env.team not found. Run setup.sh first." && exit 1
}

# v1.2: per-agent keys fall back to GEMINI_API_KEY if not individually set
declare -A AGENTS=(
  [Backend]="${GEMINI_KEY_BACKEND:-$GEMINI_API_KEY}"
  [Frontend]="${GEMINI_KEY_FRONTEND:-$GEMINI_API_KEY}"
  [QA]="${GEMINI_KEY_QA:-$GEMINI_API_KEY}"
  [DevOps]="${GEMINI_KEY_DEVOPS:-$GEMINI_API_KEY}"
  [Consultant]="${GEMINI_KEY_CONSULTANT:-$GEMINI_API_KEY}"
)

ALL_PASS=true

for name in "${!AGENTS[@]}"; do
  key="${AGENTS[$name]}"
  if [[ -z "$key" || "$key" == "your_key_here" ]]; then
    echo "⚠️  $name: Key not set"
    ALL_PASS=false
    continue
  fi

  response=$(GEMINI_API_KEY="$key" gemini -p "Reply with exactly: OK" \
    --approval-mode=yolo 2>&1)

  if echo "$response" | grep -qi "OK"; then
    echo "✅ $name: Responding"
  elif echo "$response" | grep -q "429"; then
    echo "⚠️  $name: Rate limited (try again in a few minutes)"
    ALL_PASS=false
  elif echo "$response" | grep -qiE "401|403|invalid.*key"; then
    echo "❌ $name: Invalid API key"
    ALL_PASS=false
  else
    echo "❌ $name: Unexpected response — ${response:0:100}"
    ALL_PASS=false
  fi
done

echo ""
if $ALL_PASS; then
  echo "✅ All agents healthy."
else
  echo "⚠️  Some agents need attention. Check .env.team keys."
fi
```

### `gemini-call.sh` — Full Sourceable Script

```bash
#!/usr/bin/env bash
# Sourceable retry wrapper for Gemini CLI calls with automatic filler stripping.
# Usage: source ~/.agent-team/scripts/gemini-call.sh
#        call_gemini "$GEMINI_API_KEY" "prompt text" "agent-output/output.ts"
#        call_gemini "$GEMINI_API_KEY" "prompt text" "agent-output/output.ts" "gemini-2.5-flash"
#
# v1.2: Uses GEMINI_API_KEY (single shared key) by default.
#        Pass any key as $1 if using per-agent key overrides.

# Load strip_filler if available
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -f "$_SCRIPT_DIR/strip-filler.sh" ]] && source "$_SCRIPT_DIR/strip-filler.sh"

call_gemini() {
  local key="$1"
  local prompt="$2"
  local output_file="$3"
  local model="${4:-}"   # Optional: model name e.g. "gemini-2.5-flash"

  local model_flag=""
  [[ -n "$model" ]] && model_flag="-m $model"

  for attempt in 1 2 3; do
    local result
    result=$(GEMINI_API_KEY="$key" gemini $model_flag \
      -p "$prompt" --approval-mode=yolo 2>&1)
    local exit_code=$?

    if [[ $exit_code -eq 0 ]] && [[ -n "$result" ]]; then
      # Write raw output, then strip conversational filler
      local raw_file="${output_file}.raw"
      echo "$result" > "$raw_file"
      if declare -f strip_filler > /dev/null 2>&1; then
        strip_filler "$raw_file" "$output_file"
        rm -f "$raw_file"
      else
        mv "$raw_file" "$output_file"
      fi

      # v1.3: Escalation detector — alert immediately if agent flagged a decision
      if grep -q "\[ESCALATE TO CLAUDE\]" "$output_file" 2>/dev/null; then
        echo ""
        echo "🚨 $(tput bold 2>/dev/null)ESCALATION REQUIRED$(tput sgr0 2>/dev/null) — agent flagged a decision in: $output_file"
        echo "   Search for [ESCALATE TO CLAUDE] and resolve before integrating."
        echo ""
      fi

      return 0

    elif echo "$result" | grep -q "429"; then
      echo "⚠️  Rate limit (attempt $attempt/3). Waiting $((attempt * 15))s..."
      sleep $((attempt * 15))
      # On 3rd attempt, try reserve key if available (works with single-key or multi-key setups)
      [[ $attempt -eq 2 ]] && key="${GEMINI_KEY_RESERVE_1:-${GEMINI_API_KEY:-$key}}"

    elif echo "$result" | grep -qiE "401|403|invalid.*api.*key"; then
      echo "❌ Invalid API key. Check ~/.agent-team/.env.team."
      return 1

    elif echo "$result" | grep -qiE "500|503|server.*error"; then
      echo "⚠️  Server error (attempt $attempt/3). Waiting $((attempt * 5))s..."
      sleep $((attempt * 5))

    else
      echo "❌ Unexpected error: ${result:0:200}"
      return 1
    fi
  done

  echo "❌ All 3 attempts failed for this agent."
  return 1
}
```

### `strip-filler.sh` — LLM Output Cleaner

```bash
#!/usr/bin/env bash
# strip-filler.sh — Remove LLM conversational preamble from Gemini output.
# Source this file to get the strip_filler function, or call directly.
#
# Problem: LLMs inject filler like "Here is the code you requested:" before
#          the actual content, which breaks bash pipes and file reads.
# Strategy 1: If output has markdown code blocks (```), extract only block contents.
# Strategy 2: If no code blocks, strip leading lines matching common filler patterns.
#
# Usage:
#   source ~/.agent-team/scripts/strip-filler.sh
#   strip_filler agent-output/raw.md agent-output/clean.ts
#
#   Or pipe:
#   gemini -p "..." | strip_filler_stdin > agent-output/clean.ts

strip_filler() {
  local input_file="$1"
  local output_file="$2"

  if [[ -z "$input_file" || -z "$output_file" ]]; then
    echo "Usage: strip_filler <input_file> <output_file>" && return 1
  fi
  if [[ ! -f "$input_file" ]]; then
    echo "❌ strip_filler: File not found: $input_file" && return 1
  fi

  # Strategy 1: extract content inside ALL code blocks and concatenate them.
  # v1.3 fix: changed `exit` → `next` on closing fence so multiple blocks are
  # captured (e.g. imports block + main function block). Explanation text between
  # blocks is silently dropped since in_block is false during those lines.
  if grep -q '^\`\`\`' "$input_file"; then
    awk '/^\`\`\`/{
      if (!in_block) { in_block=1; next }   # opening fence — start capturing
      else { in_block=0; next }             # closing fence — end this block, keep going
    }
    in_block { print }' "$input_file" > "$output_file"
  else
    # Strategy 2: strip known preamble patterns from the top of the file
    sed '/^[[:space:]]*$/d' "$input_file" | \
    grep -v -iE \
      "^(here is|here'?s|certainly!?|of course|sure[,!]|below is|the following|as requested|happy to)" \
    > "$output_file"
  fi

  # Safety net: if stripping produced an empty file, keep the original
  if [[ ! -s "$output_file" ]]; then
    cp "$input_file" "$output_file"
    echo "⚠️  strip_filler: Stripping produced empty output — keeping original." >&2
  fi
}

# Stdin convenience wrapper
strip_filler_stdin() {
  local tmp_in tmp_out
  tmp_in=$(mktemp /tmp/sf-in.XXXXXX)
  tmp_out=$(mktemp /tmp/sf-out.XXXXXX)
  cat > "$tmp_in"
  strip_filler "$tmp_in" "$tmp_out"
  cat "$tmp_out"
  rm -f "$tmp_in" "$tmp_out"
}
```

> **When to use:** Call after every `gemini-call.sh` invocation when the output is being piped into the next agent or read programmatically. For interactive review (where you read the output yourself), stripping is optional — the filler is harmless to human eyes.

---

### `migrate.sh` — Machine Migration Outline

```bash
#!/usr/bin/env bash
# Migrate ~/.agent-team/ to a new machine via rsync.
# Usage: ./migrate.sh user@new-machine.local

TARGET="$1"
if [[ -z "$TARGET" ]]; then
  echo "Usage: ./migrate.sh user@hostname" && exit 1
fi

echo "Migrating ~/.agent-team/ to $TARGET..."

# Sync everything except .env.team (copy manually for security)
rsync -avz --exclude='.env.team' ~/.agent-team/ "$TARGET:~/.agent-team/"

echo ""
echo "⚠️  .env.team was NOT transferred (security). Transfer it manually:"
echo "   scp ~/.agent-team/.env.team $TARGET:~/.agent-team/.env.team"
echo "   Then on the new machine: chmod 600 ~/.agent-team/.env.team"
echo ""
echo "On the new machine, also run:"
echo "   ~/.agent-team/scripts/setup.sh"
echo "   ~/.agent-team/scripts/health-check.sh"
```

---

## 11. Templates

### `CLAUDE.md.template`

```markdown
# {{PROJECT_NAME}} — Team Configuration
> Generated by init-agent-team v{{AGENTSQUAD_VERSION}} on {{DATE}}
> Tech stack: {{TECH_STACK}}

---

## Team Roster

| Agent | Role | API Key Variable | Model |
|-------|------|-----------------|-------|
| Claude Code (you) | Tech Founder / Head | Anthropic Pro | Latest Claude |
| Backend Engineer | APIs, DB, Services | GEMINI_KEY_BACKEND | gemini-2.5-flash |
| Frontend Engineer | UI, Components | GEMINI_KEY_FRONTEND | gemini-2.5-flash |
| QA Engineer | Testing, Quality | GEMINI_KEY_QA | gemini-2.5-flash-lite |
| DevOps Engineer | CI/CD, Infrastructure | GEMINI_KEY_DEVOPS | gemini-2.5-flash-lite |
| Business Consultant | Research, Strategy | GEMINI_KEY_CONSULTANT | gemini-2.5-pro |

---

## Domain Boundaries

| Domain | Owner | Directories |
|--------|-------|-------------|
| API Routes & Handlers | Backend Engineer | {{BACKEND_DIRS}} |
| Database Models & Migrations | Backend Engineer | {{DB_DIRS}} |
| API TypeScript Types | Backend Engineer | /src/types/api/ |
| UI Components & Pages | Frontend Engineer | {{FRONTEND_DIRS}} |
| UI TypeScript Types | Frontend Engineer | /src/types/ui/ |
| Shared Types | **Claude only** | /src/types/shared/ |
| Test Suite | QA Engineer | {{TEST_DIRS}} |
| CI/CD & Infrastructure | DevOps Engineer | /.github/workflows/, /docker/, /infra/ |
| API Contracts | **Claude only** | /api-contracts/ |
| Business Research | Business Consultant | /research/ |

---

## Verification Commands

```bash
# Run all tests
{{TEST_COMMAND}}

# Build
{{BUILD_COMMAND}}

# Lint
{{LINT_COMMAND}}

# Type check
{{TYPECHECK_COMMAND}}

# Start dev server
{{DEV_COMMAND}}
```

---

## Delegation Rules

**Always delegate to Gemini agents:**
- CRUD endpoint implementations (use Backend Engineer)
- Repetitive component creation (use Frontend Engineer)
- Test file writing for completed code (use QA Engineer)
- Docker/CI config files (use DevOps Engineer)
- Market research or competitor analysis (use Business Consultant)

**Always handle yourself (Claude):**
- System design and architecture decisions
- API contract authoring (goes in /api-contracts/ before implementation)
- Security-sensitive code (auth, payments)
- Cross-domain type definitions (/src/types/shared/)
- Final integration and review of all Gemini outputs
- Anything an agent escalates back

**Dispatch guidelines:**
- Parallel: tasks in different domains with no shared files
- Sequential: when task B needs task A's output
- Research first: use Business Consultant before major feature or architecture decisions
- **Parallel integration rule:** Before integrating any parallel outputs, verify ALL expected files exist in `agent-output/` and were written in the current session (`ls -lt agent-output/`). If any parallel job failed or is missing, re-run it first. Never integrate partial results from a broken parallel run.

---

## Agent Quick Commands

```bash
# Source team credentials (run at start of session)
source ~/.agent-team/.env.team

# Individual dispatches
make backend TASK="your task description here"
make frontend TASK="your task description here"
make qa TASK="your task description here"
make devops TASK="your task description here"
make consult TASK="your research question here"

# Health check
make team-health
```
```

### `Makefile.template`

```makefile
# AgentSquad Makefile — Generated by init-agent-team
# Ownership: init-agent-team generates this scaffold;
# DevOps Engineer owns it after generation.
# Requires: GNU Make (on macOS: brew install make, then use gmake)
#
# v1.2 KEY STRATEGY: All agents share GEMINI_API_KEY by default.
# Per-agent keys (GEMINI_KEY_BACKEND etc.) override when set in .env.team.
# To add per-agent isolation later: uncomment keys in .env.team — no Makefile changes needed.

-include ~/.agent-team/.env.team
export

GEMINI_FLAGS := --approval-mode=yolo
OUTPUT_DIR   := agent-output

# Key resolution: per-agent key takes precedence over shared key
BACKEND_KEY  := $(or $(GEMINI_KEY_BACKEND),$(GEMINI_API_KEY))
FRONTEND_KEY := $(or $(GEMINI_KEY_FRONTEND),$(GEMINI_API_KEY))
QA_KEY       := $(or $(GEMINI_KEY_QA),$(GEMINI_API_KEY))
DEVOPS_KEY   := $(or $(GEMINI_KEY_DEVOPS),$(GEMINI_API_KEY))
CONSULT_KEY  := $(or $(GEMINI_KEY_CONSULTANT),$(GEMINI_API_KEY))

.PHONY: backend frontend qa devops consult team-health clean-output help

backend: ## Dispatch task to Backend Engineer (gemini-2.5-flash)
	@mkdir -p $(OUTPUT_DIR)
	@GEMINI_API_KEY=$(BACKEND_KEY) \
	  gemini -m gemini-2.5-flash -p "$(TASK)" $(GEMINI_FLAGS) \
	  | tee $(OUTPUT_DIR)/backend-$(shell date +%s).md

frontend: ## Dispatch task to Frontend Engineer (gemini-2.5-flash)
	@mkdir -p $(OUTPUT_DIR)
	@GEMINI_API_KEY=$(FRONTEND_KEY) \
	  gemini -m gemini-2.5-flash -p "$(TASK)" $(GEMINI_FLAGS) \
	  | tee $(OUTPUT_DIR)/frontend-$(shell date +%s).md

qa: ## Dispatch task to QA Engineer (gemini-2.5-flash-lite)
	@mkdir -p $(OUTPUT_DIR)
	@GEMINI_API_KEY=$(QA_KEY) \
	  gemini -m gemini-2.5-flash-lite -p "$(TASK)" $(GEMINI_FLAGS) \
	  | tee $(OUTPUT_DIR)/qa-$(shell date +%s).md

devops: ## Dispatch task to DevOps Engineer (gemini-2.5-flash-lite)
	@mkdir -p $(OUTPUT_DIR)
	@GEMINI_API_KEY=$(DEVOPS_KEY) \
	  gemini -m gemini-2.5-flash-lite -p "$(TASK)" $(GEMINI_FLAGS) \
	  | tee $(OUTPUT_DIR)/devops-$(shell date +%s).md

consult: ## Dispatch research task to Business Consultant (web-search + Google)
	@mkdir -p $(OUTPUT_DIR)
	@GEMINI_API_KEY=$(CONSULT_KEY) \
	  gemini -m web-search -p "$(TASK)" $(GEMINI_FLAGS) \
	  | tee $(OUTPUT_DIR)/consult-$(shell date +%s).md

team-health: ## Verify all agents are responding
	@~/.agent-team/scripts/health-check.sh

clean-output: ## Remove all generated output files from agent-output/
	@rm -f $(OUTPUT_DIR)/*.ts $(OUTPUT_DIR)/*.tsx $(OUTPUT_DIR)/*.md $(OUTPUT_DIR)/*.sql
	@echo "agent-output/ cleaned"

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
```

### `.gemini/settings.json.template`

```json
{
  "modelConfigs": {
    "customAliases": {
      "consultant": {
        "extends": "gemini-2.5-pro",
        "modelConfig": {
          "generateContentConfig": {
            "tools": [{ "googleSearch": {} }]
          }
        }
      }
    }
  }
}
```

> **Note:** If the `customAliases` configuration for Google Search doesn't work in your Gemini CLI version, use `gemini -m web-search` instead — the built-in `web-search` alias has Google Search pre-enabled and requires no configuration.

---

## 12. Full Directory Structure

```
# GLOBAL (persistent, migratable)
~/.agent-team/
├── .gitignore
├── .env.team                    # 🔑 API keys — never commit
├── .env.team.example
├── scripts/
│   ├── setup.sh
│   ├── health-check.sh
│   ├── rotate-key.sh
│   ├── gemini-call.sh
│   └── migrate.sh
└── skills/
    ├── tech-lead/               SKILL.md + references/
    ├── backend-engineer/        SKILL.md + references/ + sub-skills/
    ├── frontend-engineer/       SKILL.md + references/ + sub-skills/
    ├── qa-engineer/             SKILL.md + references/ + sub-skills/
    ├── devops-engineer/         SKILL.md + references/ + sub-skills/
    └── business-consultant/     SKILL.md + references/ + sub-skills/

~/.claude/skills/
├── lean-startup/
├── skill-creator/
├── mcp-builder/
├── webapp-testing/
├── frontend-design/
├── technical-writer/
├── prompt-architect/
├── performance-optimization/
└── init-agent-team/             ⭐ Bootstrap skill
    ├── SKILL.md
    └── templates/
        ├── CLAUDE.md.template
        ├── TEAM.md.template
        ├── Makefile.template
        └── settings.json.template

~/.gemini/skills/
└── [symlinks or copies of ~/.agent-team/skills/ entries]

# PER PROJECT (generated by init-agent-team)
<project>/
├── CLAUDE.md
├── TEAM.md
├── Makefile
├── .gitignore                   # Must include: agent-output/, .env*
│
├── agent-output/                # Gemini outputs (gitignored)
│   └── .gitkeep
├── api-contracts/               # API contracts authored by Claude
│   └── .gitkeep
├── research/                    # Business Consultant outputs
│   └── .gitkeep
│
├── .claude/
│   └── skills/                  # Optional project-specific skill overrides
│
└── .gemini/
    ├── settings.json
    └── skills/                  # Symlinks to ~/.agent-team/skills/

# GITHUB RELEASE REPO
agentsquad/
├── README.md
├── LICENSE                      # MIT
├── CONTRIBUTING.md
├── CHANGELOG.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
├── COMPATIBILITY.md             # Gemini CLI version compatibility matrix
├── VERSION                      # e.g., "1.0.0"
├── .gitignore
│
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml
│   │   └── feature_request.yml
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
│       ├── shellcheck.yml       # Lint all .sh scripts on every PR
│       └── compatibility.yml   # Weekly: test against latest gemini-cli
│
├── install.sh                   # One-command setup (macOS/Linux)
├── install.ps1                  # Windows (WSL required)
├── docs/
│   ├── architecture.md
│   ├── setup-guide.md
│   ├── workflow-guide.md
│   ├── customization.md
│   ├── troubleshooting.md
│   ├── contributing-skills.md
│   └── faq.md
│
├── skills/                      # The installable skills library
│   ├── backend-engineer/
│   ├── frontend-engineer/
│   ├── qa-engineer/
│   ├── devops-engineer/
│   ├── business-consultant/
│   └── tech-lead/
│
├── init-agent-team/             # The bootstrap skill
│   ├── SKILL.md
│   └── templates/
│
├── scripts/
│   ├── setup.sh
│   ├── health-check.sh
│   ├── rotate-key.sh
│   ├── gemini-call.sh
│   └── migrate.sh
│
├── examples/
│   ├── saas-starter/
│   │   ├── CLAUDE.md
│   │   └── README.md
│   └── agency-platform/
│       ├── CLAUDE.md
│       └── README.md
│
└── .env.example                 # Credential template
```

---

## 13. Implementation Phases

### Phase 1 — Foundation (Days 1–2)
**Goal:** Infrastructure is set up, all 5 agents can respond.

Prerequisites:
- [ ] Node.js >= 18 installed (`node --version`)
- [ ] On macOS: GNU Make installed (`brew install make`)
- [ ] On macOS: bash >= 4 optional (`brew install bash`)
- [ ] 1 Google account ready (start with free tier — upgrade to paid when you hit 250 RPD consistently)

Steps:
- [ ] Create `~/.agent-team/` directory structure (manually or run `setup.sh`)
- [ ] Get API key from [aistudio.google.com](https://aistudio.google.com) → "Get API Key" → Create in new project named `agentsquad`
- [ ] Create `~/.agent-team/.env.team` with `GEMINI_API_KEY=your_key_here`
- [ ] `chmod 600 ~/.agent-team/.env.team`
- [ ] Write `scripts/setup.sh` (see Section 10 outline)
- [ ] Write `scripts/health-check.sh` (see Section 10 outline)
- [ ] Write `scripts/gemini-call.sh` (see Section 10 outline)
- [ ] `chmod +x ~/.agent-team/scripts/*.sh`
- [ ] Install Gemini CLI: `npm install -g @google/gemini-cli`
- [ ] Run `source ~/.agent-team/.env.team && ~/.agent-team/scripts/health-check.sh`
- [ ] Verify: all 5 agents reply "OK"

---

### Phase 2 — Skills Library (Days 3–5)
**Goal:** Each agent has a working SKILL.md with real expertise.

- [ ] Clone external skill repos (see Section 6 for clone commands)
- [ ] Install ccpi and run `ccpi install lean-startup`
- [ ] Write `backend-engineer/SKILL.md` (use example in Section 6 as template)
- [ ] Write `frontend-engineer/SKILL.md`
- [ ] Write `qa-engineer/SKILL.md`
- [ ] Write `devops-engineer/SKILL.md`
- [ ] Write `business-consultant/SKILL.md`
- [ ] Write `tech-lead/SKILL.md`
- [ ] Write all `references/` files for each role (api-patterns.md, testing-strategy.md, etc.)
- [ ] Copy/link sub-skills from Jeffallan, djacobsmeyer, alirezarezvani (see per-role install commands)
- [ ] Symlink `~/.agent-team/skills/` into `~/.gemini/skills/`
- [ ] Install Anthropic official skills into `~/.claude/skills/`
- [ ] Test: call each Gemini agent with a role-appropriate test task and verify the SKILL.md activates

---

### Phase 3 — First Real Integration (Days 6–7)
**Goal:** End-to-end feature delivery using the full team.

Pick a small test project (e.g., a simple REST API + React frontend):
- [ ] Claude plans a feature (e.g., "user registration with email confirmation")
- [ ] Claude writes an api-contract.md for the feature
- [ ] Backend Engineer implements the endpoint (via `make backend TASK=...`)
- [ ] QA Engineer writes tests (sequential, using Backend output as context)
- [ ] Frontend Engineer builds the registration form (parallel with QA)
- [ ] Business Consultant researches one real question about the product
- [ ] Claude integrates all outputs
- [ ] **Measure:** Count Claude tokens used vs. estimated tokens if Claude did everything

---

### Phase 4 — `init-agent-team` Skill (Days 8–10)
**Goal:** One-command team bootstrap for any new repo.

- [ ] Write `init-agent-team/SKILL.md` (see Section 9 for full body)
- [ ] Write `CLAUDE.md.template` (see Section 11)
- [ ] Write `TEAM.md.template`
- [ ] Write `Makefile.template` (see Section 11)
- [ ] Write `settings.json.template` (see Section 11)
- [ ] Install skill to `~/.claude/skills/init-agent-team/`
- [ ] Test: create a fresh empty repo, run `/init-agent-team`, verify all generated files are correct
- [ ] Test: run `make team-health` in the new project — all agents should respond

---

### Phase 5 — Parallel Workflow & Polish (Days 11–14)
**Goal:** Parallel dispatch works reliably; system handles failures gracefully.

- [ ] Write `rotate-key.sh` and integrate with `gemini-call.sh`
- [ ] Test parallel dispatch (Pattern B) on a real feature with 3 simultaneous agents
- [ ] Test git worktree isolation (Pattern D) for two conflicting features
- [ ] Write `migrate.sh` (see Section 10 outline)
- [ ] Add `agent-output/.gitkeep` convention and document naming convention
- [ ] Cross-platform test: verify all scripts work on Linux (use Docker ubuntu:22.04 if no Linux machine)
- [ ] Add `.gitignore` entries to project template: `agent-output/`, `.env*`, `!.env.example`
- [ ] Write all `references/` file content for each role

---

### Phase 6 — GitHub Release (Days 15–21)
**Goal:** Production-quality OSS release on GitHub.

**Documentation:**
- [ ] Write `README.md` with all required sections (see Section 14)
- [ ] Write `docs/setup-guide.md` (step-by-step from zero, including API key creation walkthrough)
- [ ] Write `docs/workflow-guide.md` (day-to-day, with examples)
- [ ] Write `docs/architecture.md` (with flow diagram and filesystem diagram)
- [ ] Write `docs/customization.md` (adapting for different tech stacks)
- [ ] Write `docs/troubleshooting.md` (at minimum 9 scenarios — see Section 14)
- [ ] Write `docs/contributing-skills.md` (SKILL.md format, test procedure, PR process)
- [ ] Write `docs/faq.md` (at minimum 8 questions — see Section 14)

**GitHub release infrastructure:**
- [ ] Create `.github/ISSUE_TEMPLATE/bug_report.yml`
- [ ] Create `.github/ISSUE_TEMPLATE/feature_request.yml`
- [ ] Create `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] Create `.github/workflows/shellcheck.yml` (lint all .sh files on PR)
- [ ] Create `.github/workflows/compatibility.yml` (weekly gemini-cli compatibility check)
- [ ] Create `CHANGELOG.md`
- [ ] Create `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1)
- [ ] Create `SECURITY.md`
- [ ] Create `COMPATIBILITY.md`
- [ ] Create `VERSION` file with `1.0.0`

**Legal:**
- [ ] Audit licenses of all 4 external skill repos (Jeffallan, alirezarezvani, djacobsmeyer, Jeremy Longshore)
- [ ] Create `ATTRIBUTION.md` crediting all external skill authors
- [ ] Add disclaimer about Google AI Studio ToS to README
- [ ] Confirm MIT license is compatible with all bundled/referenced skills

**Release:**
- [ ] Write `install.sh` (see Section 14 for full specification)
- [ ] Record demo GIF: health-check → backend task → QA test output (≤45 seconds, ≤5MB)
- [ ] Add GitHub repository topics: `claude`, `gemini`, `gemini-cli`, `claude-code`, `ai-agents`, `multi-agent`, `lean-startup`, `developer-tools`, `llm-orchestration`
- [ ] Create git tag `v1.0.0`
- [ ] Create GitHub Release with changelog notes and demo GIF
- [ ] Write and schedule launch posts (Hacker News, Reddit r/ClaudeAI, r/LocalLLaMA)

---

## 14. GitHub Release Plan

### Repository Identity
**Name:** `agentsquad` (or `lean-agent-team`)
**Description:** A lean, human-driven AI startup team using Claude Code as the head and Gemini CLI agents as specialized workers. Build production SaaS with a 6-agent team that bootstraps onto any repo in minutes.

### README Required Sections

```
1. Hero — Project name + one-liner + badges:
   [stars badge] [license: MIT] [requires Node.js 18+]
   [works with Gemini 2.5] [macOS] [Linux] [Windows WSL]

2. The Problem (3 sentences) — "Claude Pro tokens run out..."

3. How It Works (ASCII diagram):
   You → Claude Code (orchestrator)
              ├─ Backend Engineer (Gemini Flash)
              ├─ Frontend Engineer (Gemini Flash)
              ├─ QA Engineer (Gemini Flash-Lite)
              ├─ DevOps Engineer (Gemini Flash-Lite)
              └─ Business Consultant (Gemini Pro + Google Search)

4. Quick Start (5 commands to running):
   curl -fsSL .../install.sh | bash
   # Edit ~/.agent-team/.env.team with your API keys
   source ~/.agent-team/.env.team
   ~/.agent-team/scripts/health-check.sh
   # In your project: /init-agent-team

5. Demo GIF — recorded terminal session (see Phase 6 checklist)

6. Agent Roster — 6-agent table from Section 2

7. Skills — brief explanation + link to skills/ directory

8. Links — setup-guide, workflow-guide, contributing-skills, faq

9. Contributing — link to CONTRIBUTING.md

10. License — MIT + attribution note
```

### `install.sh` Specification

The install script must:
1. Detect OS (macOS/Linux; exit with message for native Windows — direct to install.ps1)
2. Check bash version (warn if < 4 on macOS, suggest `brew install bash`)
3. Check Node.js >= 18 (error if missing)
4. Check GNU Make (warn if missing, provide install command)
5. Install `@google/gemini-cli` via npm (idempotent — skip if already installed)
6. Create `~/.agent-team/` directory structure
7. Create `~/.agent-team/.gitignore`
8. Copy `.env.team.example` to `~/.agent-team/.env.team` if it doesn't exist; `chmod 600`
9. Copy all scripts to `~/.agent-team/scripts/`; `chmod +x` all
10. Copy all skills to `~/.agent-team/skills/`
11. Create `~/.gemini/skills/` symlinks
12. Print: next steps (edit .env.team, add source to shell profile, run health-check)
13. Do NOT auto-modify `~/.zshrc` or `~/.bashrc` (security)
14. Do NOT overwrite existing `.env.team`

### `SECURITY.md` Content

Must include:
- How API keys are handled: stored locally in `~/.agent-team/.env.team`, read as environment variables, never logged or transmitted to any server other than Google's API
- How to revoke a compromised key: aistudio.google.com → Manage API keys → Revoke
- How to report a security vulnerability: GitHub private advisory (or maintainer email)
- Never open a public issue for security vulnerabilities

### `docs/troubleshooting.md` Required Scenarios

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `gemini: command not found` | gemini-cli not installed | `npm install -g @google/gemini-cli` |
| Agent returns empty output | Rate limit or network error | Check 429 in output; run health-check; try rotate-key.sh |
| Agent returns garbage / hallucinated code | Unclear task prompt | Rewrite task prompt with more context; add api-contract.md |
| `--approval-mode=yolo: unknown flag` | Old gemini-cli version | `npm update -g @google/gemini-cli` |
| SKILL.md not activating | Skill description doesn't match task | Rephrase description in SKILL.md frontmatter |
| `health-check.sh: Permission denied` | Missing execute permission | `chmod +x ~/.agent-team/scripts/health-check.sh` |
| Symlinks broken after OS upgrade | macOS path change | Re-run `setup.sh` |
| Google Search not working in Consultant | settings.json misconfigured | Use `gemini -m web-search` instead |
| All 5 keys rate-limited simultaneously | Heavy parallel sprint | Wait for reset (midnight PT); use reserve keys |

### `docs/faq.md` Required Questions

1. Do I really need 5 separate Google accounts?
2. What if I only have 1 Google account?
3. Can I use Gemini API paid tier instead of free?
4. Does this work with Claude Team or only Claude Pro?
5. Is the `--approval-mode=yolo` flag safe?
6. Can I use other LLMs (OpenAI, Ollama) instead of Gemini?
7. Are my API keys safe? Does AgentSquad store them anywhere?
8. What happens when Gemini CLI updates and breaks the commands?

### Versioning Strategy

```
AgentSquad uses Semantic Versioning (MAJOR.MINOR.PATCH):

MAJOR: Breaking changes to SKILL.md format, install procedure, or core API
MINOR: New agent roles, new skills, significant new features
PATCH: Bug fixes, script improvements, documentation updates

Version is stored in:
- VERSION file (e.g., "1.0.0")
- Git tags: v1.0.0
- SKILL.md frontmatter: version: 1.0.0
- README badge

Upgrade path:
- install.sh is idempotent — re-running upgrades scripts and skills
- .env.team is NEVER overwritten by install.sh
- COMPATIBILITY.md tracks supported gemini-cli version ranges
```

### COMPATIBILITY.md Template

```markdown
# AgentSquad Compatibility

| AgentSquad | Gemini CLI | Node.js | Claude Code | Status |
|-----------|-----------|---------|-------------|--------|
| 1.0.0 | 0.1.x | >= 18 | Latest | ✅ Supported |

## Breaking Changes in Gemini CLI
- v0.x: `--yolo` deprecated → use `--approval-mode=yolo`

## Reporting Compatibility Issues
Open an issue with label `compatibility`.
```

### `.github/workflows/compatibility.yml` Outline

```yaml
name: Weekly Compatibility Check
on:
  schedule:
    - cron: '0 9 * * 1'  # Every Monday 9am UTC
  workflow_dispatch:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm install -g @google/gemini-cli
      - name: Run health check stub (no real keys in CI)
        run: |
          gemini --version
          echo "✅ gemini-cli installed successfully"
      - name: Shellcheck all scripts
        run: shellcheck scripts/*.sh
```

### Differentiators vs. Similar Projects

| Feature | AgentSquad | OpenClaw | Other multi-agent tools |
|---------|-----------|---------|------------------------|
| Human-driven | ✅ You drive with Claude | ❌ Automated | Varies |
| Lean (minimum agents) | ✅ 6 focused agents | ❌ Many workers | Varies |
| Business intelligence built-in | ✅ Google Search grounding | ❌ | Rarely |
| One-command bootstrap | ✅ init-agent-team skill | ❌ | Rarely |
| Skills-first expertise | ✅ SKILL.md per role | ❌ | Rarely |
| Portable (one dir) | ✅ ~/.agent-team/ | ❌ | Rarely |

---

## 15. Appendices

### Appendix A: Verified GitHub Repositories

| Repository | Owner | Verified | Contains |
|-----------|-------|---------|---------|
| [anthropics/skills](https://github.com/anthropics/skills) | Anthropic | ✅ Active | 17 official skills including webapp-testing, skill-creator, mcp-builder, frontend-design |
| [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) | Jeffallan | ✅ Active (v0.4.7) | 66 skills: nestjs-expert, fastapi-expert, django-expert, react-expert, nextjs-developer, test-master, secure-code-guardian, security-reviewer, devops-engineer, api-designer, postgres-pro, terraform-engineer, monitoring-expert, playwright-expert |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | alirezarezvani | ✅ Active | 169 skills. Business Consultant uses: `c-level-advisor/ceo-advisor`, `c-level-advisor/competitive-intel`, `product-team/competitive-teardown` |
| [djacobsmeyer/claude-skills-engineering](https://github.com/djacobsmeyer/claude-skills-engineering) | djacobsmeyer | ✅ Active | `plugins/manage-worktrees-skill`, `plugins/sandbox-manager` |
| [jeremylongshore/claude-code-plugins-plus-skills](https://github.com/jeremylongshore/claude-code-plugins-plus-skills) | Jeremy Longshore | ✅ Active | 2,235+ skills. Install via `ccpi install lean-startup`. Package: `@intentsolutionsio/ccpi` |
| [google-gemini/gemini-skills](https://github.com/google-gemini/gemini-skills) | Google | ✅ Active | Official Gemini CLI skills (gemini-api-dev, etc.) |

### Appendix B: Building the `market-researcher` Custom Skill

The `market-researcher` skill does not exist in any third-party repo. Build it using the `skill-creator` Anthropic skill:

1. In Claude Code, activate `skill-creator`: `/skill-creator`
2. Ask it to build a skill for structured market research
3. Key requirements to specify:
   - Always uses Google Search for real data
   - Output format: findings table with source URLs and verbatim quotes
   - Always includes a "What I could not find" section
   - Max 500 words in primary findings
   - Includes confidence level (High/Medium/Low based on source count)
4. Save the generated SKILL.md to `~/.agent-team/skills/business-consultant/market-researcher/SKILL.md`

### Appendix C: Key Technical Corrections (from review agents)

#### v1.1 Corrections (from 4 specialized analysis agents)

| Original (v1.0) | Corrected (v1.1) | Reason |
|----------------|-----------------|--------|
| `--yolo` flag everywhere | `--approval-mode=yolo` | `--yolo` is deprecated in Gemini CLI |
| `claude skill install webapp-testing` | `git clone + cp` or `npx skills add` | No such terminal command exists |
| `modelAliases.consultant.tools: ["google_search"]` | `modelConfigs.customAliases` with `generateContentConfig.tools: [{"googleSearch":{}}]` | Wrong settings.json schema |
| `nextjs-expert` (Jeffallan) | `nextjs-developer` | Actual directory name in Jeffallan repo |
| `business-consultant` and `market-researcher` from alirezarezvani | `c-level-advisor/competitive-intel`, `c-level-advisor/ceo-advisor`, `product-team/competitive-teardown` | Those directory names don't exist |
| `manage-worktrees` (djacobsmeyer) | `manage-worktrees-skill` | Actual directory name is `plugins/manage-worktrees-skill` |
| `/tmp/` for output files | `./agent-output/` (project-local, gitignored) | `/tmp/` is cross-platform unreliable and not cleaned |
| Parallel: `wait` with no exit code check | `wait "$pid" \|\| echo "⚠️ process $pid failed"` | `wait` returns 0 even when background jobs fail |
| No `/src/types/` ownership definition | Backend: `/src/types/api/`; Frontend: `/src/types/ui/`; Claude: `/src/types/shared/` | Avoids file ownership conflicts |
| `git worktree add <path> <branch>` (assumed branch exists) | Note: use `-b` flag to create new branch | Prevents unexpected failures |

#### v1.2 Corrections (from Gemini 3 Pro CTO Review)

| Original (v1.1) | Corrected (v1.2) | Reason |
|----------------|-----------------|--------|
| 5 separate Google accounts + 5 API keys | 1 Google account + 1 `GEMINI_API_KEY` (shared) | Multi-account strategy is high-friction and risks Google anti-abuse flagging. Single key with optional overrides is simpler and fully upgradeable. |
| `GEMINI_KEY_BACKEND` / `GEMINI_KEY_FRONTEND` etc. as required vars | All optional; `GEMINI_API_KEY` is the only required var | Per-agent keys are now opt-in overrides via `$(or $(GEMINI_KEY_BACKEND),$(GEMINI_API_KEY))` in Makefile |
| No protection against LLM conversational filler breaking pipes | `strip-filler.sh` + `gemini-call.sh` integration | LLMs inject preamble ("Here is the code") that breaks downstream bash piping and file reads |
| No pre-task dependency declaration in SKILL.md | Step 0 in Process: DEPENDENCIES NEEDED block before code | Prevents mid-task interruptions for package installs; surfaces blockers upfront |
| No api-contract enforcement in SKILL.md | Output Contract OUTPUT RULE: no preamble, strict format | Prevents silent contract drift during parallel dispatch |
| No output stripping in gemini-call.sh | Integrated `strip_filler` call after successful Gemini response | Ensures clean output files even when Gemini adds conversational text |

---

#### v1.3 Corrections (from Gemini 3 Pro CTO Review — second pass)

| Original (v1.2) | Corrected (v1.3) | Reason |
|----------------|-----------------|--------|
| `strip-filler.sh` awk used `exit` on closing fence | Changed to `next` — now captures ALL code blocks | If LLM returns multiple code blocks (e.g. imports + main function), the original `exit` truncated after the first block, silently dropping code |
| `gemini-call.sh` had no escalation signal on success | Added `grep "\[ESCALATE TO CLAUDE\]"` + bold terminal warning after every save | Silent escalations in parallel mode could be missed, leading to merging incomplete agent output |
| `CLAUDE.md.template` Dispatch Guidelines had no parallel integration rule | Added: verify all expected `agent-output/` files exist before integrating; never integrate partial results from a broken parallel run | If one parallel job fails silently, the successful counterpart's artifact could be integrated with a missing dependency |

---

*Blueprint v1.3 · March 10, 2026 · Final pre-implementation revision — output pipeline hardened, escalation detection active*
*v1.1 reviewed by: Technical Accuracy Agent, Completeness Agent, Role Design Agent, GitHub Release Agent*
*v1.2 reviewed by: Gemini 3 Pro (CTO persona) — first pass*
*v1.3 reviewed by: Gemini 3 Pro (CTO persona) — second pass, scored 9/10*
