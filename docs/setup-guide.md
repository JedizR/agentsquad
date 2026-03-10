# Setup guide

This walks you from zero to a working 5-agent team. It takes about 10 minutes.

## Prerequisites

Before starting, verify these are installed:

```bash
node --version   # must be >= 18
make --version   # GNU Make (macOS: brew install make)
```

If you're on macOS and `make --version` shows `3.81`, that's the BSD version — it works, but you'll need `gmake` for some targets.

---

## Step 1: Get a Gemini API key

1. Go to [aistudio.google.com](https://aistudio.google.com)
2. Click **Get API Key** → **Create API key in new project**
3. Name the project `agentsquad`
4. Copy the key. It won't be shown again — paste it somewhere safe immediately.

The free tier gives you 250 requests/day on Flash and 1,000/day on Flash-Lite. That's enough for normal development without paying anything.

---

## Step 2: Clone and run setup

```bash
git clone https://github.com/JedizR/agentsquad
cd agentsquad
bash scripts/setup.sh
```

`setup.sh` does this in one shot:
- Checks Node.js >= 18 and GNU Make
- Installs `@google/gemini-cli` if missing
- Creates `~/.agent-team/` directory structure
- Creates `~/.agent-team/.env.team` (credential template)
- Copies scripts to `~/.agent-team/scripts/`
- Copies SKILL.md files to `~/.agent-team/skills/`
- Symlinks skills into `~/.gemini/skills/` so Gemini loads them automatically

---

## Step 3: Add your API key

```bash
# Edit the credentials file
nano ~/.agent-team/.env.team
```

Change `your_key_here` to your actual key:
```bash
GEMINI_API_KEY=AIzaSy...your_actual_key
```

The file is already `chmod 600` — only your user can read it.

---

## Step 4: Load credentials into your shell

```bash
source ~/.agent-team/.env.team
```

To do this automatically on every shell start, add it to your `.zshrc` or `.bashrc`:
```bash
echo 'source ~/.agent-team/.env.team' >> ~/.zshrc
```

Or use a session alias if you're on a shared machine:
```bash
alias loadteam='source ~/.agent-team/.env.team'
```

---

## Step 5: Verify all 5 agents respond

```bash
~/.agent-team/scripts/health-check.sh
```

You should see:
```
AgentSquad Health Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Backend: Responding
✅ Frontend: Responding
✅ QA: Responding
✅ DevOps: Responding
✅ Consultant: Responding
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All agents healthy. Team is ready.
```

If any agent shows "Key not set", re-check Step 3. If any shows "Rate limited", wait a few minutes and try again.

---

## Step 6: Bootstrap onto your project

Open Claude Code in your project directory:

```bash
cd ~/your-project
claude
```

Then in Claude Code, run:
```
/init-agent-team
```

This generates `CLAUDE.md`, `TEAM.md`, `Makefile`, and `.gemini/settings.json` for your project. From there you can run:

```bash
make team-health     # verify agents from the project
make backend TASK="implement the users API"
make qa TASK="write tests for src/api/users.ts"
```

---

## Migrating to a new machine

```bash
# From old machine:
~/.agent-team/scripts/migrate.sh user@new-machine

# Transfer API key separately (never over rsync):
scp ~/.agent-team/.env.team user@new-machine:~/.agent-team/.env.team

# On new machine:
bash ~/.agent-team/scripts/setup.sh
~/.agent-team/scripts/health-check.sh
```

---

## What gets created

After setup, your global home looks like this:

```
~/.agent-team/
├── .env.team                  # Your API keys (chmod 600)
├── .env.team.example          # Template — safe to share
├── .gitignore                 # Excludes .env.team if dir is git-tracked
├── scripts/
│   ├── setup.sh
│   ├── health-check.sh
│   ├── gemini-call.sh
│   ├── strip-filler.sh
│   ├── rotate-key.sh
│   └── migrate.sh
└── skills/
    ├── backend-engineer/SKILL.md  + references/
    ├── frontend-engineer/SKILL.md + references/
    ├── qa-engineer/SKILL.md       + references/
    ├── devops-engineer/SKILL.md   + references/
    ├── business-consultant/SKILL.md + references/
    └── tech-lead/SKILL.md         + references/
```
