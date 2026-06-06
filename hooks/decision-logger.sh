#!/usr/bin/env bash
# Forge — decision-logger
# PostToolUse / "Edit|Write|MultiEdit" : valide le format des decision logs (exit 2 sinon).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_lib.sh"

FORGE_INPUT="$(cat)"; export FORGE_INPUT
path="$(forge_json_get '.tool_input.file_path')"
[ -z "$path" ] && exit 0

case "$path" in
  */.forge/decisions/*.md|.forge/decisions/*.md) ;;
  *) exit 0 ;;
esac
[ -f "$path" ] || exit 0

missing=""
for section in "## Décision" "## Justification" "## Alternatives écartées" "## Impact"; do
  grep -qF "$section" "$path" 2>/dev/null || missing="$missing"$'\n'"  - $section"
done
if [ -n "$missing" ]; then
  echo "Forge decision-logger : decision log incomplet -> $path" >&2
  printf 'Sections manquantes :%s\n' "$missing" >&2
  echo "Format attendu : Décision / Justification / Alternatives écartées / Impact." >&2
  exit 2
fi
exit 0
