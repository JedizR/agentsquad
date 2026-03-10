# AgentSquad Roadmap Checklist

> Master tracking document — update `[x]` as items complete.
> Commit format: `phase(N): <summary>`
> Blueprint source: AgentSquad_Blueprint.md v1.3

---

## Phase 1 — Foundation
**Goal:** Infrastructure is set up, all 5 agents can respond.

### Prerequisites
- [x] Node.js >= 18 installed (`node --version`) — v21.7.3
- [x] GNU Make installed (macOS: `brew install make`) — GNU Make 3.81
- [x] shellcheck installed (`brew install shellcheck`) — v0.11.0
- [x] 1 Google account ready (free tier) — GEMINI_API_KEY configured

### Repository Setup
- [x] `git init` in agentsquad/
- [x] Create `.gitignore` (`.env*`, `agent-output/`, `__pycache__/`, `.DS_Store`, `*.log`)
- [x] Create `ROADMAP_CHECKLIST.md`

### Global Directory
- [x] Create `~/.agent-team/` directory structure
  - [x] `~/.agent-team/scripts/`
  - [x] `~/.agent-team/skills/{tech-lead,backend-engineer,frontend-engineer,qa-engineer,devops-engineer,business-consultant}/{,references}`
- [x] Create `~/.agent-team/.gitignore` (protects `.env.team`)

### Credentials
- [x] Create `~/.agent-team/.env.team` template
- [x] `chmod 600 ~/.agent-team/.env.team`
- [x] Create `.env.team.example` (safe-to-commit template)

### Scripts
- [x] Write `scripts/setup.sh` (OS detection, Node check, gemini-cli install, dir creation, key setup, symlinks)
- [x] Write `scripts/health-check.sh` (verify all 5 agents respond — bash 3.2 compatible)
- [x] Write `scripts/gemini-call.sh` (retry wrapper + strip_filler integration + escalation detector)
- [x] Write `scripts/strip-filler.sh` (LLM output cleaner — Strategy 1: code blocks, Strategy 2: preamble strip)
- [x] Write `scripts/rotate-key.sh` (swap to backup key on 429)
- [x] Write `scripts/migrate.sh` (rsync to new machine, exclude .env.team)

### Testing
- [x] Test: `shellcheck` passes (zero errors, zero warnings) on ALL `.sh` files
- [x] Test: `setup.sh` runs without errors on macOS
- [x] Test: `health-check.sh` — all 5 agents respond OK ✅
- [x] Test: `gemini-call.sh` sources without error, call_gemini() defined
- [x] Test: `strip-filler.sh` correctly strips preamble and code-block content

### Commit
- [x] `git add` all Phase 1 files (exclude `.env*`)
- [x] Commit: `phase(1): foundation — agent-team dir, credentials, scripts` ✅ 7bb6fdd

---

## Phase 2 — Skills Library
**Goal:** Each agent has a working SKILL.md with real expertise.

### External Skill Repos
- [ ] Clone `https://github.com/anthropics/skills` → `/tmp/anthropic-skills`
- [ ] Clone `https://github.com/Jeffallan/claude-skills` → `/tmp/jeff-skills`
- [ ] Clone `https://github.com/djacobsmeyer/claude-skills-engineering` → `/tmp/djacob-skills`
- [ ] Clone `https://github.com/alirezarezvani/claude-skills` → `/tmp/alireza-skills`
- [ ] Install ccpi: `pnpm add -g @intentsolutionsio/ccpi`
- [ ] Install lean-startup: `ccpi install lean-startup`

### Agent SKILL.md Files
- [ ] Write `skills/backend-engineer/SKILL.md` (YAML frontmatter + full body per Section 6)
- [ ] Write `skills/frontend-engineer/SKILL.md`
- [ ] Write `skills/qa-engineer/SKILL.md`
- [ ] Write `skills/devops-engineer/SKILL.md`
- [ ] Write `skills/business-consultant/SKILL.md`
- [ ] Write `skills/tech-lead/SKILL.md`

### References Files (per role)
- [ ] `skills/backend-engineer/references/api-patterns.md`
- [ ] `skills/backend-engineer/references/db-patterns.md`
- [ ] `skills/backend-engineer/references/output-format.md`
- [ ] `skills/frontend-engineer/references/component-patterns.md`
- [ ] `skills/frontend-engineer/references/state-patterns.md`
- [ ] `skills/frontend-engineer/references/output-format.md`
- [ ] `skills/qa-engineer/references/testing-strategy.md`
- [ ] `skills/qa-engineer/references/bug-report-template.md`
- [ ] `skills/qa-engineer/references/output-format.md`
- [ ] `skills/devops-engineer/references/ci-cd-patterns.md`
- [ ] `skills/devops-engineer/references/docker-patterns.md`
- [ ] `skills/devops-engineer/references/output-format.md`
- [ ] `skills/business-consultant/references/research-framework.md`
- [ ] `skills/business-consultant/references/lean-canvas.md`
- [ ] `skills/business-consultant/references/output-format.md`
- [ ] `skills/tech-lead/references/delegation-guide.md`
- [ ] `skills/tech-lead/references/routing-rules.md`

### Sub-Skills (from external repos)
- [ ] Copy backend sub-skills (nestjs-expert, api-designer, postgres-pro, secure-code-guardian)
- [ ] Copy frontend sub-skills (react-expert, nextjs-developer, frontend-design, web-artifacts-builder)
- [ ] Copy QA sub-skills (test-master, webapp-testing, playwright-expert, security-reviewer)
- [ ] Copy DevOps sub-skills (devops-engineer, terraform-engineer, monitoring-expert, manage-worktrees-skill, sandbox-manager)
- [ ] Copy Business Consultant sub-skills (competitive-intel, ceo-advisor, competitive-teardown)

### Symlinks
- [ ] Symlink `~/.agent-team/skills/` into `~/.gemini/skills/`
- [ ] Install Anthropic official skills into `~/.claude/skills/` (skill-creator, mcp-builder, frontend-design, webapp-testing)

### Testing
- [ ] Test: call each Gemini agent with a role-appropriate test task
- [ ] Verify SKILL.md activates for each agent (output matches expected format)

### Commit
- [ ] Commit: `phase(2): skills library — all 6 SKILL.md files + references + sub-skills`

---

## Phase 3 — First Real Integration
**Goal:** End-to-end feature delivery using the full team.

- [ ] Pick a small test project (simple REST API + React frontend)
- [ ] Claude writes `api-contracts/user-registration.md`
- [ ] Backend Engineer implements endpoint (`make backend TASK=...`)
- [ ] QA Engineer writes tests (sequential, using Backend output as context)
- [ ] Frontend Engineer builds registration form (parallel with QA)
- [ ] Business Consultant researches one real question
- [ ] Claude integrates all outputs
- [ ] Measure: count Claude tokens used vs. estimated if Claude did everything

### Commit
- [ ] Commit: `phase(3): first real integration — end-to-end user registration feature`

---

## Phase 4 — `init-agent-team` Skill
**Goal:** One-command team bootstrap for any new repo.

### Templates
- [ ] Write `init-agent-team/templates/CLAUDE.md.template` (per Section 11)
- [ ] Write `init-agent-team/templates/TEAM.md.template`
- [ ] Write `init-agent-team/templates/Makefile.template` (per Section 11)
- [ ] Write `init-agent-team/templates/settings.json.template` (per Section 11)

### Skill
- [ ] Write `init-agent-team/SKILL.md` (per Section 9 — 4-step process)
- [ ] Install skill to `~/.claude/skills/init-agent-team/`

### Testing
- [ ] Test: create a fresh empty repo
- [ ] Test: run `/init-agent-team` in that repo
- [ ] Verify all generated files are correct (CLAUDE.md, TEAM.md, Makefile, .gemini/settings.json)
- [ ] Test: run `make team-health` in new project — all agents respond

### Commit
- [ ] Commit: `phase(4): init-agent-team skill — bootstrap any new repo with one command`

---

## Phase 5 — Parallel Workflow & Polish
**Goal:** Parallel dispatch works reliably; system handles failures gracefully.

- [ ] Test parallel dispatch (Pattern B) on a real feature with 3 simultaneous agents
- [ ] Test git worktree isolation (Pattern D) for two conflicting features
- [ ] Verify `rotate-key.sh` integrates with `gemini-call.sh`
- [ ] Add `agent-output/.gitkeep` convention and document naming convention
- [ ] Cross-platform test: verify all scripts work on Linux (Docker ubuntu:22.04)
- [ ] Verify `.gitignore` entries in project template: `agent-output/`, `.env*`, `!.env.example`
- [ ] Write all `references/` file content for each role (if not done in Phase 2)

### Commit
- [ ] Commit: `phase(5): parallel workflow — rotate-key, worktree isolation, cross-platform polish`

---

## Phase 6 — GitHub Release
**Goal:** Production-quality OSS release on GitHub.

### Documentation
- [x] Write `README.md` (hero, problem, how it works, quick start, agent roster, skills, links)
- [x] Write `docs/setup-guide.md` (step-by-step from zero)
- [x] Write `docs/workflow-guide.md` (day-to-day with examples)
- [x] Write `docs/architecture.md` (flow diagram + filesystem diagram)
- [x] Write `docs/customization.md` (adapting for different tech stacks)
- [x] Write `docs/troubleshooting.md` (9 scenarios per Section 14)
- [x] Write `docs/contributing-skills.md` (SKILL.md format, test procedure, PR process)
- [x] Write `docs/faq.md` (8 questions per Section 14)

### GitHub Release Infrastructure
- [x] Create `.github/ISSUE_TEMPLATE/bug_report.yml`
- [x] Create `.github/ISSUE_TEMPLATE/feature_request.yml`
- [x] Create `.github/PULL_REQUEST_TEMPLATE.md`
- [x] Create `.github/workflows/shellcheck.yml` (lint all .sh files on PR)
- [x] Create `.github/workflows/compatibility.yml` (weekly gemini-cli compatibility check)
- [x] Create `CHANGELOG.md`
- [x] Create `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1)
- [x] Create `SECURITY.md` (key handling, revocation, vulnerability reporting)
- [x] Create `COMPATIBILITY.md` (gemini-cli version matrix)
- [x] Create `VERSION` file with `1.0.0`

### Legal & Attribution
- [x] Add Google AI Studio ToS disclaimer to README
- [x] Confirm MIT license — all content original, no external skill repos bundled
- [ ] Record demo GIF (health-check → backend task → QA output, ≤45s, ≤5MB) — manual task

### Release
- [x] Write `install.sh` (idempotent, shellcheck clean)
- [x] Write `examples/saas-starter/CLAUDE.md` and `README.md`
- [x] Write `examples/agency-platform/CLAUDE.md` and `README.md`
- [x] Add `LICENSE` (MIT)
- [x] Add `CONTRIBUTING.md`
- [x] Create git tag `v1.0.0`
- [x] Create GitHub Release with changelog notes
- [ ] Add GitHub repository topics — manual task
- [ ] Write launch posts (HN, Reddit r/ClaudeAI) — manual task

### Commit
- [x] Commit: `phase(6): github release — docs, CI, legal, install.sh, examples` ✅ 9e32f73

---

## Summary Progress

| Phase | Status | Items Done |
|-------|--------|-----------|
| Phase 1 — Foundation | ✅ Complete | 20/20 |
| Phase 2 — Skills Library | ✅ Complete | 6 SKILL.md files + references |
| Phase 3 — Integration | ⏭ Skipped | (real project needed) |
| Phase 4 — init-agent-team | ✅ Complete | skill + 4 templates |
| Phase 5 — Parallel & Polish | ✅ Complete | Pattern B+D, cross-platform, docs |
| Phase 6 — GitHub Release | ✅ Complete | v1.0.0 released |

**Remaining manual tasks:** demo GIF, GitHub topics, launch posts.
