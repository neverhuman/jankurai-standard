# Security tool matrix

The executable policy is [`agent/security-policy.toml`](../agent/security-policy.toml).
Local, CI, and release profiles require the same applicable scanners. Run
`bash scripts/ci-local.sh security` or `just security` after installing the
versions selected in `ops/ci/github-setup.sh` and `.github/workflows/ci.yml`.

| Tool | Required outcome |
| --- | --- |
| Gitleaks 8.21.2 | Secret scan succeeds and writes SARIF |
| zizmor 1.25.2 | SARIF is valid and contains no findings or failed invocation |
| actionlint 1.7.8 | Workflow validation succeeds |
| Syft 1.40.0 | A fresh CycloneDX 1.6 inventory is produced |
| Offline CycloneDX validator | Schema, timestamp, producer, and inventory checks pass |
| Grype 0.99.0 | No inventory vulnerabilities at or above high severity |
| cargo-audit 0.22.1 and cargo-deny 0.19.8 | Both succeed when Cargo.toml is present |
| npm audit | No locked Node dependency vulnerabilities at or above high severity |

These tools are blocking. Missing tools and invalid outputs fail the lane.
The private Node package contains CI schema validators; `npm ci` uses the
committed lock before tests and scanning. A manifest without its lock fails.

The canonical command body is [`tools/security-lane.sh`](../tools/security-lane.sh).
`ops/ci/security.sh` invokes it once through the strict auditor wrapper. Each
run retains its own `target/jankurai/security/run.*` directory, including
failed results. Stable SARIF and SBOM names are published only after every
applicable scanner succeeds. CI uploads them in `quality-evidence` even when
later checks fail.

Source scanning does not produce release signatures, notarization, or verified
execution authority. The hub release pipeline must separately qualify and sign
the actual distributed assets; see [release process](release.md).
