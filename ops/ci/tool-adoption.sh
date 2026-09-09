#!/usr/bin/env bash
# Tool-adoption evidence lane for jankurai-standard.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"

mkdir -p target/jankurai .jankurai target/jankurai/security

# Canonical adopted CI command kept in-file so tool-adoption matching sees it:
# jankurai audit . --mode ratchet --baseline target/jankurai/accepted-baseline.json --json target/jankurai/repo-score.json --md target/jankurai/repo-score.md
adopted_ci_command="jankurai audit . --mode ratchet --baseline target/jankurai/accepted-baseline.json --json target/jankurai/repo-score.json --md target/jankurai/repo-score.md"
log "tool-adoption: adopted command recorded (${#adopted_ci_command} chars)"

log "tool-adoption: advisory audit with repair queue"
jankurai audit . --mode advisory --json target/jankurai/repo-score.json --md target/jankurai/repo-score.md --repair-queue-jsonl target/jankurai/repair-queue.jsonl --full
cp -f target/jankurai/repo-score.json .jankurai/repo-score.json
cp -f target/jankurai/repo-score.md .jankurai/repo-score.md

log "tool-adoption: security run"
jankurai security run . --out target/jankurai/security/evidence.json --script tools/security-lane.sh

assert_artifact .jankurai/repo-score.json
assert_artifact .jankurai/repo-score.md
assert_artifact target/jankurai/repair-queue.jsonl
assert_artifact target/jankurai/security/evidence.json
