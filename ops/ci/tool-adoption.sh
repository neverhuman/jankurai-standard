#!/usr/bin/env bash
# Run the actual adopted policy and proof commands; any failure blocks CI.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"
mkdir -p target/jankurai .jankurai
log "tool-adoption: proof plan and required proofbind"
bash ops/ci/proof.sh
log "tool-adoption: ratchet audit with repair queue"
jankurai audit . --mode ratchet --baseline target/jankurai/accepted-baseline.json --json target/jankurai/repo-score.json --md target/jankurai/repo-score.md --repair-queue-jsonl target/jankurai/repair-queue.jsonl --full
cp -f target/jankurai/repo-score.json .jankurai/repo-score.json
cp -f target/jankurai/repo-score.md .jankurai/repo-score.md
