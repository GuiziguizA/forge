# Changelog — Forge

Format inspiré de [Keep a Changelog](https://keepachangelog.com/). Versions en SemVer.

## [0.2.0] — non publié

### Ajouté
- **Skills C# par couche** (7) dérivés du projet Aparte, génériques .NET avec ancrages concrets :
  `csharp-api-layer`, `csharp-application-layer`, `csharp-mapping-layer`,
  `csharp-persistence-layer`, `csharp-domain-layer`, `csharp-testing-layer`,
  `csharp-contracts-integration`.
- **Gate build** dans `hooks/post-edit.sh` via `FORGE_BUILD_CMD` (ex. `dotnet build -warnaserror`,
  bloquante avant les tests) — standard « 0 erreur / 0 warning ».
- **Smoke-test du plugin** : `scripts/smoke-test.sh` (source unique) + `scripts/smoke-test.ps1`
  (lanceur PowerShell / Windows). Valide structure, frontmatter des skills, cohérence
  hooks.json ↔ scripts, et comportement bloquant des gardes.
- `CHANGELOG.md`.
- **Connecteurs MCP** : `.mcp.json.example` (serveurs `gitlab` + `grafana`/observabilité), à copier dans le projet.

### Modifié
- `skills/stack-defaults` renvoie désormais vers les skills C# par couche.
- `agents/implementer` applique le skill `csharp-*` de la couche touchée.
- `settings.example.json` documente `FORGE_TEST_CMD` (`dotnet test`) et `FORGE_BUILD_CMD`.
- `README.md` : liste des skills, variable `FORGE_BUILD_CMD`, prérequis git-bash sous Windows, section smoke-test.
- `commands/deploy` : câblage pipeline GitLab CI (build → test → lint → package) via connecteur MCP `gitlab` si présent.
- `commands/status` : `--trace` corrèle les tokens/coût par `prompt.id` via connecteur MCP `grafana`/`datadog`.
- `hooks/vault-compile.sh` : validation frontmatter durcie (clés requises `tags`/`status`/`created`, plus seulement la fence).

## [0.1.0]
- Version initiale : 8 commandes, 6 agents, 5 skills, 9 hooks, vault Obsidian, télémétrie OTEL.
