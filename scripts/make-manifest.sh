#!/usr/bin/env bash
# inft-i01 — regenerate metadata/manifest.json with SHA-256 of every sealed-class file.
# Run after any change to soul/, identity.json, skills/, docs/ or .pi/.
set -euo pipefail

cd "$(dirname "$0")/.."

FILES=$(
  { echo "identity.json"
    echo "AGENTS.md"
    find soul docs .pi skills -type f \( -name "*.md" -o -name "*.json" -o -name "*.sh" -o -name "LICENSE" \) | sort
  }
)

{
  echo '{'
  echo '  "manifest_version": 1,'
  echo "  \"generated\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
  echo '  "algorithm": "sha256",'
  echo '  "repo": "https://github.com/devclone20/inft-i01",'
  echo '  "files": {'
  first=true
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    h=$(shasum -a 256 "$f" | awk '{print $1}')
    $first || echo ','
    first=false
    printf '    "%s": "%s"' "$f" "$h"
  done <<< "$FILES"
  echo ''
  echo '  }'
  echo '}'
} > metadata/manifest.json

echo "✓ metadata/manifest.json regenerated ($(grep -c '": "' metadata/manifest.json) entries)"
echo "  soul/neural_soul.md → $(shasum -a 256 soul/neural_soul.md | awk '{print $1}')"
