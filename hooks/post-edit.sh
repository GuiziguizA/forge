#!/usr/bin/env bash
# Forge — post-edit
# PostToolUse / "Edit|Write|MultiEdit" : formate (best-effort) + tests non-régression
# si FORGE_TEST_CMD défini (bloquant : exit 2 si rouge).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_lib.sh"

FORGE_INPUT="$(cat)"; export FORGE_INPUT
path="$(forge_json_get '.tool_input.file_path')"
[ -z "$path" ] && exit 0

case "$path" in
  *.cs|*.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rs) ;;
  *) exit 0 ;;
esac

# 1) Formatage best-effort (jamais bloquant)
case "$path" in
  *.cs)                  command -v dotnet  >/dev/null 2>&1 && dotnet format --include "$path" >/dev/null 2>&1 || true ;;
  *.ts|*.tsx|*.js|*.jsx) command -v npx     >/dev/null 2>&1 && npx --no-install prettier --write "$path" >/dev/null 2>&1 || true ;;
  *.py)                  command -v ruff    >/dev/null 2>&1 && ruff format "$path" >/dev/null 2>&1 || true ;;
  *.go)                  command -v gofmt   >/dev/null 2>&1 && gofmt -w "$path" >/dev/null 2>&1 || true ;;
  *.rs)                  command -v rustfmt >/dev/null 2>&1 && rustfmt "$path" >/dev/null 2>&1 || true ;;
esac

# 2) Gate build (bloquant si configurée) — standard « 0 erreur / 0 warning ».
# Ex. FORGE_BUILD_CMD="dotnet build -warnaserror". Lancée avant les tests : un
# build rouge rend les tests inutiles.
if [ -n "${FORGE_BUILD_CMD:-}" ]; then
  blog="$(mktemp)"
  if ! eval "$FORGE_BUILD_CMD" >"$blog" 2>&1; then
    echo "Forge post-edit : BUILD en ÉCHEC après modification de $path (warnings traités en erreurs ?). Corrige avant de continuer." >&2
    tail -n 30 "$blog" >&2
    exit 2
  fi
fi

# 3) Tests de non-régression (bloquant si configuré)
if [ -n "${FORGE_TEST_CMD:-}" ]; then
  log="$(mktemp)"
  if ! eval "$FORGE_TEST_CMD" >"$log" 2>&1; then
    echo "Forge post-edit : tests en ÉCHEC après modification de $path. Corrige avant de continuer." >&2
    tail -n 30 "$log" >&2
    exit 2
  fi
fi
exit 0
