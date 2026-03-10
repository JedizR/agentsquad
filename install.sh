#!/usr/bin/env bash
# install.sh — Remote one-command installer for AgentSquad.
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/JedizR/agentsquad/main/install.sh)
#
# What this does:
#   1. Clones agentsquad to ~/agentsquad (or updates if already cloned)
#   2. Runs scripts/setup.sh from the cloned repo
#   3. Prints next steps
#
# What this does NOT do:
#   - Modify your .zshrc or .bashrc
#   - Create or overwrite ~/.agent-team/.env.team if it already exists
#   - Install anything without showing you what it's doing

set -euo pipefail

REPO_URL="https://github.com/JedizR/agentsquad.git"
INSTALL_DIR="${AGENTSQUAD_DIR:-$HOME/agentsquad}"
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

print_step() {
  printf "\n%b%s%b\n" "${BOLD}" "$1" "${RESET}"
}

print_ok() {
  printf "%b✅ %s%b\n" "${GREEN}" "$1" "${RESET}"
}

print_note() {
  printf "%bℹ️  %s%b\n" "${YELLOW}" "$1" "${RESET}"
}

# ── 1. Prerequisites ──────────────────────────────────────────────────────────

print_step "Checking prerequisites..."

if ! command -v node > /dev/null 2>&1; then
  printf "❌ Node.js is required (>= 18). Install from https://nodejs.org\n"
  exit 1
fi

NODE_MAJOR=$(node --version | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 18 ]; then
  printf "❌ Node.js %s found. Version 18+ required.\n" "$(node --version)"
  exit 1
fi

print_ok "Node.js $(node --version)"

if ! command -v git > /dev/null 2>&1; then
  printf "❌ git is required.\n"
  exit 1
fi

print_ok "git $(git --version | cut -d' ' -f3)"

# ── 2. Clone or update ────────────────────────────────────────────────────────

print_step "Setting up AgentSquad in $INSTALL_DIR..."

if [ -d "$INSTALL_DIR/.git" ]; then
  print_note "Directory exists — pulling latest changes."
  git -C "$INSTALL_DIR" pull --ff-only
  print_ok "Updated to latest"
else
  git clone "$REPO_URL" "$INSTALL_DIR"
  print_ok "Cloned to $INSTALL_DIR"
fi

# ── 3. Run setup ──────────────────────────────────────────────────────────────

print_step "Running setup.sh..."

bash "$INSTALL_DIR/scripts/setup.sh"

# ── 4. Next steps ─────────────────────────────────────────────────────────────

printf "\n"
printf "%b━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%b\n" "${BOLD}" "${RESET}"
printf "%b%bAgentSquad installed.%b\n" "${GREEN}" "${BOLD}" "${RESET}"
printf "%b━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%b\n" "${BOLD}" "${RESET}"
printf "\n"
printf "Next steps:\n\n"
printf "  1. Add your Gemini API key (free at aistudio.google.com):\n"
printf "     %bnano ~/.agent-team/.env.team%b\n\n" "${BOLD}" "${RESET}"
printf "  2. Load credentials:\n"
printf "     %bsource ~/.agent-team/.env.team%b\n\n" "${BOLD}" "${RESET}"
printf "  3. Verify all agents respond:\n"
printf "     %b~/.agent-team/scripts/health-check.sh%b\n\n" "${BOLD}" "${RESET}"
printf "  4. Bootstrap a project (inside Claude Code):\n"
printf "     %b/init-agent-team%b\n\n" "${BOLD}" "${RESET}"
printf "Docs: https://github.com/JedizR/agentsquad/tree/main/docs\n\n"
