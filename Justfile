# jankurai-standard root command surface.
# One-command setup and validation lanes for agents and CI.
# This repository is a standard/documentation member of the Jankurai split
# family: there is no Rust crate or Node package to build here, so every lane is
# a deterministic, hermetic documentation-presence and self-audit proof loop
# that runs from the repository root.

# Default: list available lanes.
default:
    @just --list

# One-command bootstrap: this docs repo needs no compiler toolchain, so setup
# resolves the local CI helpers and confirms the required proof inputs exist.
setup:
    bash scripts/ci-local.sh required

# Alias for setup so `just install` and `just bootstrap` also resolve.
install: setup

bootstrap: setup

# Deterministic fast lane: the narrowest proof loop for agent iteration.
# Runs the required documentation-presence checks and the jankurai self-audit.
# The audit is scoped to changed files (--changed-fast) so iteration stays fast,
# and the jankurai score cache (.jankurai/repo-score.json) is reused as a build
# acceleration marker between runs.
fast:
    bash ops/ci/fast.sh
    jankurai audit . --no-score-history --changed-fast --json .jankurai/repo-score.json --md .jankurai/repo-score.md

# Run the full local check: documentation presence, fast lane, security, audit.
check: fmt lint fast drift security audit

# Verify is an alias of check for agents that look for a `verify` lane.
verify: check

# Format check: there is no source to format in this docs repo, so this lane
# confirms the documentation presence contract instead.
fmt:
    bash ops/ci/required.sh

# Lint: validate the required standard documents are present and routed.
lint:
    bash ops/ci/required.sh

# Run the required documentation proof suite.
test:
    bash ops/ci/required.sh

# Targeted, narrow proof lanes for fast agent iteration. When a Rust or Node
# product surface lands in this repo, these per-package commands keep the proof
# loop fast and incremental; until then they run the scoped jankurai audit.
# Targeted markers: cargo check -p, cargo nextest run -p, vitest run, pytest -k.
narrow:
    jankurai audit . --no-score-history --changed-fast --json target/jankurai/fast-score.json --md target/jankurai/audit-fast.json
    # cargo check -p <crate> --locked   # narrow per-package check when Rust lands
    # cargo nextest run -p <crate>      # targeted test lane
    # vitest run <file>                 # targeted web test lane

# Security lane: secret scanning plus dependency scanning of any committed
# lockfiles. gitleaks scans for committed secrets; cargo audit and npm audit
# guard dependency manifests if a future change adds them.
security:
    bash tools/security-lane.sh

# openapi-diff style inventory of published standard documents.
drift:
    bash ops/ci/contract-drift.sh # openapi-diff over docs/ and agent/

# Jankurai self-audit lane: writes the repo-score artifacts that CI uploads.
audit:
    bash ops/ci/audit.sh

# Print the declared version.
versions:
    cat VERSION
