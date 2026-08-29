#!/usr/bin/env bash
# inft-i01 — boot the agent from this repo, with its project skills trusted.
# Hermes injects the project's AGENTS.md chain (git root → cwd) unconditionally, so the
# soul carried in AGENTS.md loads with or without this script. What `hermes skills trust`
# adds — and all it adds — is discovery of the project skills under .hermes/skills; the
# grant is persisted. The repo-root SOUL.md is not injected by Hermes at all (it reads
# SOUL.md from ~/.hermes/SOUL.md only). Extra args pass through to `hermes chat`.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v hermes >/dev/null 2>&1; then
  echo "✗ 'hermes' not found. Run: bash scripts/setup.sh"
  echo "  (or install directly: curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash)"
  exit 1
fi

hermes skills trust "$PWD" >/dev/null 2>&1 || true
exec hermes chat "$@"
