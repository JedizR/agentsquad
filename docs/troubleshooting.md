# Troubleshooting

Nine things that break and how to fix them.

## Quick reference

| Symptom | Most likely cause | Jump to |
|---------|------------------|---------|
| `gemini: command not found` | Gemini CLI not installed | [#1](#1-gemini-command-not-found) |
| Agent returns empty output | Rate limit or network error | [#2](#2-agent-returns-empty-output) |
| Agent returns garbage code | Prompt too vague | [#3](#3-agent-returns-garbage-code) |
| `--approval-mode=yolo: unknown flag` | Old gemini-cli version | [#4](#4-approval-modeyolo-unknown-flag) |
| SKILL.md doesn't activate | Description doesn't match task wording | [#5](#5-skillmd-not-activating) |
| `Permission denied` on health-check.sh | Missing execute bit | [#6](#6-permission-denied-on-health-checksh) |
| Symlinks broken after OS upgrade | Path change on macOS | [#7](#7-symlinks-broken-after-os-upgrade) |
| Google Search not working | settings.json misconfigured | [#8](#8-google-search-not-working-in-business-consultant) |
| All agents rate-limited | Heavy parallel sprint | [#9](#9-all-agents-rate-limited-simultaneously) |

---

## 1. `gemini: command not found`

**Symptom:** Running `gemini` or `make backend TASK="..."` gives `command not found`.

**Cause:** The Gemini CLI package is not installed globally.

**Fix:**
```bash
npm install -g @google/gemini-cli
gemini --version  # verify
```

If you see `node: command not found` first, install Node.js 18+ from nodejs.org.

---

## 2. Agent returns empty output

**Symptom:** `agent-output/backend-*.md` is empty or just contains "YOLO mode is enabled."

**Cause:** Usually a 429 rate limit. Less often a network error or bad prompt.

**Fix:**
```bash
# Check what actually came back
cat agent-output/backend-*.md

# Run health check — tells you which agent is healthy
~/.agent-team/scripts/health-check.sh

# If rate limited, rotate to reserve key (if you have one)
source ~/.agent-team/scripts/rotate-key.sh
rotate_key

# Or just wait — Flash limits reset at midnight PT
```

Flash's 250 RPD limit resets daily. If you hit it consistently, add a credit card and set a $20/month cap — the API cost is low for normal usage.

---

## 3. Agent returns garbage code

**Symptom:** The agent wrote code that doesn't match the task, missed the framework, or invented APIs that don't exist.

**Cause:** The task prompt was too short or too vague.

**Fix:** Rewrite the task with more context. A good task prompt has five parts:

```markdown
CONTEXT: [what the project is, what already exists, what patterns to follow]
TASK: [exactly what to build — specific endpoints, component names, file paths]
CONSTRAINTS: [what NOT to do, what packages are available, what to escalate]
```

For Backend and Frontend tasks, always attach an `api-contract.md` first. Agents produce much better output when they have a contract to follow.

---

## 4. `--approval-mode=yolo: unknown flag`

**Symptom:** Gemini CLI throws `unknown flag: --approval-mode` or similar.

**Cause:** You're running an old version of `@google/gemini-cli`. The `--yolo` flag was deprecated; `--approval-mode=yolo` is the current syntax.

**Fix:**
```bash
npm update -g @google/gemini-cli
gemini --version  # check the updated version
```

If the update doesn't take, try `npm install -g @google/gemini-cli@latest`.

---

## 5. SKILL.md not activating

**Symptom:** The agent ignores the SKILL.md instructions and responds generically.

**Cause:** The `description` field in the SKILL.md frontmatter doesn't match how you phrased the task. Gemini loads skills based on semantic similarity between the task and the description.

**Fix:** Open the SKILL.md for the relevant agent and compare the `description` field to your task wording:

```yaml
---
name: backend-engineer
description: Activate when implementing server-side code including REST or GraphQL
             API endpoints, database schemas...
---
```

Either rephrase your task to match the description, or update the description to cover your use case. The description is the activation trigger — if there's no semantic overlap, the skill won't load.

---

## 6. Permission denied on `health-check.sh`

**Symptom:** `bash: ~/.agent-team/scripts/health-check.sh: Permission denied`

**Cause:** The execute bit got dropped — usually after copying files without preserving permissions.

**Fix:**
```bash
chmod +x ~/.agent-team/scripts/*.sh
```

`setup.sh` does this automatically, so re-running it also fixes the issue:
```bash
bash ~/.agent-team/scripts/setup.sh
```

---

## 7. Symlinks broken after OS upgrade

**Symptom:** `~/.gemini/skills/backend-engineer` is a broken symlink. Gemini doesn't load SKILL.md files.

**Cause:** macOS sometimes changes paths during major OS upgrades, breaking symlinks into `~/.agent-team/skills/`.

**Fix:** Re-run setup.sh — it recreates all symlinks:
```bash
bash ~/.agent-team/scripts/setup.sh
```

Verify afterwards:
```bash
ls -la ~/.gemini/skills/
```

Each entry should point to `~/.agent-team/skills/[role]` without a trailing `(broken)`.

---

## 8. Google Search not working in Business Consultant

**Symptom:** The Consultant agent responds with no search results, or `settings.json` throws a config error.

**Cause:** The `modelConfigs.customAliases` configuration in `.gemini/settings.json` is either missing or uses the wrong schema.

**Fix (simplest):** Skip the settings.json config entirely and use the built-in `web-search` alias directly:

```bash
GEMINI_API_KEY=$GEMINI_API_KEY \
  gemini -m web-search --prompt "your research question" --approval-mode=yolo
```

The `web-search` alias has Google Search pre-enabled with no configuration required.

**Fix (if you want the `consultant` alias):** Check that your `.gemini/settings.json` matches exactly:
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

---

## 9. All agents rate-limited simultaneously

**Symptom:** Every `make` target returns a 429 error. `health-check.sh` shows rate-limited for all agents.

**Cause:** A heavy parallel sprint exhausted Flash's 250 RPD limit. All 5 agents share the same quota on one key.

**Options:**

1. **Wait.** Flash limits reset at midnight Pacific Time. Flash-Lite (1,000 RPD) is usually still available.

2. **Use reserve key.** If you set `GEMINI_KEY_RESERVE_1` in `.env.team`:
   ```bash
   source ~/.agent-team/scripts/rotate-key.sh
   rotate_key
   ```

3. **Add a credit card** to AI Studio and set a $20/month cap. Paid tier removes the RPD limit.

4. **Add per-agent keys.** Create additional Google accounts, get separate API keys, and uncomment the `GEMINI_KEY_BACKEND`, `GEMINI_KEY_FRONTEND` etc. lines in `.env.team`. Each key gets its own 250 RPD quota.
