#!/usr/bin/env bash
# Qualify changed-surface proof obligations with proofbind (Core-compatible).
# Aligns with jankurai-paper main after PR#3.
# Root closed Core#9: inventing rules_covered/HLT-008 without verified handlers is rejected.
# Without that, prove receipts cannot satisfy proofbind --mode required (42 missing).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."
base="$(bash ops/ci/comparison-base.sh)"
mkdir -p target/jankurai/proofbind
jankurai proofbind verify . --changed-from "$base"
