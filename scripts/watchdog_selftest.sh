#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${1:-4174}"
"$ROOT_DIR/scripts/serve_supervised.sh" "$PORT" &
SUPERVISOR_PID=$!
cleanup(){ kill "$SUPERVISOR_PID" 2>/dev/null || true; wait "$SUPERVISOR_PID" 2>/dev/null || true; }
trap cleanup EXIT
for _ in {1..20}; do [[ -f "$ROOT_DIR/.server-child.pid" ]] && break; sleep .25; done
FIRST_PID="$(cat "$ROOT_DIR/.server-child.pid")"
kill -9 "$FIRST_PID"
for _ in {1..30}; do
  sleep .25
  SECOND_PID="$(cat "$ROOT_DIR/.server-child.pid" 2>/dev/null || true)"
  if [[ -n "$SECOND_PID" && "$SECOND_PID" != "$FIRST_PID" ]] && kill -0 "$SECOND_PID" 2>/dev/null; then
    curl -fsS "http://127.0.0.1:$PORT/" 2>/dev/null | grep -q 'Folio Studio' && break
  fi
done
[[ -n "${SECOND_PID:-}" && "$SECOND_PID" != "$FIRST_PID" ]]
curl -fsS "http://127.0.0.1:$PORT/" | grep -q 'Folio Studio'
printf 'PASS: child %s was replaced by %s and the app responds.\n' "$FIRST_PID" "$SECOND_PID"
