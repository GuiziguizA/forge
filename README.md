# Forge — Agentic Software Factory (plugin Claude Code) · v0.2.0

Chaîne **idée → spec → design → code testé → revue → déploiement**, avec standards d'ingénierie **imposés par règles déterministes** (hooks + permissions) et une **mémoire de fabrique** durable (vault Obsidian, pattern LLM Wiki).

## Structure complète

```
forge/
├── .claude-plugin/plugin.json
├── commands/      # spec, design, build, review, deploy, status, remember, recall
├── agents/        # product-analyst, solution-architect, implementer, qa-reviewer,
│                  # security-auditor, sre-deployer
├── skills/        # engineering-standards, spec-conventions, stack-defaults,
│                  # context-architecture, obsidian-vault,
│                  # csharp-{api,application,mapping,persistence,domain,testing,contracts-integration}-layer
├── hooks/         # hooks.json + _lib.sh + read-guard, pre-deploy-gate, post-edit,
│                  # decision-logger, vault-compile, skill-trace, post-project
├── settings.example.json   # permissions + télémétrie + FORGE_VAULT à fusionner
└── README.md
```

## Le workflow

| Phase | Commande | Agent | Gate humain |
|-------|----------|-------|-------------|
| Spec | `/forge:spec <besoin>` | product-analyst | ✅ valider la spec |
| Design | `/forge:design` | solution-architect | ✅ valider l'archi (ADRs) |
| Build | `/forge:build [cible]` | implementer | — (itératif) |
| Review | `/forge:review` | qa-reviewer (+ security-auditor) | ✅ verdict GO/NO-GO |
| Deploy | `/forge:deploy <env>` | sre-deployer | ✅ prod uniquement |
| Mémoire | `/forge:recall <sujet>` / `/forge:remember` | — | — |
| État | `/forge:status [--trace]` | — | — |

## Règles déterministes (hooks)

| Hook | Événement / matcher | Effet |
|------|----------------------|-------|
| `read-guard.sh` | PreToolUse `Read` | Bloque la lecture de secrets (exit 2) |
| `pre-deploy-gate.sh` | PreToolUse `Bash` | Bloque un déploiement **prod** sans `.forge/.deploy-approved` (exit 2) |
| `post-edit.sh` | PostToolUse `Edit\|Write\|MultiEdit` | Formate + tests non-régression si `FORGE_TEST_CMD` (bloquant) |
| `decision-logger.sh` | PostToolUse `Edit\|Write\|MultiEdit` | Valide le format des decision logs `.forge/decisions/*.md` |
| `vault-compile.sh` | PostToolUse `Edit\|Write\|MultiEdit` | Maintient `index.autogen.md` du vault + avertit si frontmatter manquant |
| `skill-trace.sh` | PreToolUse `Skill` + UserPromptExpansion | Journalise les skills activés dans `.forge/telemetry/skills.jsonl` |
| `post-project.sh` | (utilitaire, appelé par `/forge:remember`) | Copie le brut du projet vers `<vault>/_raw/` |

Principe : une description de skill est une *suggestion* (déclenchement sémantique) ; un hook est une *garantie* (déclenchement déterministe). Les non-négociables passent en hooks.

## Les couches de contexte (skill `context-architecture`)
1. Standards globaux (`engineering-standards`, always-on)
2. Contexte projet (`CLAUDE.md` + `stack-defaults`)
3. Contexte tâche (just-in-time : spec / archi / `recall`)
4. Mémoire de fabrique durable (vault Obsidian via `obsidian-vault`)

## Installation
1. `chmod +x hooks/*.sh`
2. Charger le plugin : `/plugin` dans Claude Code, ou pointer le SDK sur le dossier racine `forge/`.
3. Fusionner `settings.example.json` dans `.claude/settings.json` du projet.
4. Variables utiles : `FORGE_TEST_CMD` (tests bloquants, ex. `dotnet test`), `FORGE_BUILD_CMD` (gate build bloquante, ex. `dotnet build -warnaserror`), `FORGE_VAULT` (chemin du vault, défaut `~/forge-brain`).

### Dépendances runtime
- **bash requis** : les hooks sont en bash. Sous **Windows**, installer **Git for Windows** (git-bash) — `hooks.json` appelle `bash …`. Vérifier l'installation avec `scripts/smoke-test.ps1` (lanceur PowerShell qui délègue au smoke-test bash).
- Recommandé : `jq`. **Non obligatoire** : les hooks retombent sur `python3` puis `sed`.
- Optionnel selon la stack : `dotnet format`, `prettier`, `ruff`, `gofmt`, `rustfmt`.

### Smoke-test
- `bash scripts/smoke-test.sh` (ou `scripts/smoke-test.ps1` sous Windows) : valide structure, frontmatter des skills, cohérence `hooks.json` ↔ scripts, et le comportement bloquant des gardes (`read-guard`, `pre-deploy-gate`).

## Observabilité (skills + tokens)
`skill-trace` donne le *quel skill / quand*. Pour le *coût en tokens par prompt*, activer la télémétrie OTEL (variables dans `settings.example.json`) et corréler via l'attribut `prompt.id` côté backend (Datadog/Grafana). L'attribution token exacte par skill n'est pas native ; granularité réaliste = *par prompt*. Voir `/forge:status --trace`.

## Notes
- Chemins internes via `${CLAUDE_PLUGIN_ROOT}` (portable).
- Permissions `settings.json` = défense en profondeur ; la garantie dure vient des scripts de hook.
- Claude Code : seul `exit 2` bloque (pas `exit 1`) ; `matcher` sensible à la casse.
- Agents en lecture seule (`qa-reviewer`, `security-auditor`) via `disallowedTools` → revue indépendante.
