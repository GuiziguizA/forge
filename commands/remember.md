---
description: Distille les apprentissages du projet courant vers la mémoire de fabrique (vault Obsidian)
argument-hint: [sujet ou note à mémoriser]
---

# /forge:remember

Alimente le **vault de fabrique** (défaut `~/forge-brain`, ou `$FORGE_VAULT`) selon le pattern LLM Wiki de Karpathy. Suis le skill `obsidian-vault`.

Sujet ciblé : $ARGUMENTS (si vide, distille l'ensemble du projet courant).

## Procédure
1. Lance `${CLAUDE_PLUGIN_ROOT}/hooks/post-project.sh` : il copie les décisions et un instantané du projet dans `<vault>/_raw/`.
2. **Compile** (toi, l'agent) le brut de `_raw/` en pages markdown interconnectées :
   - `patterns/` (archi réutilisable), `domains/` (métier), `stacks/` (conventions), `postmortems/` (ce qui a marché/cassé), `decisions/` (synthèses), `projects/` (note du projet).
   - Relie par `[[wikilinks]]`, ajoute le frontmatter (tags, statut, date, projet).
3. Mets à jour `index.md` (le sommaire/point d'entrée).
4. Ne duplique pas : si une page existe, enrichis-la plutôt que d'en créer une nouvelle.

## Sortie
Liste les pages créées/mises à jour et les nouveaux liens. Rappelle la limite : au-delà de ~400k mots, segmenter en sous-vaults thématiques.
