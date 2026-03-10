#!/usr/bin/env bash
# migrate.sh — Migrate ~/.agent-team/ to a new machine via rsync.
# Excludes .env.team (must be transferred manually for security).
#
# Usage: bash scripts/migrate.sh user@new-machine.local
#        bash scripts/migrate.sh user@192.168.1.100

set -e

TARGET="$1"
if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 user@hostname"
  echo ""
  echo "Example: $0 john@new-macbook.local"
  echo ""
  echo "This will sync ~/.agent-team/ to the target machine,"
  echo "excluding .env.team (transfer that manually for security)."
  exit 1
fi

echo "Migrating ~/.agent-team/ to $TARGET..."
echo "(Excluding .env.team — transfer manually for security)"
echo ""

rsync -avz --exclude='.env.team' "$HOME/.agent-team/" "${TARGET}:~/.agent-team/"

echo ""
echo "✅ Migration complete (scripts and skills transferred)."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  MANUAL STEPS REQUIRED:"
echo ""
echo "1. Transfer credentials securely:"
echo "   scp ~/.agent-team/.env.team ${TARGET}:~/.agent-team/.env.team"
echo "   ssh ${TARGET} chmod 600 ~/.agent-team/.env.team"
echo ""
echo "2. On the new machine, run:"
echo "   ~/.agent-team/scripts/setup.sh"
echo "   ~/.agent-team/scripts/health-check.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
