#!/usr/bin/env bash
# Security lane tool runner for jankurai-standard.
#
# Runs the secret, dependency, SBOM/provenance, and workflow-hardening scanners
# declared in agent/security-policy.toml for the requested profile and folds the
# results into the jankurai security evidence envelope. This docs/standard repo
# has no dependency manifest of its own, so the dependency and SBOM scanners are
# guarded by manifest presence; the secret scan and workflow-hardening scan
# always run.
#
# Profiles: local | ci | release (see agent/security-policy.toml).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

profile="${1:-ci}"

echo "[security-lane] profile=$profile: secret scan (gitleaks)"
gitleaks detect --source . --no-banner --redact

echo "[security-lane] profile=$profile: workflow hardening scan (zizmor)"
zizmor .github/workflows

if [ -f Cargo.toml ]; then
  echo "[security-lane] cargo audit + cargo deny (Rust dependency advisories)"
  cargo audit
  cargo deny check advisories bans sources
fi

if [ -f package.json ]; then
  echo "[security-lane] npm audit (Node dependency advisories)"
  npm audit --audit-level=high
fi

echo "[security-lane] SBOM + vulnerability scan (syft + grype / trivy)"
if command -v syft >/dev/null 2>&1; then
  syft . -o cyclonedx-json=target/jankurai/security/sbom.json
fi
if command -v grype >/dev/null 2>&1; then
  grype dir:. --fail-on high
elif command -v trivy >/dev/null 2>&1; then
  trivy fs --severity HIGH,CRITICAL .
fi

echo "[security-lane] normalize evidence (jankurai security run)"
mkdir -p target/jankurai/security
jankurai security run . --strict --profile "$profile" --out target/jankurai/security/evidence.json
