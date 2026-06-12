# Release process

This document is the release control surface for jankurai-standard. It covers the
version source, the changelog, the release automation, integrity and SBOM
evidence, and rollback. Launch gates require every section below to be backed by
a real artifact or command.

## Version source

The single source of truth for the version is the [`VERSION`](../VERSION) file at
the repository root. The release metadata in
[`agent/standard-version.toml`](../agent/standard-version.toml) and
[`agent/split-member.toml`](../agent/split-member.toml) and any release tag MUST
match `VERSION`. Tags follow the family pattern
`jankurai-standard-v<MAJOR.MINOR.PATCH>-split.<N>` as described in
[`SPLIT.md`](../SPLIT.md).

## Changelog

Every release records its user-visible changes in
[`CHANGELOG.md`](../CHANGELOG.md) under a heading that matches the new `VERSION`.
The `Unreleased` section is promoted to a dated version heading at tag time.

## Release automation

Releases are cut by CI, not by hand:

1. Bump [`VERSION`](../VERSION) and promote the `Unreleased` section of
   [`CHANGELOG.md`](../CHANGELOG.md).
2. Run the full local gate: `just check` (documentation presence, fast lane,
   security, self-audit).
3. Push the version commit. The
   [`ci.yml`](../.github/workflows/ci.yml) workflow runs the fast, security, and
   jankurai audit jobs and uploads the `repo-score` artifacts.
4. Tag the release commit with `jankurai-standard-v<version>-split.<N>`. The tag
   mirror in [`.jeryu/repo.toml`](../.jeryu/repo.toml) publishes the immutable tag
   to the public GitHub mirror.

Release builds depend on immutable tags, never branches.

## Integrity, provenance, and SBOM

- **Content integrity**: this is a documentation standard repo. Its integrity
  evidence is the committed `repo-score` artifacts produced by `just audit`,
  which pin the audited state of every standard document at the release commit.
- **SBOM**: the standard text has no runtime dependency graph. When a release
  bundles tooling, generate a CycloneDX software bill of materials with
  `cargo cyclonedx --format json` in the consuming tool repo and attach it as
  `sbom.json`; this repo records the standard the SBOM must conform to.
- **Provenance**: the security job runs `gitleaks detect` for secret scanning,
  and `cargo audit` / `npm audit` guard any dependency manifest a future change
  adds; the audit job publishes the `repo-score` artifacts that prove the release
  passed the jankurai gate.
- **Action pinning**: every third-party GitHub Action is pinned to a 40-character
  commit SHA so the supply chain of the release pipeline itself is fixed.

## Launch gates

A release of the standard is only cut once every launch gate below is backed by
a real artifact or command. Each gate is re-checked by `just check` and the
`ci.yml` audit job before a tag is published.

- **Security**: the security lane runs `gitleaks detect` for secret scanning and
  `cargo audit` / `npm audit` against any committed dependency manifest. Evidence
  is the `repo-score` artifact plus a clean security-lane log. See
  [`docs/security-tool-matrix.md`](security-tool-matrix.md).
- **Backups**: the authoritative content lives in the Jeryu repo and is mirrored
  to the public GitHub remote declared in [`.jeryu/repo.toml`](../.jeryu/repo.toml).
  Every release tag is an immutable, restorable backup of the standard at that
  commit; tags are never moved or deleted.
- **Monitoring**: rolling score history and the `repo-score` artifacts are the
  monitoring surface. `jankurai score diff` and `jankurai score trend` make score
  regressions, new findings, and cap changes observable before a tag is cut. See
  [`docs/rolling-score.md`](rolling-score.md).
- **Rollback**: the rollback procedure below restores any prior tagged release
  bit-for-bit.
- **Abuse controls**: branch protection, required reviews, and least-privilege
  agent ownership bound who and which agents may mutate the standard. See
  [`docs/branch-protection.md`](branch-protection.md) and
  [`agent/owner-map.json`](../agent/owner-map.json); overbroad agency is flagged
  by `HLT-012`.

## Rollback

If a release regresses:

1. Identify the last known-good tag (`jankurai-standard-v<version>-split.<N>`).
2. Re-point consumers at that immutable tag; tags are never moved or deleted.
3. Open a revert commit that restores the previous `VERSION` and `CHANGELOG.md`
   state, and add a `### Fixed` entry describing the rollback.
4. Re-run `just check` to confirm the rolled-back tree is green before
   re-publishing.

Because tags are immutable, any prior release of the standard can be restored
bit-for-bit from its tag.
