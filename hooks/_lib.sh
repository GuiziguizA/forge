#!/usr/bin/env bash
# Forge hooks — helpers partagés.
# Extraction JSON portable : jq > python3 > sed. Évite une dépendance dure à jq
# (un garde-fou qui plante ne doit pas échouer en mode ouvert).
# Usage : FORGE_INPUT contient le JSON (stdin) ; forge_json_get ".a.b"

forge_json_get() {
  local key="$1"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$FORGE_INPUT" | jq -r "${key} // empty" 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "$FORGE_INPUT" | FORGE_KEY="$key" python3 -c '
import os, sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
cur = d
for p in [x for x in os.environ.get("FORGE_KEY", "").split(".") if x]:
    if isinstance(cur, dict) and p in cur:
        cur = cur[p]
    else:
        sys.exit(0)
sys.stdout.write(cur if isinstance(cur, str) else "")
' 2>/dev/null
  else
    printf '%s' "$FORGE_INPUT" \
      | sed -n 's/.*"'"${key##*.}"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
      | head -n1
  fi
}
