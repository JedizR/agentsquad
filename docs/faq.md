# FAQ

## 1. Do I really need 5 separate Google accounts?

No. The v1.2 design uses one account and one API key. All 5 agents share `GEMINI_API_KEY` and get differentiated by the `-m` model flag, not by separate credentials.

Separate accounts were originally proposed for independent quota pools (250 RPD per agent instead of 250 RPD shared). The approach was dropped because it creates more problems than it solves: incognito-window juggling, Google anti-abuse risk from multiple accounts on the same IP, and fragile credential management.

Start with one key. Add more only if you hit the daily limit consistently.

---

## 2. What if I only have 1 Google account?

That's the default setup. Set `GEMINI_API_KEY` in `~/.agent-team/.env.team` and you're done. All five `make` targets work out of the box.

---

## 3. Can I use the Gemini API paid tier instead of free?

Yes. The paid tier uses the same API key — just add a credit card in AI Studio and set a monthly spend cap. No code changes required. The Makefile, scripts, and SKILL.md files all work identically.

For context: the free tier (250 RPD on Flash) handles normal solo development. Most days you won't hit the limit. Add billing when you do.

---

## 4. Does this work with Claude Team or only Claude Pro?

Both work. Claude Code is the interface, not the subscription tier. The scripts and SKILL.md files work with any Claude Code setup. The Gemini side doesn't care what Anthropic plan you're on.

---

## 5. Is the `--approval-mode=yolo` flag safe?

It depends on what you're asking agents to do.

The flag tells Gemini to run tool calls (file reads, file writes, shell commands) without asking for confirmation. For code generation tasks, this is fine — you're reviewing the output before integrating it. For tasks that modify files directly, treat the output directory as the agent's sandbox and review before merging.

The Makefile by default writes to `agent-output/` which is gitignored. Nothing goes to production without Claude's review step. That's the safeguard.

If you're worried about a specific task, run without `--approval-mode=yolo` first to see what tools the agent wants to invoke.

---

## 6. Can I use other LLMs (OpenAI, Ollama) instead of Gemini?

The SKILL.md format is open (`agentskills.io`) and model-agnostic. The scripts assume the Gemini CLI interface (`gemini --prompt "..." -m model-name`), so swapping LLMs requires updating the scripts.

Community contributions for OpenAI and Ollama integrations are welcome — see [Contributing](../CONTRIBUTING.md).

---

## 7. Are my API keys safe? Does AgentSquad store them anywhere?

Keys live only in `~/.agent-team/.env.team` on your local machine. AgentSquad doesn't send keys to any server other than Google's API endpoint when you make a call. The `.env.team` file is never committed to git (protected by `.gitignore` and `~/.agent-team/.gitignore`).

To revoke a compromised key: go to [aistudio.google.com](https://aistudio.google.com) → Manage API keys → Revoke.

---

## 8. What happens when Gemini CLI updates and breaks the commands?

Two things protect you:

1. **`COMPATIBILITY.md`** tracks the tested Gemini CLI version range for each AgentSquad release.

2. **`.github/workflows/compatibility.yml`** runs weekly and flags breaking changes.

When the CLI breaks, check [GitHub Issues](https://github.com/JedizR/agentsquad/issues) for a reported fix. Common breakage points are documented in the [Troubleshooting guide](troubleshooting.md). Flag new ones by opening an issue with the label `compatibility`.
