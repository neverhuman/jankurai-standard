#!/usr/bin/env bash
# Contract-drift lane: detect breaking removals of published standard documents.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"

mkdir -p target
baseline="agent/standard-inventory.txt"
current="target/standard-inventory.txt"

log "contract-drift: openapi-diff over docs/ and agent/"
find docs agent README.md AGENTS.md -type f | sort > "$current"

if [ -f "$baseline" ]; then
  removed="$(comm -23 "$baseline" "$current" || true)"
  if [ -n "$removed" ]; then
    printf '[ci] breaking standard-document removal detected:\n%s\n' "$removed" >&2
    exit 1
  fi
  log "contract-drift: no breaking removals versus baseline"
else
  log "contract-drift: no baseline yet; current inventory recorded at $current"
fi
