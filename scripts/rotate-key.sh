#!/usr/bin/env bash
# rotate-key.sh — Swap to backup Gemini API key on 429 rate limit.
# Integrates with gemini-call.sh via GEMINI_KEY_RESERVE_1.
#
# Usage: source ~/.agent-team/scripts/rotate-key.sh
#        rotate_key           # Rotates from primary to reserve key
#        rotate_key --status  # Show current active key slot
#
# After rotation, re-source .env.team to reload. Call rotate_key_restore
# when the primary key's rate limit window resets (typically midnight PT).

# Load credentials
ENV_TEAM="$HOME/.agent-team/.env.team"

rotate_key() {
  local mode="${1:-}"

  # shellcheck source=/dev/null
  source "$ENV_TEAM" 2>/dev/null || {
    echo "❌ ~/.agent-team/.env.team not found. Run setup.sh first." && return 1
  }

  if [[ "$mode" == "--status" ]]; then
    echo "Active key: ${AGENTSQUAD_ACTIVE_KEY:-primary (GEMINI_API_KEY)}"
    return 0
  fi

  # Check if reserve key is available
  if [[ -z "${GEMINI_KEY_RESERVE_1:-}" || "${GEMINI_KEY_RESERVE_1}" == "your_key_here" ]]; then
    echo "❌ No reserve key configured."
    echo "   Add GEMINI_KEY_RESERVE_1=your_backup_key to ~/.agent-team/.env.team"
    return 1
  fi

  # Check which key is currently active
  if [[ "${AGENTSQUAD_ACTIVE_KEY:-primary}" == "primary" ]]; then
    echo "⚠️  Primary key hit rate limit. Rotating to reserve key..."
    export GEMINI_API_KEY="$GEMINI_KEY_RESERVE_1"
    export AGENTSQUAD_ACTIVE_KEY="reserve"
    echo "✅ Now using GEMINI_KEY_RESERVE_1. Gemini calls will use reserve quota."
    echo "   Run 'rotate_key_restore' to switch back when primary resets (midnight PT)."
  else
    echo "⚠️  Already using reserve key. No additional keys available."
    echo "   Wait for rate limit reset (typically midnight PT) then run: rotate_key_restore"
    return 1
  fi
}

rotate_key_restore() {
  # shellcheck source=/dev/null
  source "$ENV_TEAM" 2>/dev/null || {
    echo "❌ ~/.agent-team/.env.team not found." && return 1
  }

  export AGENTSQUAD_ACTIVE_KEY="primary"
  echo "✅ Restored to primary GEMINI_API_KEY."

  # Verify primary key works
  local test_response
  test_response=$(GEMINI_API_KEY="${GEMINI_API_KEY:-}" gemini \
    -p "Reply with exactly: OK" --approval-mode=yolo 2>&1) || true

  if echo "$test_response" | grep -qi "OK"; then
    echo "✅ Primary key is healthy and responding."
  elif echo "$test_response" | grep -q "429"; then
    echo "⚠️  Primary key is still rate limited. Try again later."
    export AGENTSQUAD_ACTIVE_KEY="reserve"
    export GEMINI_API_KEY="${GEMINI_KEY_RESERVE_1:-}"
  else
    echo "⚠️  Unexpected response from primary key — check ~/.agent-team/.env.team"
  fi
}
