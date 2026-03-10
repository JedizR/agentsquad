# Contributing to AgentSquad

Thanks for contributing. This covers the three main contribution types:
new skills, script changes, and documentation.

---

## Getting started

```bash
git clone https://github.com/JedizR/agentsquad
cd agentsquad
bash scripts/setup.sh
source ~/.agent-team/.env.team
~/.agent-team/scripts/health-check.sh
```

All agents should show healthy before you start.

---

## What we need most

- **New agent roles** — Mobile, Data Engineer, ML Engineer, Security Reviewer
- **Alternative LLM support** — OpenAI CLI, Ollama integrations
- **Reference file improvements** — Better patterns in `skills/*/references/`
- **Platform testing** — Reports from Linux distros, Windows WSL2

---

## Adding a new skill

Follow the full process in [docs/contributing-skills.md](docs/contributing-skills.md).

Short version:
1. Create `skills/your-role/SKILL.md` following the standard format
2. Add reference files in `skills/your-role/references/`
3. Test with a real Gemini call and include the output in your PR
4. Run shellcheck on any scripts you touch

---

## Script changes

All `.sh` files must pass shellcheck with zero errors and zero warnings:

```bash
shellcheck scripts/your-script.sh
```

Include a functional test in your PR description — the actual command you ran
and what came back.

---

## Documentation

Clear is better than thorough. Follow these patterns when writing docs:

- Start sentences with the subject, not "This"
- Prefer short sentences over complex ones
- Use code blocks for every command — readers copy-paste everything
- One concept per section
- Include the expected output when it matters

---

## PR process

1. Fork the repo and create a branch: `git checkout -b type/short-description`
   - `skill/mobile-engineer`
   - `fix/health-check-bash32`
   - `docs/update-customization`

2. Make your changes

3. Run shellcheck if you touched `.sh` files

4. Push and open a PR — the template will ask for test evidence

5. A maintainer will review within a few days

---

## What gets rejected

- PRs with no test evidence for script changes
- SKILL.md files that haven't been tested with a real Gemini call
- Changes that break bash 3.2 compatibility (no `declare -A`, no `[[` without fallback)
- API keys or credentials of any kind in the diff

---

## Questions

Open a [Discussion](https://github.com/JedizR/agentsquad/discussions) rather than
an issue for questions about how things work or ideas you're not sure about.
