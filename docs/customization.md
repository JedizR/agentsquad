# Customization

How to adapt AgentSquad for your tech stack and team preferences.

---

## Changing agent models

Edit the Makefile in your project to swap models:

```makefile
# Default: Flash for compute-heavy tasks
backend:
	GEMINI_API_KEY=$(GEMINI_API_KEY) gemini -m gemini-2.5-flash \
	  --prompt "$(TASK)" --approval-mode=yolo > agent-output/backend-$(shell date +%s).md

# Option: Flash-Lite to save quota (good for simpler tasks)
backend:
	GEMINI_API_KEY=$(GEMINI_API_KEY) gemini -m gemini-2.5-flash-lite \
	  --prompt "$(TASK)" --approval-mode=yolo > agent-output/backend-$(shell date +%s).md
```

The Consultant uses `gemini-2.5-pro` by default for better reasoning. If you hit its 100 RPD limit, switch to `web-search` (alias with Google Search built in):

```makefile
consult:
	GEMINI_API_KEY=$(GEMINI_API_KEY) gemini -m web-search \
	  --prompt "$(TASK)" --approval-mode=yolo > agent-output/consult-$(shell date +%s).md
```

---

## Tailoring SKILL.md for your stack

The default SKILL.md files describe general best practices. For a specific project, copy the SKILL.md to your project's `agent-output/` and include the stack constraints in the task prompt rather than modifying the global file.

For permanent stack changes, edit `~/.agent-team/skills/<role>/SKILL.md` directly. Two sections to update:

**1. Identity section** — add your stack to the role description:
```markdown
## Identity

You are a Backend Engineer specializing in Python/FastAPI and PostgreSQL.
Your output is always production-ready Python code that follows PEP 8 and
the project's existing patterns.
```

**2. References section** — update file paths to your own reference docs:
```markdown
## References

- `/home/user/.agent-team/skills/backend-engineer/references/fastapi-patterns.md`
- `/home/user/.agent-team/skills/backend-engineer/references/sqlalchemy-patterns.md`
```

Then write the matching reference files in `~/.agent-team/skills/backend-engineer/references/`.

---

## Adding a new agent role

1. Create the directory structure:
```bash
mkdir -p ~/.agent-team/skills/mobile-engineer/references
```

2. Write `~/.agent-team/skills/mobile-engineer/SKILL.md`:
```markdown
---
name: mobile-engineer
version: 1.0.0
description: Activate when building React Native or Flutter mobile app
             screens, navigation, or device APIs.
---

## Identity

You are a Mobile Engineer specializing in React Native.
...
```

3. Symlink into Gemini's skills directory:
```bash
ln -sfn ~/.agent-team/skills/mobile-engineer \
  ~/.gemini/skills/mobile-engineer
```

4. Add a `make` target to your project Makefile:
```makefile
mobile: ## Dispatch Mobile Engineer agent
	GEMINI_API_KEY=$(or $(GEMINI_KEY_MOBILE),$(GEMINI_API_KEY)) gemini \
	  -m gemini-2.5-flash \
	  --prompt "$(TASK)" --approval-mode=yolo \
	  > agent-output/mobile-$(shell date +%s).md
```

5. Add the role to `TEAM.md` in your project so Claude knows about it.

---

## Per-agent API keys

If you hit the 250 RPD shared limit, separate keys give each agent its own quota.

In `~/.agent-team/.env.team`, uncomment and fill:
```bash
GEMINI_KEY_BACKEND=AIzaSy...key_for_backend
GEMINI_KEY_FRONTEND=AIzaSy...key_for_frontend
GEMINI_KEY_QA=AIzaSy...key_for_qa
GEMINI_KEY_DEVOPS=AIzaSy...key_for_devops
GEMINI_KEY_CONSULTANT=AIzaSy...key_for_consultant
```

The Makefile uses `$(or $(GEMINI_KEY_BACKEND),$(GEMINI_API_KEY))` so any unset key falls back to the shared key. You can add separate keys incrementally.

Each Google account gets its own 250 RPD (Flash) and 1,000 RPD (Flash-Lite) quota. Five accounts = 1,250 Flash requests/day.

---

## Adjusting strip-filler behavior

`strip-filler.sh` uses two strategies:

**Strategy 1 (default when code blocks exist):** Extract content from code fences only. Good for tasks where you want raw code without any markdown commentary.

**Strategy 2 (fallback):** Strip known conversational preamble patterns ("Here is", "Sure!", "I'll", etc.) but keep markdown structure. Good for Consultant research output where markdown headings matter.

To always use Strategy 2 (preserve markdown), edit `strip-filler.sh` and comment out the Strategy 1 block. Or write your own output processing step in the Makefile after the Gemini call.

---

## Adapting for different CI/CD workflows

The default `.github/workflows/shellcheck.yml` checks all `.sh` files on every PR. If you use GitLab CI, the equivalent `.gitlab-ci.yml` target is:

```yaml
shellcheck:
  stage: lint
  image: koalaman/shellcheck-alpine:stable
  script:
    - find . -name "*.sh" -exec shellcheck {} +
```

The `gemini-call.sh` wrapper doesn't depend on GitHub Actions. It works in any CI system that can run bash and has `GEMINI_API_KEY` in the environment.

---

## Using a proxy or self-hosted endpoint

If your organization routes AI API calls through a proxy, set `GEMINI_API_PROXY` in `.env.team` and update `gemini-call.sh` to use it. The `gemini` CLI respects standard HTTP proxy environment variables:

```bash
export HTTPS_PROXY=https://your-proxy.corp.example.com:3128
```

For a self-hosted OpenAI-compatible endpoint (e.g. local Ollama), you'd need to replace the `gemini` CLI calls with `curl` or a compatible CLI. The SKILL.md format works with any endpoint — only the scripts need updating.

---

## Claude Code memory and project context

When you run `/init-agent-team`, it generates `CLAUDE.md` for your project. Customize the **Tech Lead behavior** section to change how Claude routes tasks:

```markdown
## Routing rules for this project

- Auth changes → ALWAYS through Claude (security-sensitive)
- Database schema → Backend Engineer writes, Claude reviews
- UI components → Frontend Engineer, no review needed for styling
- Tests → QA Engineer for unit tests; Claude writes integration tests
- Infra → DevOps Engineer, Claude reviews before applying
```

The more specific your routing rules, the less back-and-forth during delivery.
