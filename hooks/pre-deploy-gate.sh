#!/usr/bin/env bash
# Forge — pre-deploy-gate
# PreToolUse / matcher "Bash" : bloque un déploiement PROD sans approbation humaine (exit 2).
# Détection heuristique des commandes de déploiement.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_lib.sh"

FORGE_INPUT="$(cat)"; export FORGE_INPUT
cmd="$(forge_json_get '.tool_input.command')"
[ -z "$cmd" ] && exit 0

# Est-ce une commande de déploiement ?
printf '%s' "$cmd" | grep -qiE '(docker push|kubectl apply|helm (upgrade|install)|coolify|ansible-playbook|terraform apply|[[:space:]]publish|[[:space:]]deploy)' || exit 0

# Cible prod ?
if printf '%s' "$cmd" | grep -qiE '(prod|production)'; then
  if [ ! -f ".forge/.deploy-approved" ]; then
    echo "Forge pre-deploy-gate : déploiement PROD bloqué — approbation humaine requise." >&2
    echo "Après validation explicite, créer .forge/.deploy-approved (via /forge:deploy prod)." >&2
    exit 2
  fi
fi
exit 0
