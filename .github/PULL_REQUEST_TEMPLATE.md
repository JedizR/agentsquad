## What this PR does

<!-- One paragraph describing the change. -->

## Type of change

- [ ] Bug fix (scripts, Makefile, SKILL.md)
- [ ] New agent skill
- [ ] Documentation update
- [ ] New script or make target
- [ ] LLM compatibility / platform support
- [ ] Other: ___

## Testing

<!-- Required for any script or SKILL.md change. -->

**shellcheck** (for .sh files):
```
shellcheck scripts/your-script.sh
# paste output — must be zero errors, zero warnings
```

**Functional test** (for scripts):
```bash
# command you ran
# output you got
```

**SKILL.md test** (for new or modified skills):
```
# Model tested: gemini-2.5-flash / flash-lite / pro
# Task prompt used:
# Gemini response excerpt showing skill activated correctly:
```

## Checklist

- [ ] shellcheck passes with zero errors/warnings on all modified `.sh` files
- [ ] Functional test documented above
- [ ] No `.env*` files or API keys in the diff
- [ ] No changes to `~/.agent-team/.env.team` template that would break existing installs
- [ ] Documentation updated if the change affects user-facing behavior
- [ ] New SKILL.md follows the format in [docs/contributing-skills.md](docs/contributing-skills.md)
