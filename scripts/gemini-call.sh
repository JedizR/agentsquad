#!/usr/bin/env bash
# gemini-call.sh — Sourceable retry wrapper for Gemini CLI with filler stripping.
# Provides call_gemini() function with automatic retry, backoff, and escalation detection.
#
# Usage:
#   source ~/.agent-team/scripts/gemini-call.sh
#   call_gemini "$GEMINI_API_KEY" "prompt text" "agent-output/output.ts"
#   call_gemini "$GEMINI_API_KEY" "prompt text" "agent-output/output.ts" "gemini-2.5-flash"
#
# v1.2: Uses GEMINI_API_KEY (single shared key) by default.
#        Pass any key as $1 to use a per-agent override.
# v1.3: Escalation detector — alerts when agent flags [ESCALATE TO CLAUDE].

# Load strip_filler if available
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$_SCRIPT_DIR/strip-filler.sh" ]]; then
  # shellcheck disable=SC1091  # dynamic path — resolved at runtime
  source "$_SCRIPT_DIR/strip-filler.sh"
fi

call_gemini() {
  local key="$1"
  local prompt="$2"
  local output_file="$3"
  local model="${4:-}"

  local model_flag=""
  if [[ -n "$model" ]]; then
    model_flag="-m $model"
  fi

  local attempt
  for attempt in 1 2 3; do
    local result
    # shellcheck disable=SC2086
    result=$(GEMINI_API_KEY="$key" gemini $model_flag \
      -p "$prompt" --approval-mode=yolo 2>&1) || true
    local exit_code=$?

    if [[ $exit_code -eq 0 ]] && [[ -n "$result" ]]; then
      # Write raw output, then strip conversational filler
      local raw_file="${output_file}.raw"
      printf '%s\n' "$result" > "$raw_file"

      if declare -f strip_filler > /dev/null 2>&1; then
        strip_filler "$raw_file" "$output_file"
        rm -f "$raw_file"
      else
        mv "$raw_file" "$output_file"
      fi

      # v1.3: Escalation detector — alert immediately if agent flagged a decision
      if grep -q "\[ESCALATE TO CLAUDE\]" "$output_file" 2>/dev/null; then
        echo ""
        echo "🚨 ESCALATION REQUIRED — agent flagged a decision in: $output_file"
        echo "   Search for [ESCALATE TO CLAUDE] and resolve before integrating."
        echo ""
      fi

      return 0

    elif echo "$result" | grep -q "429"; then
      echo "⚠️  Rate limit (attempt $attempt/3). Waiting $((attempt * 15))s..."
      sleep $((attempt * 15))
      # On 3rd attempt, try reserve key if available
      if [[ $attempt -eq 2 ]]; then
        key="${GEMINI_KEY_RESERVE_1:-${GEMINI_API_KEY:-$key}}"
      fi

    elif echo "$result" | grep -qiE "401|403|invalid.*api.*key"; then
      echo "❌ Invalid API key. Check ~/.agent-team/.env.team."
      return 1

    elif echo "$result" | grep -qiE "500|503|server.*error"; then
      echo "⚠️  Server error (attempt $attempt/3). Waiting $((attempt * 5))s..."
      sleep $((attempt * 5))

    else
      echo "❌ Unexpected error: ${result:0:200}"
      return 1
    fi
  done

  echo "❌ All 3 attempts failed for this agent."
  return 1
}
