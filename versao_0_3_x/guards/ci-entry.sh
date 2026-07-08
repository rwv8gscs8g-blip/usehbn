#!/usr/bin/env bash
set -euo pipefail
export HBN_CI=1
bash guards/hbn-guards-runner.sh
bash guards/tests/run-guard-tests.sh
bash guards/tests/adversarial-battery.sh
