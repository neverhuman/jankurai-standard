#!/usr/bin/env bash
# Security lane: secret scanning plus dependency vulnerability scanning.
# gitleaks scans the working tree for committed secrets. This docs repo commits
# no Cargo.toml or package.json, but the dependency-scan commands are wired so
# that if a future change adds a Rust or Node manifest the lane already runs
# cargo audit and npm audit against it. The same lane runs via `just security`.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"

log "security lane: tools/security-lane.sh"
bash tools/security-lane.sh

log "security lane: jankurai security run (SBOM + provenance evidence)"
mkdir -p target/jankurai/security
jankurai security run . --strict --profile ci --out target/jankurai/security/evidence.json --script tools/security-lane.sh
