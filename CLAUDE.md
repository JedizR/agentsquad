# AgentSquad — Claude Code Session Context

## What This Project Is

**AgentSquad** is a portable, skills-based multi-agent development framework where
**Claude Code** acts as the Tech Lead, and **Gemini CLI agents** handle parallel
execution work (Backend, Frontend, QA, DevOps, Business Consultant).

The full system design, architecture, scripts, SKILL.md specs, workflow patterns,
and 6-phase implementation plan are in:

```
AgentSquad_Blueprint.md   ← READ THIS FIRST, COMPLETELY, before doing anything
```

---

## Your Role in This Session

You are the **Tech Lead / Builder** responsible for implementing the AgentSquad
system exactly as specified in the blueprint. You will:

1. Read the blueprint fully
2. Set up the repository and environment
3. Find and install the skills you need
4. Create `ROADMAP_CHECKLIST.md` from the blueprint's Phase 1–6 items
5. Work through the phases in a loop — implement → test → commit → next phase
6. Track the checklist after every task completion

---

## Pre-Installed Skills

The following skills are already available in this Claude Code environment:

- `python-expert` — Python best practices (useful for any Python scripts)
- `prompt-architect` — Prompt engineering (useful when writing SKILL.md files)

---

## Skills You Should Find & Install

Use `/find-skills` to search for and install:

| Skill needed | Why |
|---|---|
| `bash` / `shell-expert` | All scripts in this project are bash (setup.sh, gemini-call.sh, etc.) |
| `technical-writer` | Writing clear SKILL.md files, README.md, docs/ |
| `testing` / `test-engineer` | ShellCheck + functional tests required before marking any script done |

Install skills before starting implementation. Skills make your output better.

---

## Key Conventions (from blueprint)

- **`~/.agent-team/`** — global portable home (created in Phase 1)
- **`agent-output/`** — gitignored, all Gemini output goes here
- **`.env.team`** — credentials file, never committed
- **`SKILL.md` format** — YAML frontmatter + structured markdown body
- **OUTPUT RULE** — every SKILL.md must begin response immediately with content, no preamble
- **`${VAR:-$GEMINI_API_KEY}` pattern** — single-key by default, multi-key ready
- **Escalation pattern** — agents output `[ESCALATE TO CLAUDE]` when they need a decision

## Test Requirements (mandatory)

Before marking any script or tool as complete:
- Run `shellcheck` on every `.sh` file (install if needed: `brew install shellcheck`)
- Run functional test: actually call the script with a dry-run or test argument
- Document the test result in the commit message

## Commit Strategy

- `git init` immediately (Phase 1, Step 1)
- Commit after each Phase completes, not after each file
- Commit message format: `phase(N): <what was built>` e.g. `phase(1): foundation — agent-team dir, credentials, setup.sh`
- Never commit `.env.team` or any file matching `*.env*` patterns

## ROADMAP_CHECKLIST.md Format

Create this file after reading the blueprint. Structure:

```markdown
# AgentSquad Roadmap Checklist

## Phase 1 — Foundation
- [ ] Create ~/.agent-team/ directory structure
- [ ] Create .env.team template
- [ ] Write setup.sh
- [ ] Write health-check.sh
- [ ] Write rotate-key.sh
- [ ] Test: shellcheck all scripts
- [ ] Test: setup.sh runs without errors
- [ ] Commit: phase(1) complete

## Phase 2 — Skills Library
...etc for all 6 phases
```

Update checkboxes with `[x]` as you complete each item. Re-read the checklist at
the start of every new task to know where you are.

---

## Working Loop

```
READ blueprint → INSTALL skills → CREATE checklist →
LOOP:
  read checklist → pick next unchecked item →
  implement it → write tests → run tests →
  fix until tests pass → check off item → commit if phase done →
  report back to user → continue to next item
```

Report to the user after each **Phase** completes (not after every file). Show:
- What was built
- Test results
- What's next

---

## Final Goal

A fully working AgentSquad installation that:
1. Lives at `~/.agent-team/` (global) and bootstraps into any project
2. Has all 5 role SKILL.md files written and validated
3. Has all scripts (`setup.sh`, `health-check.sh`, `rotate-key.sh`, `gemini-call.sh`, `strip-filler.sh`) passing shellcheck + functional tests
4. Has the `init-agent-team` bootstrap skill operational
5. Has `Makefile`, `TEAM.md`, `README.md` ready
6. Is git-committed, clean, and ready for GitHub release

This session does not end until the blueprint checklist is complete.
