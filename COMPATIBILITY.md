# Compatibility

Tested version matrix for AgentSquad and its dependencies.

---

## AgentSquad v1.0.0

| Component | Minimum | Tested | Notes |
|-----------|---------|--------|-------|
| `@google/gemini-cli` | 0.1.0 | 0.1.x | `--approval-mode=yolo` required |
| Node.js | 18.0 | 21.7.3 | Required for gemini-cli |
| GNU Make | 3.81 | 3.81 | macOS default (BSD). Works. |
| bash | 3.2 | 3.2 / 5.x | 3.2 = macOS default. All scripts compatible. |
| shellcheck | 0.8.0 | 0.11.0 | 0.8.0 = Ubuntu 22.04. Passes with SC1091 disable directives. |
| macOS | 12 Monterey | 15 Sequoia | Earlier versions untested |
| Ubuntu | 22.04 | 22.04 | Confirmed via Docker |
| Windows WSL2 | — | — | Untested. Contributions welcome. |

---

## Gemini model availability

| Model alias | As of | Status |
|-------------|-------|--------|
| `gemini-2.5-flash` | 2026-03 | Available on free tier |
| `gemini-2.5-flash-lite` | 2026-03 | Available on free tier |
| `gemini-2.5-pro` | 2026-03 | Available on free tier (100 RPD) |
| `web-search` | 2026-03 | Built-in alias with Google Search |

Model availability changes. If a model alias stops working, check
[AI Studio](https://aistudio.google.com) for current model names and update
the Makefile `-m` flags accordingly.

---

## Known issues by version

### Gemini CLI < 0.1.x

The `--approval-mode=yolo` flag did not exist. Earlier versions used `--yolo`
(deprecated). If you see `unknown flag: --approval-mode`, run:

```bash
npm install -g @google/gemini-cli@latest
```

### shellcheck 0.7.x

ShellCheck 0.7.x may report SC1091 (dynamic source path) as an error rather than
an info-level finding, causing CI to fail. All scripts include
`# shellcheck disable=SC1091` where needed, which is recognized by 0.7.x and later.

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
