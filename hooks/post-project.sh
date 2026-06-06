#!/usr/bin/env bash
# Forge — post-project (utilitaire, appelé par /forge:remember ; pas un hook d'événement).
# Copie le brut du projet courant vers <vault>/_raw/ pour compilation par l'agent.
# Usage : bash post-project.sh [nom-projet]

vault="${FORGE_VAULT:-$HOME/forge-brain}"
proj="${1:-$(basename "$PWD")}"
ts="$(date -u +%FT%TZ)"
raw="$vault/_raw/${proj}-$(date -u +%Y%m%d-%H%M%S)"

mkdir -p "$raw" || { echo "post-project : impossible de créer $raw" >&2; exit 1; }

[ -d ".forge/decisions" ]            && cp -r .forge/decisions "$raw/decisions" 2>/dev/null || true
[ -f ".forge/spec/SPEC.md" ]         && cp ".forge/spec/SPEC.md" "$raw/SPEC.md" 2>/dev/null || true
[ -f ".forge/design/ARCHITECTURE.md" ] && cp ".forge/design/ARCHITECTURE.md" "$raw/ARCHITECTURE.md" 2>/dev/null || true
[ -f ".forge/traceability.md" ]      && cp ".forge/traceability.md" "$raw/traceability.md" 2>/dev/null || true
[ -f ".forge/telemetry/skills.jsonl" ] && cp ".forge/telemetry/skills.jsonl" "$raw/skills.jsonl" 2>/dev/null || true

{ echo "# Snapshot $proj — $ts"; echo; echo "Source : $PWD"; } > "$raw/_meta.md"
echo "post-project : brut copié dans $raw — à compiler via le skill obsidian-vault (/forge:remember)."
exit 0
