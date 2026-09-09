#!/usr/bin/env bash
# Canonical security lane wrapper for jankurai-standard.
#
# This repository ships standard text and agent maps, so its security posture is:
#  - secret scanning of the committed tree (gitleaks detect),
#  - workflow linting of the CI definitions (actionlint),
#  - cargo audit / npm audit when a future manifest appears,
#  - and a software bill of materials enumerating + hashing every published doc
#    (syft-style SBOM via sha256 over docs/ and agent/).
# The same lane runs locally via `just security` and in CI via ops/ci/security.sh.
set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p target

echo "[security] secret scan: gitleaks detect"
gitleaks detect --source . --no-banner --redact

echo "[security] workflow lint: actionlint"
actionlint

if [ -f Cargo.toml ]; then
  echo "[security] cargo audit"
  cargo audit
fi

if [ -f package.json ]; then
  echo "[security] npm audit"
  npm audit --audit-level=high
fi

echo "[security] SBOM / provenance: hash every published standard file"
# syft-equivalent: a hashed bill of materials of every shipped document.
find docs agent README.md AGENTS.md -type f | sort | xargs sha256sum > target/sbom.txt
echo "[security] sbom written to target/sbom.txt"
