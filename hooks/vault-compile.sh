#!/usr/bin/env bash
# Forge — vault-compile
# PostToolUse / "Edit|Write|MultiEdit" : sur une écriture dans le vault, maintient
# un index machine (index.autogen.md) et avertit si une note manque de frontmatter.
# Non destructif (ne touche pas index.md, curé par l'agent). Non bloquant (exit 0).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_lib.sh"

FORGE_INPUT="$(cat)"; export FORGE_INPUT
path="$(forge_json_get '.tool_input.file_path')"
[ -z "$path" ] && exit 0

vault="${FORGE_VAULT:-$HOME/forge-brain}"
case "$path" in
  "$vault"/*|*/forge-brain/*) ;;
  *) exit 0 ;;
esac

# 1) Avertir si note sans frontmatter (non bloquant)
case "$path" in
  *.md) head -n1 "$path" 2>/dev/null | grep -q '^---' || \
        echo "Forge vault-compile : note sans frontmatter -> $path (ajoute tags/status/created)." >&2 ;;
esac

# 2) Index machine régénéré (best-effort)
if [ -d "$vault" ]; then
  {
    echo "# Index auto-généré — $(date -u +%FT%TZ)"
    echo
    for d in patterns domains stacks postmortems decisions projects; do
      [ -d "$vault/$d" ] || continue
      echo "## $d"
      find "$vault/$d" -maxdepth 1 -name '*.md' 2>/dev/null | sort | while read -r f; do
        echo "- [[$d/$(basename "$f" .md)]]"
      done
      echo
    done
  } > "$vault/index.autogen.md" 2>/dev/null || true
fi
exit 0
