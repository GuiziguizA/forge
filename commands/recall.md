---
description: Interroge la mémoire de fabrique (vault Obsidian) pour réutiliser un acquis avant d'agir
argument-hint: <sujet à rechercher>
---

# /forge:recall

Recherche dans le **vault de fabrique** (défaut `~/forge-brain`, ou `$FORGE_VAULT`) avant de concevoir ou coder, pour réutiliser plutôt que réinventer. Suis le skill `obsidian-vault`.

Sujet : $ARGUMENTS

## Procédure
1. Pars de `<vault>/index.md`, puis suis les `[[wikilinks]]` pertinents (patterns, ADR, postmortems, conventions de stack).
2. Recherche par mots-clés dans les notes du vault (Grep), filtre par frontmatter (tags/statut) si utile.
3. Synthétise ce qui est réutilisable pour le sujet : patterns applicables, décisions passées, pièges déjà rencontrés.

## Sortie
- Un résumé actionnable : « voici ce que la fabrique sait déjà sur <sujet> ».
- Les pages sources (chemins/liens).
- Si rien de pertinent : le dire clairement, et proposer de mémoriser le sujet via `/forge:remember` une fois traité.

Ce contexte alimente la couche tâche (just-in-time) d'un `/forge:design` ou `/forge:build` qui suit.
