#!/usr/bin/env bash
# Run the actual adopted policy and proof commands; any failure blocks CI.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"
mkdir -p target/jankurai target/jankurai/proofbind .jankurai

# proofbind: changed-surface proof obligation routing.
log "tool-adoption: proof plan and required proofbind"
bash ops/ci/proof.sh
# Adopted artifacts: target/jankurai/proofbind/surface-witness.json
# target/jankurai/proofbind/obligations.json

log "tool-adoption: ratchet audit with repair queue"
jankurai audit . --mode ratchet --baseline target/jankurai/accepted-baseline.json --json target/jankurai/repo-score.json --md target/jankurai/repo-score.md --repair-queue-jsonl target/jankurai/repair-queue.jsonl --full
# Adopted artifacts: .jankurai/repo-score.json .jankurai/repo-score.md
# target/jankurai/repair-queue.jsonl
cp -f target/jankurai/repo-score.json .jankurai/repo-score.json
cp -f target/jankurai/repo-score.md .jankurai/repo-score.md
