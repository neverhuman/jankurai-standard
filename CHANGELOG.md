# Changelog

All notable changes to jankurai-standard are documented in this file. The format
is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
The authoritative version string lives in [`VERSION`](VERSION).

## [Unreleased]

### Added

- Root `Justfile` command surface with `setup`, `fast`, `check`, `verify`,
  `security`, and `audit` lanes for one-command setup and validation.
- GitHub Actions CI (`.github/workflows/ci.yml`) with deterministic fast,
  security, and jankurai audit jobs, all third-party actions pinned to commit
  SHAs and delegating to `ops/ci/*.sh`.
- `ops/ci/{lib,required,fast,security,audit,quality-gates}.sh` thin lane scripts
  shared by local runs and CI.
- Agent-readable release control surface: `VERSION`, `CHANGELOG.md`, and
  `docs/release.md` covering automation, integrity/SBOM, and rollback.
- Agent-friendly exception pattern in `docs/exceptions.md`.
- Root `README.md` routing to the standard, agent rules, and proof lanes.
- `agent/audit-policy.toml` declaring scan exclusions for transient and corpus
  paths in this docs repo.

### Changed

- Re-scoped `agent/owner-map.json`, `agent/test-map.json`, and
  `agent/generated-zones.toml` to the paths that exist in this docs-only repo,
  and added `agent/boundaries.toml` plus `agent/proof-lanes.toml` scoped to this
  repository.

## [1.7.0] - 2026-06-12

### Added

- Initial split-family extraction of the jankurai standard, mission, public
  conformance policy, and agent-native guidance corpus.
