#!/usr/bin/env bash
# Canonical security lane wrapper for jankurai-standard.
#
# This repository ships standard text and agent maps. The operational posture is
# secret scanning, workflow lint, and a hashed bill of materials of published
# docs. Each executed required tool emits a `jankurai-security-step=` row so
# `jankurai security run --profile ci` can record evidence.
set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p target target/jankurai/security

run_step() {
    local label="$1"
    local tool="$2"
    local shell_command="$3"
    local advisory="$4"
    shift 4
    set +e
    "$@"
    local exit_code=$?
    set -e
    local status="ran"
    if [[ ${exit_code} -ne 0 ]]; then
        status="failed"
    fi
    printf 'jankurai-security-step={"label":"%s","tool":"%s","shell_command":"%s","status":"%s","advisory":%s,"exit_code":%d}\n' \
        "${label}" "${tool}" "${shell_command}" "${status}" "${advisory}" "${exit_code}"
    if [[ "${advisory}" == "true" ]]; then
        return 0
    fi
    return "${exit_code}"
}

echo "[security] secret scan: gitleaks detect"
run_step gitleaks gitleaks 'gitleaks detect --source . --no-banner --redact' false \
    gitleaks detect --source . --no-banner --redact

echo "[security] workflow lint: zizmor + actionlint"
run_step zizmor zizmor 'zizmor --no-progress .github/workflows' false \
    zizmor --no-progress .github/workflows
run_step actionlint actionlint 'actionlint' true \
    actionlint

if [[ -f Cargo.toml ]]; then
    echo "[security] cargo audit"
    run_step cargo-audit cargo-audit 'cargo audit' true \
        cargo audit
fi

if [[ -f package.json ]]; then
    echo "[security] npm audit"
    run_step npm npm 'npm audit --audit-level=high' true \
        npm audit --audit-level=high
fi

echo "[security] SBOM / provenance: hash every published standard file"
find docs agent README.md AGENTS.md -type f | sort | xargs sha256sum > target/sbom.txt
echo "[security] sbom written to target/sbom.txt"
