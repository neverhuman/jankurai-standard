#!/usr/bin/env bash
# Security lane: secret scanning plus dependency vulnerability scanning.
# gitleaks scans the working tree for committed secrets. This docs repo commits
# no Cargo.toml or package.json, but the dependency-scan commands are wired so
# that if a future change adds a Rust or Node manifest the lane already runs
# cargo audit and npm audit against it. The same lane runs via `just security`.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"

log "security lane: gitleaks secret scan"
gitleaks detect --source . --no-banner --redact

if [ -f Cargo.toml ]; then
  log "security lane: cargo audit (Rust dependency advisories)"
  cargo audit
fi

if [ -f package.json ]; then
  log "security lane: npm audit (Node dependency advisories)"
  npm audit --audit-level=high
fi

# Supply-chain provenance and SBOM evidence. This docs repo has no dependency
# graph of its own; the jankurai security run normalizes secret, dependency,
# SBOM, and workflow-hardening signals into a single evidence envelope that the
# release gate consumes.
log "security lane: jankurai security run (SBOM + provenance evidence)"
mkdir -p target/jankurai/security
jankurai security run . --strict --profile ci --out target/jankurai/security/evidence.json --script ops/ci/security-scans.sh
