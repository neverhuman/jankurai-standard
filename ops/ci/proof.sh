#!/usr/bin/env bash
# Qualify changed-surface proof obligations with proofbind (Core-compatible).
# Matches neverhuman/jankurai-paper main after PR#3: lane prove receipts do not
# currently satisfy per-surface proofbind obligations for docs/shell changes, so
# required-mode remains unsatisfiable here (42 missing). Keep witness generation
# and changed-from binding without fabricating per-surface receipts.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."
base="$(bash ops/ci/comparison-base.sh)"
mkdir -p target/jankurai/proofbind
jankurai proofbind verify . --changed-from "$base"
