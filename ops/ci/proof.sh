#!/usr/bin/env bash
# Qualify changed-surface proof obligations with proofbind (Core-compatible).
# Paper#3 main uses the same lane. Required-mode cannot pass here yet: prove
# receipts lack rules_covered, so proofbind reports 42 missing surface obligations
# even after prove/verify pass (hosted a7df5a7 / 8dc502c evidence).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."
base="$(bash ops/ci/comparison-base.sh)"
mkdir -p target/jankurai/proofbind
jankurai proofbind verify . --changed-from "$base"
