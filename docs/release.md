# Release process

GitHub is authoritative for `neverhuman/jankurai-standard`; `.jeryu/` records
historical integration metadata. Release tags preserve the family pattern
`jankurai-standard-v<MAJOR.MINOR.PATCH>-split.<N>` from [SPLIT.md](../SPLIT.md).

## Version and changelog

[`VERSION`](../VERSION), `agent/standard-version.toml`,
`agent/split-member.toml`, and the proposed tag must agree. Record actual changes
in [CHANGELOG.md](../CHANGELOG.md), then promote `Unreleased` to a dated version
section in the reviewed release commit. The private Node package identifies CI
tooling and is not a separately published product version.

## Qualification before tagging

1. Install the selected tools from `ops/ci/github-setup.sh` and the pinned
   workflow, use Node 24, and run `npm ci`.
2. Run `bash scripts/ci-doctor.sh`, then `just check`. This includes the baseline
   comparison, required tests, document inventory, strict security, actual proof
   execution and verification, required proofbind, and zero-drop ratchet.
   Resolve every failure.
3. Review the complete PR diff and exact-head `quality` and
   `jankurai-standard/required` results. Merge through protection, then verify
   the same checks on resulting main and its matching immutable `ci-<full-sha>`
   tag. Retain `quality-evidence` and source/tool identities.
4. Verify version agreement and the evidence below before creating the versioned
   release tag. Current `ci.yml` publishes qualification tags only; it does not
   create a versioned release or sign release assets.

Downstream releases select immutable qualified tags. A green aggregate alone
does not replace review of the actual required lane and its artifacts.

## Integrity, provenance, and SBOM

The strict security lane produces fresh SARIF and a CycloneDX 1.6 SBOM using
Syft, validates the inventory against pinned offline schemas, then runs Grype.
It includes the committed Node tooling dependencies. All applicable scanners
block; see [security tool matrix](security-tool-matrix.md).

CI uploads actual reports, proof receipts, security results, and SBOM in
`quality-evidence`. Bind a release inventory to the selected full commit/tree,
tool versions and digests, and exact artifact hashes. A score report is an audit
result, not a signature over every source byte or proof of supervised execution.
The public badge links its specific clean audited revision and
`agent/baselines/main.repo-score.provenance.json`.

## Launch gates

These release gates require evidence before publication:

- **Security:** successful blocking scanners, fresh validated SBOM, and successful
  proof and ratchet gates for the selected revision.
- **Backups:** retain immutable Git tags and an independently verified source
  archive or bundle. Verify restoration before relying on it as a backup.
- **Monitoring:** retain resulting-main check URLs, artifact hashes, score
  reports, and failure logs so changes and regressions can be inspected.
- **Rollback:** select the previous qualified immutable tag, as below.
- **Abuse controls:** enforce actual branch protections, least-privilege workflow
  permissions, and reviewed ownership in [branch protection](branch-protection.md).

These are release requirements; the ordinary quality job does not itself
rehearse backup restoration or publish signed release assets.

## Rollback

Point consumers to the previous qualified tag without changing any existing tag
or asset. If source correction is needed, open a revert PR, record the regression
and fix in the changelog, and run complete qualification again before publishing
a new version. Preserve failed-release evidence.
