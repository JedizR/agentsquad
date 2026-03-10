#!/usr/bin/env bash
# strip-filler.sh — Remove LLM conversational preamble from Gemini output.
# Source this file to get the strip_filler function, or use strip_filler_stdin.
#
# Problem: LLMs inject filler like "Here is the code you requested:" before
#          the actual content, which breaks bash pipes and file reads.
#
# Strategy 1: If output has markdown code blocks (```), extract ALL block
#             contents and concatenate them. Explanation text between blocks
#             is silently dropped.
# Strategy 2: If no code blocks, strip leading lines matching common filler
#             patterns from the top of the file.
#
# Usage:
#   source ~/.agent-team/scripts/strip-filler.sh
#   strip_filler agent-output/raw.md agent-output/clean.ts
#
#   Or pipe:
#   gemini -p "..." | strip_filler_stdin > agent-output/clean.ts

strip_filler() {
  local input_file="$1"
  local output_file="$2"

  if [[ -z "$input_file" || -z "$output_file" ]]; then
    echo "Usage: strip_filler <input_file> <output_file>" >&2
    return 1
  fi
  if [[ ! -f "$input_file" ]]; then
    echo "❌ strip_filler: File not found: $input_file" >&2
    return 1
  fi

  # Strategy 1: extract content inside ALL code blocks and concatenate.
  # v1.3 fix: use `next` on closing fence so multiple blocks are all captured.
  # Explanation text between blocks is silently dropped (in_block=0 during those lines).
  # Uses awk -v to pass the fence pattern to avoid shell backtick command substitution.
  FENCE='```'
  if grep -q "^${FENCE}" "$input_file"; then
    awk -v fence="${FENCE}" '
      BEGIN { in_block = 0 }
      $0 ~ ("^" fence) {
        if (!in_block) { in_block = 1; next }
        else           { in_block = 0; next }
      }
      in_block { print }
    ' "$input_file" > "$output_file"
  else
    # Strategy 2: strip known preamble patterns from the top of the file
    grep -v -iE \
      "^(here is|here'?s|certainly!?|of course|sure[,!]|below is|the following|as requested|happy to)" \
      "$input_file" | \
    sed '/^[[:space:]]*$/d' \
    > "$output_file"
  fi

  # Safety net: if stripping produced an empty file, keep the original
  if [[ ! -s "$output_file" ]]; then
    cp "$input_file" "$output_file"
    echo "⚠️  strip_filler: Stripping produced empty output — keeping original." >&2
  fi

  return 0
}

# Stdin convenience wrapper
strip_filler_stdin() {
  local tmp_in tmp_out
  tmp_in=$(mktemp /tmp/sf-in.XXXXXX)
  tmp_out=$(mktemp /tmp/sf-out.XXXXXX)
  cat > "$tmp_in"
  strip_filler "$tmp_in" "$tmp_out"
  cat "$tmp_out"
  rm -f "$tmp_in" "$tmp_out"
}
