#!/usr/bin/env bash
# Required lane: the lightweight gate that must pass on every push.
# Verifies the canonical standard documents this repository publishes are
# present and routable, so downstream proof lanes never run against a gap.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT"

log "required lane: standard documentation presence"
assert_present docs/agent-native-standard.md
assert_present docs/mission.md
assert_present docs/audit-rubric.md
assert_present AGENTS.md
assert_present README.md
