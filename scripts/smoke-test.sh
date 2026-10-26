#!/usr/bin/env bash
set -euo pipefail
BASE_URL="${BASE_URL:-http://127.0.0.1:8080}"

printf 'Checking application endpoint... '
curl --fail --silent --show-error "$BASE_URL/" >/dev/null
printf 'OK\n'
printf 'Checking health endpoint... '
curl --fail --silent --show-error "$BASE_URL/healthz" >/dev/null
printf 'OK\n'
printf 'Checking metrics endpoint... '
curl --fail --silent --show-error "$BASE_URL/metrics" | grep -q 'http_requests_total'
printf 'OK\n'
printf 'Checking intentional failure endpoint (expects HTTP 500)... '
status="$(curl --silent --output /dev/null --write-out '%{http_code}' "$BASE_URL/fail")"
[[ "$status" == "500" ]] || { echo "expected 500, received $status"; exit 1; }
printf 'OK\n'
