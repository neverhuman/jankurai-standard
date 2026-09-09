#!/usr/bin/env bash
# Contract-drift lane: detect breaking removals of published standard documents.
set -euo pipefail
export LC_ALL=C
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"

mkdir -p target
baseline="agent/standard-inventory.txt"
current="target/standard-inventory.txt"

log "contract-drift: published document inventory over docs/ and agent/"
find docs agent README.md AGENTS.md -type f | sort > "$current"

if [ -f "$baseline" ]; then
  sort -u "$baseline" > target/standard-baseline.sorted.txt
  sort -u "$current" > target/standard-inventory.sorted.txt
  removed="$(comm -23 target/standard-baseline.sorted.txt target/standard-inventory.sorted.txt)"
  if [ -n "$removed" ]; then
    printf '[ci] breaking standard-document removal detected:\n%s\n' "$removed" >&2
    exit 1
  fi
  log "contract-drift: no breaking removals versus baseline"
else
  log "contract-drift: required committed baseline is missing: $baseline"
  exit 1
fi
