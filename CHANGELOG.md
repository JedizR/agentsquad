# Changelog

All notable changes to AgentSquad are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versions follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-03-11

First public release.

### Added

**Foundation (Phase 1)**
- `scripts/setup.sh` — one-shot idempotent setup for macOS and Linux
- `scripts/health-check.sh` — verify all 5 agents respond (bash 3.2 compatible)
- `scripts/gemini-call.sh` — retry wrapper with 3-attempt backoff, escalation detector, and `strip_filler` integration
- `scripts/strip-filler.sh` — LLM output cleaner with two strategies: code-block extraction and preamble stripping
- `scripts/rotate-key.sh` — swap to reserve key on 429 rate limit
- `scripts/migrate.sh` — rsync `~/.agent-team/` to a new machine
- `~/.agent-team/` global directory structure (scripts, skills)
- `.env.team` template with `chmod 600` and `.gitignore` protection

**Skills Library (Phase 2)**
- `skills/backend-engineer/SKILL.md` — REST/GraphQL API, Node.js/TypeScript/Python, database schemas
- `skills/frontend-engineer/SKILL.md` — React/Next.js, component design, state management
- `skills/qa-engineer/SKILL.md` — unit and integration testing, security review
- `skills/devops-engineer/SKILL.md` — CI/CD, Docker, Terraform, monitoring
- `skills/business-consultant/SKILL.md` — market research with Google Search, competitive analysis
- `skills/tech-lead/SKILL.md` — task decomposition, agent routing, API contract design
- Reference files for all 6 roles

**Bootstrap (Phase 4)**
- `init-agent-team/SKILL.md` — 4-step project bootstrap skill
- `init-agent-team/templates/` — CLAUDE.md, TEAM.md, Makefile, settings.json templates

**Makefile**
- 8 targets: `backend`, `frontend`, `qa`, `devops`, `consult`, `team-health`, `clean`, `help`
- Single-key default with per-agent key override (`GEMINI_KEY_BACKEND`, etc.)
- `gemini-call.sh` integration for retry logic

**Documentation (Phase 5–6)**
- `docs/setup-guide.md` — step-by-step from zero
- `docs/workflow-guide.md` — 4 dispatch patterns with real examples
- `docs/troubleshooting.md` — 9 failure scenarios with quick-reference table
- `docs/faq.md` — 8 common questions
- `docs/architecture.md` — system diagram, filesystem layout, credential flow
- `docs/customization.md` — adapting for different stacks and team sizes
- `docs/contributing-skills.md` — SKILL.md format, testing process, PR checklist

**GitHub Release Infrastructure**
- `.github/ISSUE_TEMPLATE/bug_report.yml`
- `.github/ISSUE_TEMPLATE/feature_request.yml`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/workflows/shellcheck.yml` — lint all .sh files on PR
- `.github/workflows/compatibility.yml` — weekly Gemini CLI compatibility check
- `COMPATIBILITY.md` — tested version matrix
- `SECURITY.md` — key handling and vulnerability reporting
- `CODE_OF_CONDUCT.md` — Contributor Covenant 2.1
- `CONTRIBUTING.md` — contribution process
- `install.sh` — one-command remote install

### Technical notes

- All scripts pass `shellcheck --severity=warning` on macOS 0.11.0 and Ubuntu 0.8.0
- `health-check.sh` uses `case` instead of `declare -A` for bash 3.2 compatibility (macOS default)
- `strip-filler.sh` uses `awk -v fence=` to pass the backtick fence character without shell expansion issues
- `gemini-call.sh` uses `--prompt` flag (not `-p`) matching current Gemini CLI interface
- Makefile `help` target uses `-h` grep flag to suppress filename prefix

---

## Versioning policy

**Major (x.0.0):** Breaking changes to SKILL.md format, script interfaces, or directory layout.

**Minor (1.x.0):** New agent roles, new scripts, new make targets, significant documentation additions.

**Patch (1.0.x):** Bug fixes, shellcheck fixes, documentation corrections, compatibility updates.
