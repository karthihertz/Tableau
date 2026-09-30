#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

mkdir -p .cache/cloud-agent
date -u +%Y-%m-%dT%H:%M:%SZ > .cache/cloud-agent/bootstrap.stamp

echo "Tableau repository bootstrap complete."
