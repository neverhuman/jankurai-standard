# jankurai-standard

<!-- jankurai-badge:start -->
[![Jankurai score: 86/100](agent/jankurai-badge.svg)](agent/jankurai-badge.json)
<!-- jankurai-badge:end -->

Standard, mission, public conformance policy, and agent-native guidance text for
the **jankurai** auditor and merge control plane. This repository is one member
of the Jankurai split family; read [`SPLIT.md`](SPLIT.md) for the family contract
and [`AGENTS.md`](AGENTS.md) for agent routing rules.

## Stack

The standard this repository publishes targets a Rust core + TypeScript/React/Vite
product surface + PostgreSQL truth + generated contracts + exception-only Python
AI/data service. New implementation is Rust-first; see
[`docs/architecture.md`](docs/architecture.md) and
[`docs/boundaries.md`](docs/boundaries.md).

This repo itself is documentation-only: it ships the standard text, the audit
rubric, and the machine-readable maps that route agents through it. There is no
compiler toolchain to build here.

## Quick start

```bash
# One-command setup (resolve local CI helpers + required proof inputs).
just setup

# Deterministic fast lane (documentation presence + jankurai self-audit).
just fast

# Full local check: documentation presence, fast, security, and self-audit.
just check
```

The full command surface lives in the root [`Justfile`](Justfile). Continuous
integration runs the same lanes under
[`.github/workflows/ci.yml`](.github/workflows/ci.yml), which delegates to the
`ops/ci/*.sh` scripts.

## Layout

| Path | Role |
| --- | --- |
| `agent/` | machine-readable owner, test, boundary, and proof maps + standard metadata |
| `docs/` | mission, standard, audit rubric, architecture, boundaries, release, exceptions |
| `ops/` | pinned CI script entrypoints (`ops/ci/*.sh`) |
| `scripts/` | local CI runner that delegates to `ops/ci/*.sh` |

## Documentation

- [Architecture](docs/architecture.md)
- [Boundaries](docs/boundaries.md)
- [Testing and proof lanes](docs/testing.md)
- [Release process](docs/release.md)
- [Agent exceptions and overrides](docs/exceptions.md)
- [Mission](docs/mission.md)
- [Agent-native standard](docs/agent-native-standard.md)
- [Audit rubric](docs/audit-rubric.md)

## Versioning

The current version is recorded in [`VERSION`](VERSION) and the change history in
[`CHANGELOG.md`](CHANGELOG.md). Release mechanics are documented in
[`docs/release.md`](docs/release.md).

## License

See [`LICENSE`](LICENSE).
