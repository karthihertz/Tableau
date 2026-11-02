#!/usr/bin/env bash
set -euo pipefail

SERVER="${SERVER:-https://tableau-qual.hertz.com}"
HOST="${SERVER#https://}"
HOST="${HOST#http://}"
HOST="${HOST%%/*}"

echo "Checking DNS for ${HOST}..."
if ! getent hosts "${HOST}" >/dev/null 2>&1; then
  echo "FAIL: ${HOST} did not resolve. Tableau QUAL is likely reachable only on corporate network/VPN."
  exit 1
fi

echo "Checking HTTPS to ${SERVER}..."
code="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 20 "${SERVER}/")"
echo "HTTP status: ${code}"

if [[ -z "${PAT_NAME:-}" || -z "${PAT_VALUE:-}" ]]; then
  echo "SKIP: Set PAT_NAME and PAT_VALUE to verify Tableau REST sign-in."
  exit 0
fi

if ! command -v python3 >/dev/null; then
  echo "SKIP: python3 required for REST sign-in check."
  exit 0
fi

python3 - <<'PY'
import os
import sys
import urllib.error
import urllib.request

server = os.environ.get("SERVER", "https://tableau-qual.hertz.com").rstrip("/")
site = os.environ.get("SITE_NAME", "")
pat_name = os.environ["PAT_NAME"]
pat_value = os.environ["PAT_VALUE"]

try:
    import tableauserverclient as TSC
except ImportError:
    print("Installing tableauserverclient for sign-in check...")
    import subprocess

    subprocess.check_call(
        [sys.executable, "-m", "pip", "install", "--quiet", "tableauserverclient"]
    )
    import tableauserverclient as TSC

auth = TSC.PersonalAccessTokenAuth(pat_name, pat_value, site_id=site or "")
server = TSC.Server(server, use_server_version=True)
with server.auth.sign_in(auth):
    print(f"OK: Signed in to {server.baseurl} (site content URL: {server.site_id})")
PY
