#!/usr/bin/env bash
# Forge — smoke-test du plugin.
# Valide la structure (manifest, commandes, agents, skills, hooks), le frontmatter
# des skills, la cohérence hooks.json ↔ scripts, et le comportement bloquant des
# gardes (read-guard / pre-deploy-gate). Sortie : 0 si tout passe, 1 sinon.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pass=0; fail=0
ok()   { printf '  ✓ %s\n' "$1"; pass=$((pass+1)); }
ko()   { printf '  ✗ %s\n' "$1"; fail=$((fail+1)); }
have() { [ -f "$ROOT/$1" ] && ok "$1" || ko "manquant: $1"; }

echo "== Manifest =="
have ".claude-plugin/plugin.json"

echo "== Commandes =="
for c in spec design build review deploy status remember recall; do have "commands/$c.md"; done

echo "== Agents =="
for a in product-analyst solution-architect implementer qa-reviewer security-auditor sre-deployer; do have "agents/$a.md"; done

echo "== Skills (frontmatter name + description) =="
for d in "$ROOT"/skills/*/SKILL.md; do
  [ -f "$d" ] || continue
  rel="skills/$(basename "$(dirname "$d")")/SKILL.md"
  head -n 8 "$d" | grep -q '^name:' && head -n 8 "$d" | grep -q '^description:' \
    && ok "$rel (frontmatter)" || ko "$rel : frontmatter name/description incomplet"
done

echo "== Skills C# par couche présents =="
for s in api application mapping persistence domain testing contracts-integration; do
  case "$s" in contracts-integration) dir="csharp-contracts-integration";; *) dir="csharp-${s}-layer";; esac
  have "skills/$dir/SKILL.md"
done

echo "== Hooks référencés par hooks.json existent =="
hj="$ROOT/hooks/hooks.json"
if [ -f "$hj" ]; then
  ok "hooks/hooks.json"
  for h in read-guard pre-deploy-gate skill-trace post-edit decision-logger vault-compile; do
    grep -q "hooks/$h.sh" "$hj" && have "hooks/$h.sh" || ko "hooks/$h.sh non référencé dans hooks.json"
  done
else
  ko "manquant: hooks/hooks.json"
fi

echo "== Garde lecture secrets (read-guard → exit 2) =="
printf '%s' '{"tool_input":{"file_path":"/tmp/app/.env"}}' | bash "$ROOT/hooks/read-guard.sh" >/dev/null 2>&1
[ $? -eq 2 ] && ok "read-guard bloque .env (exit 2)" || ko "read-guard ne bloque pas .env"

echo "== Garde déploiement prod (pre-deploy-gate → exit 2 sans approbation) =="
# Commande reconnue par le matcher (docker push) + cible prod ; pas de .forge/.deploy-approved en CWD.
( cd "$(mktemp -d)" && printf '%s' '{"tool_input":{"command":"docker push registry/app:prod"}}' | bash "$ROOT/hooks/pre-deploy-gate.sh" >/dev/null 2>&1 )
rc=$?; [ "$rc" -eq 2 ] && ok "pre-deploy-gate bloque prod (exit 2)" || ko "pre-deploy-gate ne bloque pas prod (exit $rc)"

echo
echo "Résultat : $pass OK, $fail KO"
[ "$fail" -eq 0 ]
