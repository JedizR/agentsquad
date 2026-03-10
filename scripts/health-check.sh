#!/usr/bin/env bash
# AgentSquad Health Check — v1.2
# Verify all Gemini agents are responding and not rate-limited.
# Uses single GEMINI_API_KEY shared across agents (per-agent overrides optional).
#
# Usage: ~/.agent-team/scripts/health-check.sh
#        Or: bash scripts/health-check.sh

set -e

# ── Load credentials ─────────────────────────────────────────────────────────
ENV_TEAM="$HOME/.agent-team/.env.team"
# shellcheck source=/dev/null
source "$ENV_TEAM" 2>/dev/null || {
  echo "❌ ~/.agent-team/.env.team not found. Run setup.sh first." && exit 1
}

# ── Verify gemini-cli is available ───────────────────────────────────────────
if ! command -v gemini > /dev/null 2>&1; then
  echo "❌ gemini CLI not found. Run: npm install -g @google/gemini-cli" && exit 1
fi

echo "AgentSquad Health Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# v1.2: per-agent keys fall back to GEMINI_API_KEY if not individually set
# Note: uses positional lists for bash 3.2 compatibility (macOS default bash)
ALL_PASS=true
AGENT_NAMES="Backend Frontend QA DevOps Consultant"

for name in $AGENT_NAMES; do
  # Resolve key by agent name (bash 3.2 compatible — no associative arrays)
  case "$name" in
    Backend)    key="${GEMINI_KEY_BACKEND:-${GEMINI_API_KEY:-}}" ;;
    Frontend)   key="${GEMINI_KEY_FRONTEND:-${GEMINI_API_KEY:-}}" ;;
    QA)         key="${GEMINI_KEY_QA:-${GEMINI_API_KEY:-}}" ;;
    DevOps)     key="${GEMINI_KEY_DEVOPS:-${GEMINI_API_KEY:-}}" ;;
    Consultant) key="${GEMINI_KEY_CONSULTANT:-${GEMINI_API_KEY:-}}" ;;
    *)          key="" ;;
  esac

  if [[ -z "$key" || "$key" == "your_key_here" ]]; then
    echo "⚠️  $name: Key not set — edit ~/.agent-team/.env.team"
    ALL_PASS=false
    continue
  fi

  response=$(GEMINI_API_KEY="$key" gemini -p "Reply with exactly: OK" \
    --approval-mode=yolo 2>&1) || true

  if echo "$response" | grep -qi "^OK"; then
    echo "✅ $name: Responding"
  elif echo "$response" | grep -q "429"; then
    echo "⚠️  $name: Rate limited (try again in a few minutes)"
    ALL_PASS=false
  elif echo "$response" | grep -qiE "401|403|invalid.*key"; then
    echo "❌ $name: Invalid API key"
    ALL_PASS=false
  else
    echo "❌ $name: Unexpected response — ${response:0:100}"
    ALL_PASS=false
  fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if $ALL_PASS; then
  echo "✅ All agents healthy. Team is ready."
  exit 0
else
  echo "⚠️  Some agents need attention. Check ~/.agent-team/.env.team"
  exit 1
fi
