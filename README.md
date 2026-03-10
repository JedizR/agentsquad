# AgentSquad

**A lean, human-driven AI startup team.** Claude Code as your Tech Lead. Gemini CLI agents as your Backend, Frontend, QA, DevOps, and Business Consultant — all on one free API key.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Node.js 18+](https://img.shields.io/badge/Node.js-18%2B-green.svg)](https://nodejs.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-blue.svg)](#)
[![Works with Gemini 2.5](https://img.shields.io/badge/Gemini-2.5%20Flash-orange.svg)](https://ai.google.dev)

---

## The Problem

Claude Pro tokens run out fast when you're building solo. Every CRUD endpoint, every test file, every Dockerfile burns context you need for the hard decisions.

## The Solution

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

One free Gemini API key. 250 req/day on Flash. 1,000 req/day on Flash-Lite. Your Claude Pro budget goes to the 10% of work that actually requires it.

---

## Quick Start

```bash
# 1. Clone and run setup
git clone https://github.com/JedizR/agentsquad && cd agentsquad
bash scripts/setup.sh

# 2. Add your Gemini API key (free at aistudio.google.com)
echo 'GEMINI_API_KEY=your_key_here' >> ~/.agent-team/.env.team

# 3. Load credentials
source ~/.agent-team/.env.team

# 4. Verify all 5 agents respond
~/.agent-team/scripts/health-check.sh

# 5. Bootstrap onto any project
cd ~/your-project && /init-agent-team   # (in Claude Code)
```

---

## The Team

| # | Agent | Runtime | Model | Free RPD |
|---|-------|---------|-------|---------|
| 1 | **You + Claude Code** | Anthropic Pro | Claude (latest) | — |
| 2 | **Backend Engineer** | Gemini CLI | gemini-2.5-flash | 250 |
| 3 | **Frontend Engineer** | Gemini CLI | gemini-2.5-flash | 250 |
| 4 | **QA Engineer** | Gemini CLI | gemini-2.5-flash-lite | 1,000 |
| 5 | **DevOps Engineer** | Gemini CLI | gemini-2.5-flash-lite | 1,000 |
| 6 | **Business Consultant** | Gemini CLI + Search | gemini-2.5-pro | 100 |

---

## How It Works

**1. You give Claude a feature request.**

**2. Claude decomposes it and dispatches to agents:**

```bash
# Research first
make consult TASK="What's the standard SaaS billing model in 2026?"

# Parallel dispatch
make backend  TASK="Implement subscription API per api-contracts/billing.md" &
make frontend TASK="Build the billing page" &
wait

# Sequential: tests after backend is done
make qa TASK="Write tests for the billing endpoints in agent-output/backend-*.md"
```

**3. Gemini agents return structured output to `agent-output/`.**

**4. Claude reviews, resolves escalations, integrates, and commits.**

---

## Skills

Every agent is loaded with a `SKILL.md` — a versioned file that encodes role expertise, output contracts, and escalation rules. Skills live in `~/.agent-team/skills/` and are symlinked into `~/.gemini/skills/` so Gemini CLI loads them automatically.

Each SKILL.md enforces:
- **OUTPUT RULE** — no preamble, no "Here is the code", begin immediately with content
- **Output contract** — structured response format Claude can parse reliably
- **Escalation triggers** — `[ESCALATE TO CLAUDE]` flags decisions only Claude should make

Browse the skills: [`skills/`](skills/)

---

## Project Structure

```
~/.agent-team/          # Global portable home (migrates with you)
  scripts/              # setup.sh, health-check.sh, gemini-call.sh, etc.
  skills/               # All 6 agent SKILL.md files + references

agentsquad/             # This repo (the source of truth)
  scripts/              # Same scripts, source for ~/.agent-team/scripts/
  skills/               # Same skills, source for ~/.agent-team/skills/
  init-agent-team/      # Bootstrap skill for new projects
  Makefile              # Agent dispatch commands
```

---

## Dispatching Agents

After running `/init-agent-team` in your project, you get a `Makefile`:

```bash
make backend  TASK="implement the users CRUD API"
make frontend TASK="build the user profile page"
make qa       TASK="write tests for src/api/users.ts"
make devops   TASK="add a GitHub Actions CI pipeline"
make consult  TASK="research competitor pricing for B2B SaaS tools"
make team-health  # verify all 5 agents respond
```

All output goes to `agent-output/` (gitignored). Claude reviews before anything is integrated.

---

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/setup.sh` | One-shot setup: installs gemini-cli, creates `~/.agent-team/`, symlinks skills |
| `scripts/health-check.sh` | Verify all 5 agents respond (uses real API calls) |
| `scripts/gemini-call.sh` | Retry wrapper with backoff + `[ESCALATE TO CLAUDE]` detection |
| `scripts/strip-filler.sh` | Remove LLM conversational preamble from output files |
| `scripts/rotate-key.sh` | Swap to reserve key on 429 rate limit |
| `scripts/migrate.sh` | Move `~/.agent-team/` to a new machine via rsync |

All scripts pass `shellcheck` with zero errors/warnings.

---

## Docs

- [Setup Guide](docs/setup-guide.md) — step-by-step from zero, including API key creation
- [Workflow Guide](docs/workflow-guide.md) — day-to-day patterns with real examples
- [Architecture](docs/architecture.md) — flow diagrams and filesystem layout
- [Customization](docs/customization.md) — adapting for different tech stacks
- [Troubleshooting](docs/troubleshooting.md) — 9 common failure scenarios
- [FAQ](docs/faq.md) — 8 common questions
- [Contributing Skills](docs/contributing-skills.md) — how to add new agent roles

---

## Cost Reality

A typical coding task uses ~5,000 input + 2,000 output tokens.

| Usage | Tasks/Day | Flash Cost/Day | Monthly |
|-------|-----------|---------------|---------|
| Light | 20 | ~$0.04 | ~$1 |
| Normal | 50 | ~$0.10 | ~$3 |
| Heavy sprint | 200 | ~$0.40 | ~$12 |

Free tier (250 RPD) covers normal usage. Add a credit card and set a $20/month cap when you consistently hit the limit.

---

## Requirements

- **Node.js** >= 18
- **GNU Make** (macOS: `brew install make`)
- **shellcheck** (macOS: `brew install shellcheck`) — for script linting
- **1 Google account** — [get a free Gemini API key](https://aistudio.google.com)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the PR process and [docs/contributing-skills.md](docs/contributing-skills.md) for adding new agent skills.

---

## License

MIT — see [LICENSE](LICENSE).

> **Disclaimer:** This project uses the Google AI Studio API. Usage is subject to [Google's AI Studio Terms of Service](https://ai.google.dev/terms). API keys are stored locally in `~/.agent-team/.env.team` and are never transmitted to any server other than Google's.
