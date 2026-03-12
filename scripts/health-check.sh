#!/usr/bin/env bash
# AgentSquad Health Check — v1.3
# Verify the agent team is configured and (optionally) responding.
#
# Usage:
#   health-check.sh           # --cheap mode (default): no API calls, 0 RPD
#   health-check.sh --cheap   # validate credentials + CLI only
#   health-check.sh --live    # make real API pings (costs 5 RPD via gemma-3-1b-it)
#
# v1.2: Per-agent key fallback to GEMINI_API_KEY; bash 3.2 compatible.
# v1.3: Add --cheap (default) and --live modes. Remove set -e (gemini exit codes
#        unreliable). Live pings use gemma-3-1b-it (14,400 RPD free) not Gemini
#        Flash (20 RPD) — health checks should not burn production quota.

MODE="cheap"
if [[ "${1:-}" == "--live" ]]; then
  MODE="live"
fi

# ── Load credentials ─────────────────────────────────────────────────────────
ENV_TEAM="$HOME/.agent-team/.env.team"
# shellcheck source=/dev/null
source "$ENV_TEAM" 2>/dev/null || {
  echo "❌ ~/.agent-team/.env.team not found. Run setup.sh first."
  exit 1
}

# ── Verify gemini-cli is available ───────────────────────────────────────────
if ! command -v gemini > /dev/null 2>&1; then
  echo "❌ gemini CLI not found. Run: npm install -g @google/gemini-cli"
  exit 1
fi

echo "AgentSquad Health Check ($MODE)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ALL_PASS=true
AGENT_NAMES="Backend Frontend QA DevOps Consultant"

for name in $AGENT_NAMES; do
  # Resolve key (bash 3.2 compatible — no associative arrays)
  case "$name" in
    Backend)    key="${GEMINI_KEY_BACKEND:-${GEMINI_API_KEY:-}}" ;;
    Frontend)   key="${GEMINI_KEY_FRONTEND:-${GEMINI_API_KEY:-}}" ;;
    QA)         key="${GEMINI_KEY_QA:-${GEMINI_API_KEY:-}}" ;;
    DevOps)     key="${GEMINI_KEY_DEVOPS:-${GEMINI_API_KEY:-}}" ;;
    Consultant) key="${GEMINI_KEY_CONSULTANT:-${GEMINI_API_KEY:-}}" ;;
    *)          key="" ;;
  esac

  if [[ -z "$key" || "$key" == "your_key_here" ]]; then
    echo "❌ $name: Key not set — edit ~/.agent-team/.env.team"
    ALL_PASS=false
    continue
  fi

  if [[ "$MODE" == "cheap" ]]; then
    # Cheap mode: key is non-empty and not the placeholder. No API call.
    echo "✅ $name: Key configured"
    continue
  fi

  # Live mode: ping using gemma-3-1b-it (14,400 RPD free tier).
  # Do NOT use Gemini Flash (20 RPD) for health pings.
  response=$(GEMINI_API_KEY="$key" GEMINI_MODEL="gemma-3-1b-it" \
    gemini --prompt "Reply with exactly: OK" --approval-mode=yolo 2>&1) || true

  if echo "$response" | grep -qi "ok"; then
    echo "✅ $name: Responding (gemma-3-1b-it)"
  elif echo "$response" | grep -qiE "429|quota.*exceeded|resource.*exhausted"; then
    echo "⚠️  $name: Rate limited — try again in a few minutes"
    ALL_PASS=false
  elif echo "$response" | grep -qiE "401|403|invalid.*key|api_key_invalid"; then
    echo "❌ $name: Invalid API key"
    ALL_PASS=false
  else
    echo "⚠️  $name: Unexpected response — ${response:0:100}"
    ALL_PASS=false
  fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if $ALL_PASS; then
  if [[ "$MODE" == "cheap" ]]; then
    echo "✅ All keys configured. Run with --live to test actual API responses."
  else
    echo "✅ All agents healthy. Team is ready."
  fi
  exit 0
else
  echo "⚠️  Some agents need attention. Check ~/.agent-team/.env.team"
  exit 1
fi
