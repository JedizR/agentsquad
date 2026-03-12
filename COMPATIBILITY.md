# Compatibility

Tested version matrix for AgentSquad and its dependencies.

---

## AgentSquad v1.1.0 (current)

| Component | Minimum | Tested | Notes |
|-----------|---------|--------|-------|
| `@google/gemini-cli` | 0.32.1 | 0.32.1 | `-m` flag removed; use `GEMINI_MODEL` env var |
| Node.js | 18.0 | 21.7.3 | Required for gemini-cli |
| GNU Make | 3.81 | 3.81 | macOS default (BSD). Works. |
| bash | 3.2 | 3.2 / 5.x | 3.2 = macOS default. All scripts compatible. |
| shellcheck | 0.8.0 | 0.11.0 | 0.8.0 = Ubuntu 22.04. Passes with SC1091 disable directives. |
| macOS | 12 Monterey | 15 Sequoia | Confirmed |
| Ubuntu | 22.04 | 22.04 | Confirmed via Docker |
| Windows WSL2 | — | — | Untested. Contributions welcome. |

---

## Gemini model availability (2026-03, live data)

| Model | Free RPD | Recommended for |
|-------|----------|----------------|
| `gemini-3-flash` | 20 | Standard agent tasks |
| `gemini-2.5-flash` | 20 | Standard agent tasks |
| `gemini-2.5-flash-lite` | 20 | Lighter tasks |
| `gemini-3.1-flash-lite` | 500 | High-volume lightweight tasks |
| `gemini-3.1-pro` | 0 | **Not usable on free tier** |
| `gemma-3-1b-it` | 14,400 | Health checks only |
| `gemma-3-4b-it` | 14,400 | Simple boilerplate |
| `gemma-3-12b-it` | 14,400 | Standard tasks on Gemma budget |
| `gemma-3-27b-it` | 14,400 | Near-Flash quality, `*-lite` targets |

**Default in v1.1.0:** `gemini-3-flash` (20 RPD free). Override via `BACKEND_MODEL` etc. in `.env.team`.

Model availability changes. If a model stops working, check
[AI Studio](https://aistudio.google.com) for current names and update `BACKEND_MODEL` in `.env.team`.

---

## Known issues by version

### gemini-cli 0.32.1 — `-m` flag model name format change

The `-m gemini-2.5-flash` flag format is broken in 0.32.1. It returns:
```
gemini: error: unexpected model name format
```
or silently writes CLI help/error text to the output file with exit code 0.

**Fix (v1.1.0):** The `-m` flag is removed from all Makefile targets and
`gemini-call.sh`. Model is now set via `GEMINI_MODEL` env var or
`.gemini/settings.json`. Existing installs: run `setup.sh` to update scripts.

### gemini-cli 0.32.1 — Exit code 0 on API errors

Gemini-cli 0.32.1 sometimes exits 0 even when the API returns an error. The
`call_gemini()` function now detects known error patterns in the result body
(via `_gemini_looks_like_error`) even when exit code is 0.

### gemini-cli < 0.32.x — `--approval-mode` flag

Earlier versions used `--yolo` (deprecated). If you see `unknown flag: --approval-mode`:

```bash
npm install -g @google/gemini-cli@latest
```

### shellcheck 0.7.x

ShellCheck 0.7.x may report SC1091 as an error rather than info, causing CI to fail.
All scripts include `# shellcheck disable=SC1091` where needed.

---

## Reporting compatibility issues

If you find a broken combination, open an issue with:

- Your OS and version
- `gemini --version` output
- `node --version` output
- `shellcheck --version` output
- The exact error message

Label it `compatibility` so it gets tracked in the right milestone.

The `.github/workflows/compatibility.yml` workflow runs weekly and automatically
flags new Gemini CLI versions that break the expected interface.
