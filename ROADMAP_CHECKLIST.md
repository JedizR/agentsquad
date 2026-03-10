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
- [ ] Write `README.md` (hero, problem, how it works, quick start, demo GIF, agent roster, skills, links)
- [ ] Write `docs/setup-guide.md` (step-by-step from zero)
- [ ] Write `docs/workflow-guide.md` (day-to-day with examples)
- [ ] Write `docs/architecture.md` (flow diagram + filesystem diagram)
- [ ] Write `docs/customization.md` (adapting for different tech stacks)
- [ ] Write `docs/troubleshooting.md` (9 scenarios per Section 14)
- [ ] Write `docs/contributing-skills.md` (SKILL.md format, test procedure, PR process)
- [ ] Write `docs/faq.md` (8 questions per Section 14)

### GitHub Release Infrastructure
- [ ] Create `.github/ISSUE_TEMPLATE/bug_report.yml`
- [ ] Create `.github/ISSUE_TEMPLATE/feature_request.yml`
- [ ] Create `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] Create `.github/workflows/shellcheck.yml` (lint all .sh files on PR)
- [ ] Create `.github/workflows/compatibility.yml` (weekly gemini-cli compatibility check)
- [ ] Create `CHANGELOG.md`
- [ ] Create `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1)
- [ ] Create `SECURITY.md` (key handling, revocation, vulnerability reporting)
- [ ] Create `COMPATIBILITY.md` (gemini-cli version matrix)
- [ ] Create `VERSION` file with `1.0.0`

### Legal & Attribution
- [ ] Audit licenses of all 4 external skill repos
- [ ] Create `ATTRIBUTION.md` crediting all external skill authors
- [ ] Add Google AI Studio ToS disclaimer to README
- [ ] Confirm MIT license compatibility with all bundled/referenced skills

### Release
- [ ] Write `install.sh` (per Section 14 spec — idempotent, no .env overwrite, no shell profile modification)
- [ ] Write `install.ps1` (Windows WSL)
- [ ] Write `examples/saas-starter/CLAUDE.md` and `README.md`
- [ ] Write `examples/agency-platform/CLAUDE.md` and `README.md`
- [ ] Add `LICENSE` (MIT)
- [ ] Add `CONTRIBUTING.md`
- [ ] Record demo GIF (health-check → backend task → QA output, ≤45s, ≤5MB)
- [ ] Add GitHub repository topics
- [ ] Create git tag `v1.0.0`
- [ ] Create GitHub Release with changelog notes and demo GIF
- [ ] Write launch posts (HN, Reddit r/ClaudeAI, r/LocalLLaMA)

### Commit
- [ ] Commit: `phase(6): github release — docs, CI, legal, install.sh, examples`

---

## Summary Progress

| Phase | Status | Items Done |
|-------|--------|-----------|
| Phase 1 — Foundation | 🔄 In Progress | 3/20 |
| Phase 2 — Skills Library | ⬜ Not Started | 0/35 |
| Phase 3 — Integration | ⬜ Not Started | 0/8 |
| Phase 4 — init-agent-team | ⬜ Not Started | 0/10 |
| Phase 5 — Parallel & Polish | ⬜ Not Started | 0/8 |
| Phase 6 — GitHub Release | ⬜ Not Started | 0/33 |
