#!/usr/bin/env bash
# gemini-call.sh — Sourceable retry wrapper for Gemini CLI with filler stripping.
# Provides call_gemini() with retry, backoff, escalation detection,
# and Gemma fallback for quota exhaustion.
#
# Usage:
#   source ~/.agent-team/scripts/gemini-call.sh
#   call_gemini "$GEMINI_API_KEY" "prompt text" "agent-output/output.ts"
#
# Model selection: set GEMINI_MODEL env var before sourcing, or configure via
# .gemini/settings.json in your project root. The -m CLI flag is NOT used —
# removed in v1.4 due to gemini-cli 0.32.1 incompatibility (model name format
# changed; CLI errors with "unexpected model name format" on bare model IDs).
#
# Quota fallback ladder (auto, when 429 hit):
#   Primary key → GEMINI_KEY_RESERVE_1 → GEMINI_KEY_GEMMA (gemma-3-27b-it)
#
# v1.2: Single shared GEMINI_API_KEY; per-agent override via $1.
# v1.3: Escalation detector — alerts on [ESCALATE TO CLAUDE] in output.
# v1.4: Fix || true exit-code masking; remove -m flag; prompt via temp file;
#        add Gemma fallback; detect CLI error output even on exit 0.

# Load strip_filler if available
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$_SCRIPT_DIR/strip-filler.sh" ]]; then
  # shellcheck disable=SC1091  # dynamic path — resolved at runtime
  source "$_SCRIPT_DIR/strip-filler.sh"
fi

# _gemini_looks_like_error <result>
# Returns 0 (true) if the result string looks like a CLI or API error.
# Gemini-cli sometimes exits 0 even on API-level failures.
_gemini_looks_like_error() {
  echo "$1" | grep -qiE \
    "^error:|invalid configuration|unexpected model|^usage:|^commands:|error in:.*model|\
expected object|received string|^options \[|^  -"
}

call_gemini() {
  local key="$1"
  local prompt="$2"
  local output_file="$3"
  # $4 (model) accepted but ignored — use GEMINI_MODEL env var instead.
  # Kept for backwards-compatibility; will be removed in v2.0.
  if [[ -n "${4:-}" ]]; then
    printf 'call_gemini: model arg ("%s") is deprecated — set GEMINI_MODEL instead.\n' \
      "$4" >&2
  fi

  # Write prompt to temp file: avoids E2BIG (arg list too long) and
  # quoting fragility when tasks contain quotes, parens, or backticks.
  local tmp_prompt
  tmp_prompt=$(mktemp /tmp/agentsquad-prompt-XXXXXX)
  printf '%s' "$prompt" > "$tmp_prompt"

  local attempt
  for attempt in 1 2 3; do
    local result exit_code

    result=$(GEMINI_API_KEY="$key" \
      gemini --prompt "$(cat "$tmp_prompt")" --approval-mode=yolo 2>&1)
    exit_code=$?

    # Treat CLI error output as failure even when exit_code is 0.
    if [[ $exit_code -ne 0 ]] || _gemini_looks_like_error "$result"; then
      exit_code=1
    fi

    if [[ $exit_code -eq 0 ]] && [[ -n "$result" ]]; then
      rm -f "$tmp_prompt"

      local raw_file="${output_file}.raw"
      printf '%s\n' "$result" > "$raw_file"

      if declare -f strip_filler > /dev/null 2>&1; then
        strip_filler "$raw_file" "$output_file"
        rm -f "$raw_file"
      else
        mv "$raw_file" "$output_file"
      fi

      # v1.3: Escalation detector
      if grep -q "\[ESCALATE TO CLAUDE\]" "$output_file" 2>/dev/null; then
        printf "\n🚨 ESCALATION REQUIRED — agent flagged a decision in: %s\n" \
          "$output_file"
        printf "   Search for [ESCALATE TO CLAUDE] and resolve before integrating.\n\n"
      fi

      return 0

    elif echo "$result" | grep -qiE "429|quota.*exceeded|resource.*exhausted"; then
      echo "⚠️  Rate limit (attempt $attempt/3). Waiting $((attempt * 15))s..."
      sleep $((attempt * 15))
      # Attempt 2: switch to reserve key.
      # Attempt 3: switch to Gemma fallback key (14,400 RPD free tier).
      if [[ $attempt -eq 2 ]] && [[ -n "${GEMINI_KEY_RESERVE_1:-}" ]]; then
        key="$GEMINI_KEY_RESERVE_1"
        echo "   Switched to GEMINI_KEY_RESERVE_1..."
      elif [[ $attempt -eq 3 ]] && [[ -n "${GEMINI_KEY_GEMMA:-}" ]]; then
        key="$GEMINI_KEY_GEMMA"
        GEMINI_MODEL="${GEMINI_MODEL_FALLBACK:-gemma-3-27b-it}"
        export GEMINI_MODEL
        echo "   Switched to Gemma fallback (${GEMINI_MODEL}, 14,400 RPD)..."
      fi

    elif echo "$result" | grep -qiE "401|403|invalid.*api.*key|api_key_invalid"; then
      rm -f "$tmp_prompt"
      echo "❌ Invalid API key. Check ~/.agent-team/.env.team."
      return 1

    elif echo "$result" | grep -qiE "500|503|server.*error|overloaded"; then
      echo "⚠️  Server error (attempt $attempt/3). Waiting $((attempt * 5))s..."
      sleep $((attempt * 5))

    else
      echo "❌ Unexpected error (attempt $attempt/3): ${result:0:200}"
      if [[ $attempt -lt 3 ]]; then
        sleep $((attempt * 10))
      fi
    fi
  done

  rm -f "$tmp_prompt"
  echo "❌ All 3 attempts failed."
  return 1
}
