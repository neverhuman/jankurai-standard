# jankurai-standard root command surface.
# One-command setup and validation lanes for agents and CI.
# This repository is a standard/documentation member of the Jankurai split
# family: Node 24 runs the locked CI schema validator and rejection tests.
# The documentation-presence and self-audit proof loop
# that runs from the repository root.

# Default: list available lanes.
default:
    @just --list

# One-command bootstrap: this docs repo needs no compiler toolchain, so setup
# resolves the local CI helpers and confirms the required proof inputs exist.
setup:
    npm ci
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

# Run the full local check: documentation presence, fast lane, security, audit.
check:
    bash ops/ci/quality-gates.sh

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

# Run only the CI tooling's rejection tests for a short development loop.
narrow:
    npm test

# Run the blocking scanner and validated-inventory lane.
security:
    bash ops/ci/security.sh

# Detect deletion of published standard documents.
drift:
    bash ops/ci/contract-drift.sh

# Jankurai self-audit lane: writes the repo-score artifacts that CI uploads.
audit:
    bash ops/ci/audit.sh

# Print the declared version.
versions:
    cat VERSION
