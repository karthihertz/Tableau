#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

test -f README.md
test -x .cursor/install.sh
test -f .cache/cloud-agent/bootstrap.stamp

HEAD="$(git rev-parse HEAD)"
test -n "$HEAD"

echo "Smoke test passed (commit ${HEAD:0:7}): git checkout and bootstrap artifacts verified."
