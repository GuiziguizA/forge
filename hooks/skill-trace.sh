#!/usr/bin/env bash
# Forge — skill-trace
# PreToolUse "Skill" + UserPromptExpansion : journalise le skill activé.
# Observabilité-only : ne bloque jamais (exit 0).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_lib.sh"

FORGE_INPUT="$(cat)"; export FORGE_INPUT
ts="$(date -u +%FT%TZ)"
sid="$(forge_json_get '.session_id')"
cmd="$(forge_json_get '.command_name')"
skill="$(forge_json_get '.tool_input.name')"
[ -z "$skill" ] && skill="$(forge_json_get '.tool_input.skill')"
[ -z "$skill" ] && skill="$cmd"
[ -z "$skill" ] && exit 0

if [ -n "$cmd" ]; then trigger="slash"; else trigger="tool"; fi

mkdir -p .forge/telemetry 2>/dev/null || exit 0
printf '{"ts":"%s","session_id":"%s","skill":"%s","trigger":"%s"}\n' \
  "$ts" "$sid" "$skill" "$trigger" >> .forge/telemetry/skills.jsonl 2>/dev/null || true
exit 0
