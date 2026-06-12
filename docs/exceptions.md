# Agent exceptions and overrides

This document defines the agent-friendly exception pattern for jankurai-standard:
how an agent or maintainer requests, records, and bounds an override of a
standard rule. Exceptions are the only sanctioned way to deviate from the audit
baseline.

## Principle

The default answer is "follow the standard." An exception is a dated, owned,
expiring waiver for a specific rule on a specific path. Exceptions are data, not
prose: they live next to the artifact they govern and are reviewed on every
audit.

## How to request an exception

1. Identify the exact `rule_id` and `path` the exception applies to (from the
   audit JSON `findings[]`).
2. Add an entry to the relevant `agent/*.toml` manifest. For boundary
   reclassifications use [`agent/boundaries.toml`](../agent/boundaries.toml); for
   scan-scope exclusions use the `[scan]` table in
   [`agent/audit-policy.toml`](../agent/audit-policy.toml).
3. Every exception entry MUST carry:
   - `owner` — the team or person accountable.
   - `classification` — e.g. `brownfield`, `temporary`, `vendor`, `corpus`.
   - `expires` — an ISO date after which the exception is invalid and the audit
     fails again.
   - `migration_path` — the concrete plan to remove the exception.

## Example

A teaching-corpus document set under `docs/` (the intentional `BAD_*.md` files)
carries a documented scan exception in
[`agent/audit-policy.toml`](../agent/audit-policy.toml):

```toml
[[exception]]
rule = "HLT-*"
path = "docs/BAD_*.md"
classification = "corpus"
owner = "standard"
expires = "2026-12-31"
migration_path = "These files are intentional negative examples for the audit \
rubric; keep them excluded from product scans while the rubric references them."
```

## Override review

- Every exception is re-evaluated on each `just audit` run.
- An expired exception is treated as a hard finding, not a pass.
- Removing an exception requires deleting its entry and proving the underlying
  rule now passes on its own.

## What is never excepted

Secret leakage, destructive migrations without rollback, and hand-edits to
generated zones are never granted exceptions. Fix the underlying cause instead.
