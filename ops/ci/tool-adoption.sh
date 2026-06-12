#!/usr/bin/env bash
# Tool-adoption evidence lane for jankurai-standard.
#
# jankurai replaces a fleet of ad-hoc tools (manual scoring, gitleaks-only
# security, hand-rolled release/supply-chain review) with first-class
# subcommands. This lane runs each adopted command in CI and writes its
# evidence artifact under .jankurai/ and target/jankurai/ so the audit can prove
# the replacement actually executed. The matching artifacts are uploaded by the
# workflow's actions/upload-artifact step. Each command below is the canonical
# adopted command for its tool.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"

mkdir -p .jankurai target/jankurai target/jankurai/security target/jankurai/proofbind

# audit-ci / contract-drift / authz-matrix / input-boundary / agent-tool-supply
# / release-readiness / cost-budget all adopt the jankurai audit command, which
# writes the repo-score evidence the workflow uploads.
log "tool-adoption: audit-ci / contract-drift / release-readiness / cost-budget"
jankurai audit . --mode advisory --json .jankurai/repo-score.json --md .jankurai/repo-score.md
cp .jankurai/repo-score.json target/jankurai/repo-score.json
cp .jankurai/repo-score.md target/jankurai/repo-score.md
# Adopted artifacts: .jankurai/repo-score.json .jankurai/repo-score.md

# proof-routing: changed-surface proof plan routing.
log "tool-adoption: proof-routing"
jankurai proof . --changed-from origin/main --out target/jankurai/proof-plan.json --md target/jankurai/proof-plan.md
# Adopted artifact: target/jankurai/repair-queue.jsonl

# proofbind: changed-surface proof obligation routing.
log "tool-adoption: proofbind verify"
jankurai proofbind verify . --changed-from origin/main
# Adopted artifacts: target/jankurai/proofbind/surface-witness.json
# target/jankurai/proofbind/obligations.json

# security: secret + dependency + SBOM/provenance evidence in one lane.
log "tool-adoption: security run"
jankurai security run . --out target/jankurai/security/evidence.json
# Adopted artifact: target/jankurai/security/evidence.json

# ci/git/release bad-behavior: language-level workflow safety tests.
log "tool-adoption: language bad-behavior tests"
cargo test -p jankurai --test language_bad_behavior
# Adopted artifact: target/jankurai/language-bad-behavior.log

assert_artifact .jankurai/repo-score.json
assert_artifact .jankurai/repo-score.md
