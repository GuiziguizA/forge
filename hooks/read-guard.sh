#!/usr/bin/env bash
# Forge — read-guard
# PreToolUse / matcher "Read" : bloque la lecture de fichiers sensibles (exit 2).
# Les permissions settings.json sont la défense en profondeur.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_lib.sh"

FORGE_INPUT="$(cat)"; export FORGE_INPUT
path="$(forge_json_get '.tool_input.file_path')"
[ -z "$path" ] && exit 0

if printf '%s' "$path" | grep -qiE '(\.env($|\.[^/]*$)|/\.?secrets?/|\.pem$|\.key$|\.pfx$|id_rsa|credentials|\.npmrc$|\.aws/)'; then
  echo "Forge read-guard : lecture bloquée d'un fichier potentiellement sensible -> $path" >&2
  echo "Si c'est légitime, l'utilisateur doit le lire/fournir lui-même." >&2
  exit 2
fi
exit 0
