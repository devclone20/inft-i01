#!/usr/bin/env bash
# inft-i01 — substrate setup. Installs the Pi coding agent + opensrc, verifies wiring.
set -euo pipefail

cd "$(dirname "$0")/.."

echo "── inft-i01 setup ──────────────────────────────"

if ! command -v node >/dev/null 2>&1; then
  echo "✗ Node.js is required (https://nodejs.org). Aborting." >&2
  exit 1
fi

echo "→ Installing Pi coding agent (substrate)…"
npm install -g --ignore-scripts @earendil-works/pi-coding-agent

echo "→ Installing opensrc (dependency source reader)…"
npm install -g opensrc

echo "→ Verifying wiring…"
for f in .pi/settings.json .pi/APPEND_SYSTEM.md soul/neural_soul.md identity.json skills/cmux/SKILL.md; do
  if [ -f "$f" ]; then echo "  ✓ $f"; else echo "  ✗ MISSING: $f" >&2; exit 1; fi
done

command -v pi >/dev/null 2>&1 && echo "  ✓ pi $(pi --version 2>/dev/null || echo installed)"
command -v opensrc >/dev/null 2>&1 && echo "  ✓ opensrc installed"

NAME=$(node -e "console.log(require('./identity.json').marketplace_name)")
echo ""
echo "── Done. Boot the agent from this directory: pi"
echo "   It answers to: \"$NAME\", \"iNFT\", and \"Pi\"."
echo "   BYOK: set your provider key (e.g. ANTHROPIC_API_KEY) or use /login inside pi."
