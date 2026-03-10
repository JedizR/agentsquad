#!/usr/bin/env bash
# AgentSquad Setup Script — v1.3
# One-shot system setup: installs gemini-cli, creates ~/.agent-team/ structure,
# sets up credentials template, and symlinks skills into ~/.gemini/skills/.
#
# Usage: bash scripts/setup.sh
#        Or: chmod +x scripts/setup.sh && ./scripts/setup.sh

set -e

# ── 1. OS Detection ──────────────────────────────────────────────────────────
OS=$(uname -s)
case "$OS" in
  Darwin) echo "✅ Detected: macOS" ;;
  Linux)  echo "✅ Detected: Linux" ;;
  *)      echo "❌ Unsupported OS: $OS. Use macOS or Linux (WSL2 on Windows)." && exit 1 ;;
esac

# ── 2. Check bash version (macOS ships bash 3.2 — warn) ─────────────────────
BASH_MAJOR="${BASH_VERSINFO[0]}"
if [[ "$BASH_MAJOR" -lt 4 ]]; then
  echo "⚠️  bash $BASH_VERSION detected. Some features may not work."
  echo "   On macOS: brew install bash"
fi

# ── 3. Check Node.js >= 18 ───────────────────────────────────────────────────
if ! command -v node > /dev/null 2>&1; then
  echo "❌ Node.js not found. Install from https://nodejs.org (v18+)" && exit 1
fi
NODE_MAJOR=$(node -e "process.stdout.write(process.versions.node.split('.')[0])")
if [[ "$NODE_MAJOR" -lt 18 ]]; then
  echo "❌ Node.js $NODE_MAJOR found. Node.js >= 18 required." && exit 1
fi
echo "✅ Node.js $(node --version)"

# ── 4. Check GNU Make ────────────────────────────────────────────────────────
if ! make --version 2>&1 | grep -q "GNU"; then
  echo "⚠️  GNU Make not found. On macOS: brew install make (then use gmake)"
else
  echo "✅ $(make --version 2>&1 | head -1)"
fi

# ── 5. Install gemini-cli if missing ─────────────────────────────────────────
if ! command -v gemini > /dev/null 2>&1; then
  echo "Installing @google/gemini-cli..."
  npm install -g @google/gemini-cli
else
  GEMINI_VER=$(gemini --version 2>/dev/null || echo "(version unknown)")
  echo "✅ gemini $GEMINI_VER"
fi

# ── 6. Create ~/.agent-team/ structure ───────────────────────────────────────
mkdir -p ~/.agent-team/scripts
for role in tech-lead backend-engineer frontend-engineer qa-engineer devops-engineer business-consultant; do
  mkdir -p "$HOME/.agent-team/skills/$role/references"
done
echo "✅ ~/.agent-team/ structure created"

# ── 7. Create .gitignore inside ~/.agent-team/ ───────────────────────────────
if [[ ! -f "$HOME/.agent-team/.gitignore" ]]; then
  printf '.env.team\n*.env\n' > "$HOME/.agent-team/.gitignore"
  echo "✅ ~/.agent-team/.gitignore created"
else
  echo "✅ ~/.agent-team/.gitignore already exists"
fi

# ── 8. Set up .env.team if it doesn't exist ──────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_TEAM="$HOME/.agent-team/.env.team"

if [[ ! -f "$ENV_TEAM" ]]; then
  # Try to copy from .env.team.example in the repo root
  EXAMPLE="${SCRIPT_DIR}/../.env.team.example"
  if [[ -f "$EXAMPLE" ]]; then
    cp "$EXAMPLE" "$ENV_TEAM"
  else
    {
      printf '# AgentSquad credentials — v1.2 single-key setup\n'
      printf '# Get your key at: aistudio.google.com -> Get API Key\n'
      printf 'GEMINI_API_KEY=your_key_here\n'
      printf '\n# Optional per-agent key overrides:\n'
      printf '# GEMINI_KEY_BACKEND=your_key_here\n'
      printf '# GEMINI_KEY_FRONTEND=your_key_here\n'
      printf '# GEMINI_KEY_QA=your_key_here\n'
      printf '# GEMINI_KEY_DEVOPS=your_key_here\n'
      printf '# GEMINI_KEY_CONSULTANT=your_key_here\n'
      printf '# GEMINI_KEY_RESERVE_1=your_key_here\n'
    } > "$ENV_TEAM"
  fi
  chmod 600 "$ENV_TEAM"
  echo "✅ ~/.agent-team/.env.team created — set GEMINI_API_KEY from aistudio.google.com"
else
  echo "✅ ~/.agent-team/.env.team already exists (not overwritten)"
fi

# ── 9. Copy scripts from repo to ~/.agent-team/scripts/ ─────────────────────
SCRIPTS_SRC="${SCRIPT_DIR}"
SCRIPTS_DST="$HOME/.agent-team/scripts"

for script in setup.sh health-check.sh rotate-key.sh gemini-call.sh strip-filler.sh migrate.sh; do
  if [[ -f "${SCRIPTS_SRC}/${script}" ]]; then
    cp "${SCRIPTS_SRC}/${script}" "${SCRIPTS_DST}/${script}"
    chmod +x "${SCRIPTS_DST}/${script}"
    echo "✅ Installed script: $script"
  fi
done

# ── 10. Copy skills from repo to ~/.agent-team/skills/ ───────────────────────
SKILLS_SRC="${SCRIPT_DIR}/../skills"
if [[ -d "$SKILLS_SRC" ]]; then
  for role in tech-lead backend-engineer frontend-engineer qa-engineer devops-engineer business-consultant; do
    if [[ -d "${SKILLS_SRC}/${role}" ]]; then
      cp -r "${SKILLS_SRC}/${role}/." "$HOME/.agent-team/skills/${role}/"
      echo "✅ Installed skill: $role"
    fi
  done
fi

# ── 11. Symlink skills into ~/.gemini/skills/ ────────────────────────────────
mkdir -p "$HOME/.gemini/skills"
for role in tech-lead backend-engineer frontend-engineer qa-engineer devops-engineer business-consultant; do
  target="$HOME/.gemini/skills/$role"
  source="$HOME/.agent-team/skills/$role"
  if [[ ! -e "$target" ]]; then
    ln -s "$source" "$target" 2>/dev/null \
      || cp -r "$source" "$target"
    echo "✅ Linked skill: $role"
  else
    echo "✅ Skill already linked: $role"
  fi
done

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.agent-team/.env.team — set GEMINI_API_KEY from aistudio.google.com"
echo "  2. Add to your shell: source ~/.agent-team/.env.team"
echo "  3. Run: ~/.agent-team/scripts/health-check.sh"
echo "  4. In any project: /init-agent-team"
