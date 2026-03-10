# AgentSquad

**Claude Code as your Tech Lead. Gemini CLI as your dev team.** One free API key runs Backend, Frontend, QA, DevOps, and Business Consultant agents in parallel.

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Node.js 18+](https://img.shields.io/badge/Node.js-18%2B-green.svg)](https://nodejs.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)](#)

---

## The problem

Claude Pro tokens run out fast when you're building solo. Every CRUD endpoint, every test file, every Dockerfile burns context you need for the decisions that actually matter.

## The fix

Delegate execution to Gemini. Keep Claude for architecture.

```
You
 └─ Claude Code (Tech Lead — architecture, decisions, review)
      ├─ Backend Engineer    (Gemini 2.5 Flash)
      ├─ Frontend Engineer   (Gemini 2.5 Flash)
      ├─ QA Engineer         (Gemini 2.5 Flash-Lite)
      ├─ DevOps Engineer     (Gemini 2.5 Flash-Lite)
      └─ Business Consultant (Gemini 2.5 Pro + Google Search)
```

One free Gemini API key. 250 req/day on Flash, 1,000 on Flash-Lite. Your Claude Pro budget goes to the 10% that requires it.

---

## Simplest Setup

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JedizR/agentsquad/main/install.sh)
```

Then open `~/.agent-team/.env.team`, add your Gemini API key, and run `~/.agent-team/scripts/health-check.sh`. Done.

Get a free key at [aistudio.google.com](https://aistudio.google.com).

---

## If you are an AI Agent

> **For users:** Tell Claude Code — _"Set up AgentSquad from https://github.com/JedizR/agentsquad"_ — and it will follow these steps automatically.

If you are Claude Code or another AI agent reading this, here is the full setup sequence. Run each step in order and report back after each one.

**Step 1 — Install**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JedizR/agentsquad/main/install.sh)
```

**Step 2 — Ask the user for their Gemini API key**

Tell the user: _"Please paste your Gemini API key. Get one free at https://aistudio.google.com → Get API Key."_

Then write it into the credentials file:
```bash
# Replace YOUR_KEY_HERE with the key the user provides
sed -i.bak 's/your_key_here/YOUR_KEY_HERE/' ~/.agent-team/.env.team
source ~/.agent-team/.env.team
```

**Step 3 — Verify**
```bash
~/.agent-team/scripts/health-check.sh
```
All 5 agents should show `✅ Responding`. If any show rate-limited, wait one minute and retry.

**Step 4 — Bootstrap the current project**
```bash
# Inside Claude Code, run:
/init-agent-team
```
This generates `CLAUDE.md`, `TEAM.md`, `Makefile`, and `.gemini/settings.json` in the current directory.

**Step 5 — Confirm to the user**

Tell the user: _"AgentSquad is ready. Try `make team-health` to confirm all agents are up, then `make backend TASK='...'` to dispatch your first agent."_

---

## Quick Setup (Manually)

```bash
# 1. Clone and run setup
git clone https://github.com/JedizR/agentsquad && cd agentsquad
bash scripts/setup.sh

# 2. Add your Gemini API key (free at aistudio.google.com)
nano ~/.agent-team/.env.team

# 3. Load credentials
source ~/.agent-team/.env.team

# 4. Verify all 5 agents respond
~/.agent-team/scripts/health-check.sh

# 5. Bootstrap onto any project (run inside Claude Code)
/init-agent-team
```

---

## The team

| Agent | Runtime | Model | Free RPD |
|-------|---------|-------|----------|
| **You + Claude Code** | Anthropic | Claude (latest) | — |
| **Backend Engineer** | Gemini CLI | gemini-2.5-flash | 250 |
| **Frontend Engineer** | Gemini CLI | gemini-2.5-flash | 250 |
| **QA Engineer** | Gemini CLI | gemini-2.5-flash-lite | 1,000 |
| **DevOps Engineer** | Gemini CLI | gemini-2.5-flash-lite | 1,000 |
| **Business Consultant** | Gemini CLI + Search | gemini-2.5-pro | 100 |

---

## How it works

**1. You give Claude a feature request.**

**2. Claude decomposes it and dispatches to agents:**

```bash
# Research before building
make consult TASK="What's the standard SaaS billing model in 2026?"

# Parallel dispatch
make backend  TASK="Implement subscription API per api-contracts/billing.md" &
make frontend TASK="Build the billing page" &
wait

# Sequential: tests after backend output is reviewed
make qa TASK="Write tests for the billing endpoints in agent-output/backend-*.md"
```

**3. Gemini agents write structured output to `agent-output/`.**

**4. Claude reviews, resolves any escalations, integrates, and commits.**

Nothing reaches `src/` without Claude's review step. That's the safeguard.

---

## Skills

Each agent loads a `SKILL.md` from `~/.gemini/skills/` — a versioned role definition covering what the agent builds, how it formats output, and when to stop and escalate.

Every SKILL.md enforces three rules:

- **OUTPUT RULE** — no preamble, no "Here is the code", content starts on line 1
- **Output contract** — a structured block at the end Claude can parse reliably
- **Escalation triggers** — `[ESCALATE TO CLAUDE]` flags any decision that needs a human

Browse: [`skills/`](skills/)

---

## Dispatching agents

After `/init-agent-team` bootstraps your project, you get a `Makefile`:

```bash
make backend  TASK="implement the users CRUD API"
make frontend TASK="build the user profile page"
make qa       TASK="write tests for src/api/users.ts"
make devops   TASK="add a GitHub Actions CI pipeline"
make consult  TASK="research competitor pricing for B2B SaaS"
make team-health          # verify all 5 agents respond
```

All output goes to `agent-output/` (gitignored).

---

## Project structure

```
~/.agent-team/              # Global portable home — migrates with you
  scripts/                  # setup.sh, health-check.sh, gemini-call.sh, etc.
  skills/                   # All 6 agent SKILL.md files + references

agentsquad/                 # This repo
  scripts/                  # Source for ~/.agent-team/scripts/
  skills/                   # Source for ~/.agent-team/skills/
  init-agent-team/          # Bootstrap skill for new projects
  examples/
    saas-starter/           # Node.js + Stripe config example
    agency-platform/        # Python/FastAPI + Next.js config example
  docs/                     # Full documentation
  Makefile
  install.sh                # One-command remote installer
```

---

## Scripts

| Script | What it does |
|--------|-------------|
| `setup.sh` | Installs gemini-cli, creates `~/.agent-team/`, symlinks skills |
| `health-check.sh` | Pings all 5 agents and reports status |
| `gemini-call.sh` | Retry wrapper with backoff and `[ESCALATE TO CLAUDE]` detection |
| `strip-filler.sh` | Strips LLM preamble from agent output |
| `rotate-key.sh` | Swaps to a reserve key when rate-limited |
| `migrate.sh` | Moves `~/.agent-team/` to a new machine via rsync |

All scripts pass `shellcheck` with zero errors or warnings on macOS and Ubuntu.

---

## Cost

A typical coding task runs about 5,000 input + 2,000 output tokens.

| Usage | Tasks/day | Flash cost/day | Monthly |
|-------|-----------|---------------|---------|
| Light | 20 | ~$0.04 | ~$1 |
| Normal | 50 | ~$0.10 | ~$3 |
| Heavy sprint | 200 | ~$0.40 | ~$12 |

The free tier (250 RPD on Flash) handles normal solo development. Add a credit card and set a $20/month cap when you hit the limit consistently.

---

## Docs

- [Setup Guide](docs/setup-guide.md) — step-by-step from zero, including API key setup
- [Workflow Guide](docs/workflow-guide.md) — the four dispatch patterns with real examples
- [Architecture](docs/architecture.md) — how control flows and where files live
- [Customization](docs/customization.md) — swapping models, adding roles, per-agent keys
- [Troubleshooting](docs/troubleshooting.md) — nine common failure scenarios
- [FAQ](docs/faq.md) — eight common questions
- [Contributing Skills](docs/contributing-skills.md) — how to add a new agent role
- [Changelog](CHANGELOG.md) — what changed in each release
- [Compatibility](COMPATIBILITY.md) — tested Gemini CLI and platform versions

---

## Requirements

- **Node.js** >= 18
- **GNU Make** (macOS: `brew install make`)
- **1 Google account** — [free Gemini API key](https://aistudio.google.com)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the PR process and [docs/contributing-skills.md](docs/contributing-skills.md) for adding new agent roles.

---

## License

MIT — see [LICENSE](LICENSE).

> This project uses the Google AI Studio API. Usage is subject to [Google's AI Studio Terms of Service](https://ai.google.dev/terms). API keys are stored locally in `~/.agent-team/.env.team` and sent only to Google's API endpoint.
