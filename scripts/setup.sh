#!/usr/bin/env bash
# inft-i01 — substrate setup. Installs the Hermes Agent (Nous Research, MIT) with
# its official installer, verifies this repo's wiring, and never uses sudo.
# Prints every command before it runs. Safe to re-run (installs are idempotent).
set -euo pipefail
cd "$(dirname "$0")/.."

HERMES_INSTALL_URL="${HERMES_INSTALL_URL:-https://hermes-agent.nousresearch.com/install.sh}"
OPENSRC_VERSION="${OPENSRC_VERSION:-0.7.3}"
OPENSRC_PKG="opensrc@${OPENSRC_VERSION}"

say() { printf '%s\n' "$*"; }

say "── inft-i01 setup ─────────────────────────────────────────────"

# ── Preflight ────────────────────────────────────────────────────
command -v git     >/dev/null 2>&1 || { say "✗ git is required (see FORGE.md Step 0)."; exit 1; }
command -v curl    >/dev/null 2>&1 || { say "✗ curl is required to fetch the Hermes installer."; exit 1; }
command -v python3 >/dev/null 2>&1 || { say "✗ python3 is required (the scripts read and write identity.json with it)."; exit 1; }
say "  ✓ git, curl and python3 present"

# ── Install the substrate: Hermes Agent (no sudo) ────────────────
if command -v hermes >/dev/null 2>&1; then
  say "  ✓ hermes already installed ($(hermes --version 2>/dev/null || echo present))"
  INSTALL_MODE=present
else
  say "→ Installing the Hermes Agent (Nous Research, MIT)…"
  say "  \$ curl -fsSL $HERMES_INSTALL_URL | bash"
  curl -fsSL "$HERMES_INSTALL_URL" | bash
  INSTALL_MODE=installed
  command -v hermes >/dev/null 2>&1 || {
    say "  ⚠ 'hermes' is not on PATH yet — open a new shell, or add the installer's"
    say "    bin directory to PATH, then re-run this script."
  }
fi

# opensrc is an independent helper (read real dependency source before vendoring).
if command -v npm >/dev/null 2>&1; then
  if npm install -g --ignore-scripts "$OPENSRC_PKG" >/dev/null 2>&1; then
    say "  ✓ opensrc installed"
  else
    say "  ! opensrc skipped (optional helper; needs a writable npm prefix)"
  fi
fi

# ── Verify repo wiring ───────────────────────────────────────────
say "→ Verifying repo wiring…"
for f in SOUL.md soul/neural_soul.md identity.json skills/cmux/SKILL.md FORGE.md; do
  [ -f "$f" ] && say "  ✓ $f" || { say "  ✗ MISSING: $f"; exit 1; }
done
[ -e ".hermes/skills" ] && say "  ✓ .hermes/skills → ../skills (project skills, loaded once trusted)"
command -v hermes >/dev/null 2>&1 && say "  ✓ hermes $(hermes --version 2>/dev/null || echo installed) ($INSTALL_MODE)"

NAME="$(python3 -c "import json;print(json.load(open('identity.json'))['marketplace_name'])" 2>/dev/null || echo 'iNFT i01')"
say ""
say "── Substrate ready. Next:"
say "   1) Personalize:     bash scripts/personalize.sh \"Your Agent Name\""
say "   2) Connect a model: hermes model    (you type the key, never the assistant)"
say "   3) Boot:            bash scripts/boot.sh  (trusts this project, then 'hermes chat')"
say "   Current name: \"$NAME\" — it also answers to \"iNFT\" and \"Hermes\"."
