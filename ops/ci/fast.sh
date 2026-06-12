#!/usr/bin/env bash
# Deterministic fast lane: the narrowest proof loop for agent iteration.
# This standard/docs repo has no compiler toolchain, so the fast lane runs the
# required documentation-presence checks and then the jankurai self-audit, which
# is the canonical deterministic proof for this repository. The identical
# command set is exposed locally via `just fast` and
# `bash scripts/ci-local.sh fast`.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"

log "fast lane: documentation presence + jankurai self-audit"
bash ops/ci/required.sh

# Scope the audit to changed files (--changed-fast) and reuse the cached score
# (.jankurai/repo-score.json) as a build acceleration marker so agent iteration
# stays in the narrow, deterministic proof loop.
mkdir -p .jankurai target/jankurai
jankurai audit . --no-score-history --changed-fast --json .jankurai/repo-score.json --md .jankurai/repo-score.md

assert_artifact .jankurai/repo-score.json
assert_artifact .jankurai/repo-score.md
