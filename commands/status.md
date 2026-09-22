---
description: Affiche l'état du pipeline Forge (phases) et, avec --trace, la télémétrie skills/tokens par prompt
argument-hint: [--trace]
---

# /forge:status

## Mode par défaut
Affiche l'état du projet courant sous forme de pipeline, en t'appuyant sur le contenu de `.forge/` :

| Phase | Statut | Preuve |
|-------|--------|--------|
| Spec | ✅/⏳/—  | `.forge/spec/SPEC.md` présent et validé ? |
| Design | ✅/⏳/— | `.forge/design/ARCHITECTURE.md` + ADRs ? |
| Build | ✅/⏳/— | critères d'acceptation couverts + tests ? |
| Review | ✅/⏳/— | dernier verdict GO/NO-GO |
| Deploy | ✅/⏳/— | `.forge/.deploy-approved` + version déployée |

Liste aussi les ADRs ouverts, les critères d'acceptation non couverts, et les questions ouvertes de la spec.

## Mode --trace
Si `$ARGUMENTS` contient `--trace` : produis le tableau **observabilité** en joignant :
- `.forge/telemetry/skills.jsonl` (skills activés, trigger, session),
- la télémétrie OTEL (`claude_code.token.usage`) corrélée par `prompt.id` côté backend (Datadog/Grafana).

Tableau attendu : `prompt → skills déclenchés → tokens in/out/cache → coût`. Si la télémétrie OTEL n'est pas activée, indique-le et affiche au moins le récap des skills depuis le JSONL.

**Corrélation tokens (coût réel).** L'attribution token par skill n'est pas native ; granularité réaliste = **par prompt**. Si un connecteur MCP `grafana`/`datadog` est exposé (voir `.mcp.json.example`), interroge `claude_code.token.usage` corrélé par l'attribut `prompt.id` pour remplir les colonnes tokens/coût. Sinon, laisse-les vides et signale que seul le déclenchement (`skills.jsonl`) est disponible localement.
